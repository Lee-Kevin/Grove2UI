/** 
 * Serial Call-Response 
 * by Tom Igoe. 
 * 
 * Sends a byte out the serial port, and reads 3 bytes in. 
 * Sets foregound color, xpos, and ypos of a circle onstage
 * using the values returned from the serial port. 
 * Thanks to Daniel Shiffman  and Greg Shakar for the improvements.
 * 
 * Note: This sketch assumes that the device on the other end of the serial
 * port is going to send a single byte of value 65 (ASCII A) on startup.
 * The sketch waits for that byte, then sends an ASCII A whenever
 * it wants more data. 
 */
 

import processing.serial.*;
import controlP5.*;
import java.util.*;
import g4p_controls.*;
import java.io.*;

GImageButton btnG2Button, btnG2Light, btnG29_Dof,btnG2Temp, btnG2Sound, btnG2LED, btnG2Buzzer;
GImageButton btnUpdate;

PImage bg;  

// Components
Serial myPort;// The serial port
ControlP5 cp5;
DropdownList COM_List;
GroveLogic grove;
int[] serialInArray = new int[3];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
int xpos, ypos;		             // Starting position of the ball
boolean firstContact = false;        // Whether we've heard from the microcontroller

JSONArray [] grove_files = new JSONArray[4];
String[] GroveFiles = {"grove/buzzer.json","grove/led_matrix.json","grove/button.json","grove/light.json"};
JSONObject json;


void setup() {
    size(1024, 560);  // Stage size
    //noStroke();      // No border on the next thing drawn
    cp5 = new ControlP5(this);
    bg = loadImage("background.png"); /* 背景图 */
      
    String[] files;
    
    files = new String[] {
        "G2_04_0.png","G2_04_1.png","G2_04_2.png"
    };
    btnG2Button = new GImageButton(this,104,420, files);
    
    files = new String[] {
        "G2_05_0.png","G2_05_1.png","G2_05_2.png"
    };
    btnG2Light = new GImageButton(this,233,420, files);

    files = new String[] {
        "G2_08_0.png","G2_08_1.png","G2_08_2.png"
    };
    btnG29_Dof = new GImageButton(this,316,420, files);

    files = new String[] {
        "G2_09_0.png","G2_09_1.png","G2_09_2.png"
    };
    btnG2Temp = new GImageButton(this,399,420, files);

    files = new String[] {
        "G2_10_0.png","G2_10_1.png","G2_10_2.png"
    };
    btnG2Sound = new GImageButton(this,482,420, files);    
    
    files = new String[] {
        "G2_06_0.png","G2_06_1.png","G2_06_2.png"
    };
    btnG2LED = new GImageButton(this,568,420, files);

    files = new String[] {
        "G2_07_0.png","G2_07_1.png","G2_07_2.png"
    };
    btnG2Buzzer = new GImageButton(this,709,420, files);      
    
    files = new String[] {
        "update_0.png","update_1.png","update_2.png"
    };
    
    btnUpdate = new GImageButton(this,910,420, files);      
    
    scan_serial_ports();
    
    grove = new GroveLogic();
    // grove_files[0] = loadJSONObject(GroveFiles[0]);

    //JSONArray value;
    //value = loadJSONArray("button.json");
    json = loadJSONObject("button.json");
}


void draw() {

    image(bg,0,0,1024,560);
    //bg.resize(1024,560);
    noStroke();
    rect(0,38,1023,150);
    color c1 = color(0,126,126,50);
    fill(c1);    
    rect(0,188,1023,150);
    color c2 = color(126,12,126,50);
    fill(c2);
    grove.initGrove();
}




public class GroveLogic {
    int[] __init_coor = new int[2];
    
    //String[] GroveFiles = new String[4];

