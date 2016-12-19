{
  "archive-tar-minitar" = {
    version = "0.5.2";
    source = {
      type = "gem";
      sha256 = "1j666713r3cc3wb0042x0wcmq2v11vwwy5pcaayy5f0lnd26iqig";
    };
  };
  "commander" = {
    version = "4.2.1";
    source = {
      type = "gem";
      sha256 = "1zwfhswnbhwv0zzj2b3s0qvpqijbbnmh7zvq6v0274rqbxyf1jwc";
    };
    dependencies = [
      "highline"
    ];
  };
  "highline" = {
    version = "1.6.21";
    source = {
      type = "gem";
      sha256 = "06bml1fjsnrhd956wqq5k3w8cyd09rv1vixdpa3zzkl6xs72jdn1";
    };
  };
  "httpclient" = {
    version = "2.6.0.1";
    source = {
      type = "gem";
      sha256 = "0haz4s9xnzr73mkfpgabspj43bhfm9znmpmgdk74n6gih1xlrx1l";
    };
  };
  "net-scp" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0b0jqrcsp4bbi4n4mzyf70cp2ysyp6x07j8k8cqgxnvb4i3a134j";
    };
    dependencies = [
      "net-ssh"
    ];
  };
  "net-ssh" = {
    version = "2.9.2";
    source = {
      type = "gem";
      sha256 = "1p0bj41zrmw5lhnxlm1pqb55zfz9y4p9fkrr9a79nrdmzrk1ph8r";
    };
  };
  "net-ssh-gateway" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1nqkj4wnj26r81rp3g4jqk7bkd2nqzjil3c9xqwchi0fsbwv2niy";
    };
    dependencies = [
      "net-ssh"
    ];
  };
  "net-ssh-multi" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "13kxz9b6kgr9mcds44zpavbndxyi6pvyzyda6bhk1kfmb5c10m71";
    };
    dependencies = [
      "net-ssh"
      "net-ssh-gateway"
    ];
  };
  "open4" = {
    version = "1.3.4";
    source = {
      type = "gem";
      sha256 = "1cgls3f9dlrpil846q0w7h66vsc33jqn84nql4gcqkk221rh7px1";
    };
  };
  "rhc" = {
    version = "1.36.4";
    source = {
      type = "gem";
      sha256 = "1dkg39x3y3sxq71md5c8akq4y7ynjwcdy8ysm6d1k9b2rj0s5wdb";
    };
    dependencies = [
      "archive-tar-minitar"
      "commander"
      "highline"
      "httpclient"
      "net-scp"
      "net-ssh"
      "net-ssh-multi"
      "open4"
    ];
  };
}