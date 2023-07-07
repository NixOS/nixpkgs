{
  prometheus_exporter = {
    dependencies = ["webrick"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb4k6px8b36bvnw3d14j31s33ns60dcwxixbcgvhpzavd7fparb";
      type = "gem";
    };
    version = "2.0.6";
  };
  webrick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4cvgmxhfczxiq5fr534lmizkhigd15bsx5719r5ds7k7ivisc7";
      type = "gem";
    };
    version = "1.7.0";
  };
}
