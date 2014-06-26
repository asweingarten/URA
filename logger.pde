import java.util.*;
import java.text.*;
import java.util.concurrent.*;


// writes a custom log file format 

// 

// # all lines begin with timestamp
// yyyyMMdd,HHmmss.S (e.g. 20130116,130011.438)

// CSV continuous data:
// special line to define the CSV column names
// A,colname,colname,colname,colname,...
// timestamp,A,val,val,val,val,...

// event data
// timestamp,[event,subevent,{param:val,param:val}]
// use brackets for CSV val data



// simple logging class
class Logger extends Thread
{

  boolean isRunning = false;
  
  long lastLogTime = 0;
  long newDayThresh = 1000 * 60 * 60; // one hour ... 
  
  long wait = 50;
  long maxFileSize = int(5 * 1e6); // Mb
  
  String path_;
  String name_;
  PrintWriter logfile = null;
  
  String header = "";

  // format for dates in log file
  SimpleDateFormat logDateFormater = new SimpleDateFormat("yyyyMMdd,HHmmss.S");

  SimpleDateFormat filenameDateFormater = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss");

  // buffer
  AbstractQueue<String> buffer = new ConcurrentLinkedQueue<String>();
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public Logger(String path, String name)
  {
    path_ = path;
    name_ = name;
    start();

  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  // Overriding "start()"
  void start () 
  {
    setPriority( MIN_PRIORITY);
    isRunning = true;
    println("Start logging thread"); 
    super.start();
  }

  // main thread loop
  void run() 
  {
    System.out.println("Logging thread starting");
    newfile();    
    long fileSize = 0;
    while (isRunning) 
    {
      if (logfile == null) newfile();

      while (buffer.peek () != null) 
      {
        String l = buffer.poll();
        fileSize += l.length();
        logfile.println(l);
      }
      
      logfile.flush();

      // create a new file if necessary
      if (fileSize > maxFileSize)
      {
        println("logged " + fileSize/1e6 + "Mb");
        close();
        newfile();
        fileSize = 0;
      }
      try 
      {
        sleep((long)(wait));
      } 
      catch (Exception e) 
      {
        //e.printStackTrace();
      }
    }
    close();
    System.out.println("Logging thread exiting");  
  }

  // Our method that quits the thread
  void quit() 
  {
    System.out.println("Quit logging thread"); 
    isRunning = false; 
    // In case the thread is waiting. . .
    interrupt();
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public void logContinuous(String type, Object ... values)
  {
    String[] list = new String[values.length];
    for (int i=0; i < values.length; i++)
      list[i] = values[i].toString();
    log("[" + type + "," + myJoin(list, ",") + "]");
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public void logEvent(String type, String subType, String params)
  {
    log("[" + type + "," + subType + ",{" + params + "}]");
  }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public void log(String s)
  {
    long t = System.currentTimeMillis();
    
    // new file if sleeping for some time
    if (t - lastLogTime > newDayThresh)
    {
      newfile();
      comment("# New Day Detected");
    }
        
    buffer.offer(logDateFormater.format(t) + "," + s);
    lastLogTime = t;
  }
  
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public void comment(String s)
  {
    buffer.offer(s);
  }
  
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public void setHeader(String s)
  {
    header = s; 
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  private void close()
  {
    if (logfile != null)
    {
      comment("#EOF");
      while (buffer.peek () != null) 
        logfile.println(buffer.poll());
      logfile.flush();
      logfile.close(); 
      println("closed log");
      logfile = null;
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  private boolean newfile()
  {
    close();
    long t = System.currentTimeMillis();
    String fn = name_ + " " + filenameDateFormater.format(t) + ".txt";
    try
    {
      logfile = createWriter(path_ + fn);
      println("opened log: '" + path_ + fn + "' max size is :" + maxFileSize/1e6 + "Mb");
      lastLogTime = t;
    }
    catch (Exception e)
    {
      return false;
    }
    return true;
    //comment(header);
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