    //Dictionary<String,String> Grove_Files = new Dictionary<String,String>();
    //Grove_Files.Add(0,"grove/buzzer.json");
    //Grove_Files.Add(1,"grove/led_matrix.json");
    
    
    int GroveItems = 0;
    color[] __colorGroup = new color[2];
    // __colorGroup[0] = color(0,126,126,102);
    // __colorGroup[1] = color(126,12,126,102);
    GroveLogic() {
        println("define the Grove Logic");
        initGrove();
    }
    
    void initGrove() {
        __init_coor[0] = 0;
        __init_coor[1] = 40;
        //grove_files[0] = loadJSONObject(GroveFiles[0]);
        println(grove_files[0]);
    }
    
    // public:
    
    void draw() {
        
    } 
    
    
    // private:
    

    
    void createItems() {
        
    }
    
}


// When a button has been clicked give information aout the 
// button
void handleButtonEvents(GImageButton button, GEvent event) {
    if (button == btnG2Button) {
        println("There is btn G2 Button pressed");
    } else if (button == btnG2Light) {
        println("There is btn G2 Light pressed");
    } else if (button == btnG29_Dof) {
        println("There is btn G2 9_Dof pressed");
    } else if (button == btnG2Sound) {
        println("There is btn G2 Sound pressed");
    } else if (button == btnG2Temp) {
        println("There is btn G2 Temp pressed");
    } else if (button == btnG2LED) {
        println("There is btn G2 LED pressed");
    } else if (button == btnG2Buzzer) {
        println("There is btn G2 Buzzer pressed");
    } else if (button == btnUpdate) {
        println("There is btn G2 Update pressed");
    }
}



 /**
 * @函数：void controlEvent(ControlEvent theEvent)
 */
void controlEvent(ControlEvent theEvent) {

  if (theEvent.isController()) {
    if (COM_List == theEvent.getController()) {
      println("Select port : " + int(theEvent.getController().getValue()));
      config_serial_port(int(theEvent.getController().getValue()));
    }
  }
}

 
 
 /**
 * @函数：void config_serial_port(int index)
 */
void config_serial_port(int index) {
  println("config serial port");
  // myPort = new Serial( this, Serial.list()[index], 115200);
  myPort = new Serial( this, Serial.list()[index], 115200);
  myPort.clear();

  
  thread("thread_Serial");
}

void thread_Serial() {
    while(true) {
        println("Thread Serial function");
        delay(1000);
    }
}


void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
    myPort.write(char(inByte));
    println("Recive the %c",char(inByte));
}

/* A custom Controller that implements a scrollable menuList. Here the controller 
 * uses a PGraphics element to render customizable list items. The menuList can be scrolled
 * using the scroll-wheel, touchpad, or mouse-drag. Items are triggered by a click. clicking 
 * the scrollbar to the right makes the list scroll to the item correspoinding to the 
 * click-location. 
 */ 
