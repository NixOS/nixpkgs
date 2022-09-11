{
  fusuma = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rq64grp98w7msjmj24hlxy1jqzqn96r81x4z09aq2v532cgqy4f";
      type = "gem";
    };
    version = "2.4.1";
  };
  fusuma-plugin-keypress = {
    dependencies = ["fusuma"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "150b9pjwyws8fscgpsrqvljs1q5hs7g0yxvj0z185f27m6vfc0vr";
      type = "gem";
    };
    version = "0.5.0";
  };
}
