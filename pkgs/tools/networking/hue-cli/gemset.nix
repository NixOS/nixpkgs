{
  hue-cli = {
    dependencies = ["hue-lib" "json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10gjf59pamfy2m17fs271d9ffrg1194b1m6vxzn6p7smzry52h9z";
      type = "gem";
    };
    version = "0.1.4";
  };
  hue-lib = {
    dependencies = ["json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pyl8g8gisdhl79gbzvnddqrsbq0lmflzg7n6yi6xrp5b5290shz";
      type = "gem";
    };
    version = "0.7.4";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
}