{
  forwardable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b5g1i3xdvmxxpq4qp0z4v78ivqnazz26w110fh4cvzsdayz8zgi";
      type = "gem";
    };
    version = "1.3.3";
  };
  iostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z3vnb8mhzns3ybf78vlj5cy6lq4pyfm8n40kqba2s33xccs3kl0";
      type = "gem";
    };
    version = "0.0.5";
  };
  prime = {
    dependencies = [
      "forwardable"
      "singleton"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1973kz8lbck6ga5v42f55jk8b8pnbgwp9p67dl1xw15gvz55dsfl";
      type = "gem";
    };
    version = "0.1.2";
  };
  rainbow = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  singleton = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qq54imvbksnckzf9hrq9bjzcdb0n8wfv6l5jc0di10n88277jx6";
      type = "gem";
    };
    version = "0.2.0";
  };
  zpng = {
    dependencies = [ "rainbow" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xyr7ipgls7wci1gnsz340idm69jls0gind0q4f63ccjwgzsfkqw";
      type = "gem";
    };
    version = "0.4.5";
  };
  zsteg = {
    dependencies = [
      "iostruct"
      "prime"
      "zpng"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "128kbv9vsi288mj17zwvc45ijpzf3p116vk9kcvkz978hz0n6spm";
      type = "gem";
    };
    version = "0.2.13";
  };
}
