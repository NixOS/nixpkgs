{
  djinni = {
    dependencies = [ "fagin" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18zk80jk70xq1bnsvzcgxb13x9fqdb5g4m02b2f6mvqm4cyw26pl";
      type = "gem";
    };
    version = "2.2.4";
  };
  fagin = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0psyydh4hf2s1kz0r50aiyjf5v2pqhkbmy0gicxzaj5n17q2ga24";
      type = "gem";
    };
    version = "1.2.1";
  };
  hilighter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03zm49g96dfpan5fhblcjxrzv7ldwan57sn0jcllkcmrqfd0zlyz";
      type = "gem";
    };
    version = "1.2.3";
  };
  json_config = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0slb618n1ipn47j6dsxbfv2j9pl06dxn2i651llix09d529m7zwa";
      type = "gem";
    };
    version = "1.1.0";
  };
  ruby-zoom = {
    dependencies = [
      "djinni"
      "fagin"
      "hilighter"
      "json_config"
      "scoobydoo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iqxc0rzypsxy4wbxnvgvk98dbcsrcczq3xi9xd4wz4ggwq564l3";
      type = "gem";
    };
    version = "5.3.0";
  };
  scoobydoo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "162p75nc9x078kqcpdsrsd7kngs6jc5n4injz3kzpwf0jgbbm8n7";
      type = "gem";
    };
    version = "1.0.0";
  };
}
