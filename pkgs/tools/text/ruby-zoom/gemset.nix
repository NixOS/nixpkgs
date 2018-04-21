{
  djinni = {
    dependencies = ["fagin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00zfgd7zx2p9xjc64xm4iwdxq2bb6n1z09nw815c2f4lvlaq269f";
      type = "gem";
    };
    version = "2.1.1";
  };
  fagin = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jryqrgb5jvz0m7p91c2bhn6gdwxn9jfdaq3cfkirc3y7yfzv131";
      type = "gem";
    };
    version = "1.0.0";
  };
  hilighter = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sy59nfcfk4p1fnrdkipi0mvsj9db17chrx7lb2jg3majbr1wz59";
      type = "gem";
    };
    version = "1.1.0";
  };
  json_config = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16q3q0j9s8w93lzxa7rrvh5wqk11np7s2nmgmdlrh8gl3w76xcz6";
      type = "gem";
    };
    version = "0.1.2";
  };
  ruby-zoom = {
    dependencies = ["djinni" "fagin" "hilighter" "json_config" "scoobydoo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0115kbz6l8srzizs77k9l0585lg93x90kg49jjpan7ssm786q05j";
      type = "gem";
    };
    version = "5.0.1";
  };
  scoobydoo = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w83zgip3qvh20pgqgcp9yp0k35ypn7ny0d61xcv1ik0r3ab8ga0";
      type = "gem";
    };
    version = "0.1.4";
  };
}