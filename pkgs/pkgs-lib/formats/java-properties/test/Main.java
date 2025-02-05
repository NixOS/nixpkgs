import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import java.util.SortedSet;
import java.util.TreeSet;

class Main {
    public static void main (String args[]) {
        try {
            InputStream input = new FileInputStream(args[0]);
            Properties prop = new Properties();
            prop.load(input);
            SortedSet<String> keySet = new TreeSet(prop.keySet());
            for (String key : keySet) {
                System.out.println("KEY");
                System.out.println(key);
                System.out.println("VALUE");
                System.out.println(prop.get(key));
                System.out.println("");
            }
        } catch (Exception e) {
          e.printStackTrace();
          System.err.println(e.toString());
          System.exit(1);
        }
    }
}
