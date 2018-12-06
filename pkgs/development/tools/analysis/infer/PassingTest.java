class PassingTest {
  String mayReturnNull(int i) {
    if (i > 0) {
      return "Hello, Infer!";
    }
    return null;
  }
  int mayCauseNPE() {
    String s = mayReturnNull(0);
    return s == null ? 0 : s.length();
  }
}