// class MenuList extends Controller<MenuList> {

  // float pos, npos;
  // int itemHeight = 100; // itemHeight
  // int scrollerLength = 40;
  // List< Map<String, Object>> items = new ArrayList< Map<String, Object>>();
  // PGraphics menu;
  // boolean updateMenu;

  // MenuList(ControlP5 c, String theName, int theWidth, int theHeight) {
    // super( c, theName, 0, 0, theWidth, theHeight );
    // c.register( this );
    // menu = createGraphics(getWidth(), getHeight() );

    // setView(new ControllerView<MenuList>() {

      // public void display(PGraphics pg, MenuList t ) {
        // if (updateMenu) {
          // updateMenu();
        // }
        // if (inside() ) {
          // menu.beginDraw();
          // int len = -(itemHeight * items.size()) + getWidth();
          // int ty = int(map(pos, len,0, getWidth() - scrollerLength - 2, 2 ) );
          // menu.fill(255 );
          // menu.rect(getHeight()-4, ty, 4, scrollerLength );
          // menu.endDraw();
        // }
        // pg.image(menu, 0, 0);
      // }
    // }
    // );
    // updateMenu();
  // }

  // /* only update the image buffer when necessary - to save some resources */
  // void updateMenu() {
    // int len = -(itemHeight * items.size()) + getWidth();
    // npos = constrain(len,npos,0);
    // pos += (npos - pos) * 0.1;
    // menu.beginDraw();
    // menu.noStroke();
    // menu.background(255, 64 );
    // menu.textFont(cp5.getFont().getFont());
    // menu.pushMatrix();
    // menu.translate( pos, 0 );
    // menu.pushMatrix();
    
    // int i0 = PApplet.max(int(map(-pos, 0, itemHeight * items.size(), 0, items.size())), 0);
    // int range = ceil((float(getWidth())/float(itemHeight))+1);
    // int i1 = PApplet.min(i0 + range , items.size());

    // //menu.translate(i0*itemHeight,0);
    // menu.translate(0, i0*itemHeight);
    
    // for (int i=i0;i<i1;i++) {
      // Map m = items.get(i);
      // menu.fill(255, 100);
      // menu.rect(0, 0, getWidth(), itemHeight-1 );
      // menu.fill(255);
      // menu.textFont(f1);
      // menu.text(m.get("headline").toString(), 10, 20 );
      // menu.textFont(f2);
      // menu.textLeading(12);
      // menu.text(m.get("subline").toString(), 10, 35 );
      // menu.text(m.get("copy").toString(), 10, 50, 120, 50 );
      // menu.image(((PImage)m.get("image")), 140, 10, 50, 50 );
      // menu.translate( 0, itemHeight );
    // }
    // menu.popMatrix();
    // menu.popMatrix();
    // menu.endDraw();
    // updateMenu = abs(npos-pos)>0.01 ? true:false;
  // }
  
  // /* when detecting a click, check if the click happend to the far right, if yes, scroll to that position, 
   // * otherwise do whatever this item of the list is supposed to do.
   // */
  // public void onClick() {
    // if (getPointer().x()>getWidth()-10) {
      // npos= -map(getPointer().x(), 0, getHeight(), 0, items.size()*itemHeight);
      // updateMenu = true;
    // } 
    // else {
      // int len = itemHeight * items.size();
      // int index = int( map( getPointer().x() - pos, 0, len, 0, items.size() ) ) ;
      // setValue(index);
    // }
  // }
  
  // public void onMove() {
  // }

  // public void onDrag() {
    // npos += getPointer().dx() * 2;
    // updateMenu = true;
  // } 

  // public void onScroll(int n) {
    // npos += ( n * 4 );
    // updateMenu = true;
  // }

  // void addItem(Map<String, Object> m) {
    // items.add(m);
    // updateMenu = true;
  // }
  
  // Map<String,Object> getItem(int theIndex) {
    // return items.get(theIndex);
  // }
// }
 
 
void customize(DropdownList ddl, ArrayList<String> list) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(255));
  ddl.setItemHeight(30);
  ddl.setBarHeight(25);
  for (int i=0;i<list.size();i++) {
    ddl.addItem(list.get(i), null);
  }
  ddl.setColorBackground(color(100));
  ddl.setColorActive(color(255, 128));
}



/*
This is used for scan serial ports
*/

void scan_serial_ports() {
  ArrayList<String> port_list = new ArrayList<String>();
  String[]  temp_list = {};

  temp_list = Serial.list();
  // need to have a test here
  if( 0 == temp_list.length ) {
    textSize(12);
    fill(230);
    text("No port found", 12, 440);
    return;
  }

  for (int i = 0; i < temp_list.length; i++) {
    if (temp_list[i].contains("/dev/cu") || temp_list[i].contains("COM")) {
      port_list.add(temp_list[i]);
    }
  }

  //printArray(port_list);
  COM_List = cp5.addDropdownList("SELECT PORT")
                .setPosition(1, 418)
                .setFont(createFont("arial black", 11))
                .setSize(100, 140)
                ;

  customize(COM_List, port_list);

}