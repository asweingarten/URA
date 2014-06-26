import java.net.InetAddress;
import java.net.UnknownHostException;

public class LimitedQueue<E> extends LinkedList<E> {

    private int limit;

    public LimitedQueue(int limit) {
        this.limit = limit;
    }

    @Override
    public boolean add(E o) {
        super.add(o);
        while (size() > limit) { super.remove(); }
        return true;
    }
}

String quote(String s)
{
  return "\"" + s + "\"";
}

void logError(String type, String msg)
{
  println("ERROR: " + msg);
  //if (logger != null)
    //logger.logEvent("error", type, "msg:" + quote(msg) );
}

String getMachineName()
{
  // get the machine name
  String hostname = "Unknown";
  try
  {
    InetAddress addr;
    addr = InetAddress.getLocalHost();
    hostname = addr.getHostName();
  }
  catch (UnknownHostException ex)
  {
    System.out.println("Hostname can not be resolved");
  }
  return hostname;
}


int textLines(String[] lines, int x, int y, int leading)
{
  for (int i=0; i< lines.length; i++)
  {
    text(lines[i], x, y);
    y = y + leading;
  }
  return y;
}


String[] lineBreak(float lineWidth, String line, PFont font, float fontSize)
{
  textFont(font, fontSize);
  ArrayList<String> lines = new ArrayList<String>();
  String[] words = split(line, ' ');
  float lineSpace = 0;
  int l = -1;
  if (words.length == 0)
    lines.add(line);
  else
  {
    for (int i=0; i < words.length; i++)
    {

      float w = textWidth(words[i] + " ");
      if (lineSpace - w > 0)
      {

        lines.set(l, lines.get(l) + " " + words[i]);
        lineSpace = lineSpace - w;
        //println(lines.get(l) + " " + lineSpace);
      }
      else
      {
        //println("new line");
        lineSpace = lineWidth - w;
        lines.add(words[i]);
        l++;
      }
    }
  }

  return lines.toArray(new String[lines.size()]);
}

String myJoin(String[] list, String separator)
{
  return join(list, separator);
}

