{
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ak5yqqhr04b4x0axzvpw1xzwmxmfcw0gf4r1ijixv15kidhsj3z";
      type = "gem";
    };
    version = "3.15.6";
  };
  pg_query = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01a8asbgkr7f1gp50ikzr1zzmvwv50da389943hrrqzxwd202268";
      type = "gem";
    };
    version = "2.0.1";
  };
  sqlint = {
    dependencies = ["pg_query"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ylicsc9x4vpj6ff3hmrm6iz1xswrwwgn1m7ri8nx86ij30w9hkk";
      type = "gem";
    };
    version = "0.2.0";
  };
}
