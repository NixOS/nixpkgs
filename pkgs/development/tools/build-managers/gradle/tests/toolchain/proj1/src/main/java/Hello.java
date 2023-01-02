class Hello {
    public static void main(String[] args) {
        var version = Runtime.version().feature();
        System.out.println("JDK version: " + version);
        if (version != 11) {
            System.out.println("Wrong JDK version!");
            System.exit(1);
        }
    }
}
