{ pkgs }:

self: {
  WakaTime.vscode-wakatime = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "1.2.4";
      sha256 = "0qghn4kakv0jrjcl65p1v5r6j7608269zyhh75b15p12mdvi21vb";
    };
  };
  akamud.vscode-theme-onelight = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-theme-onelight";
      publisher = "akamud";
      version = "2.1.0";
      sha256 = "1dx08r35bxvmas1ai02v9r25hxadmvm1fh50grq2r4fzqxjgxkqn";
    };
  };
  bbenoist.Nix = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "Nix";
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    };
  };
  GitHub.vscode-pull-request-github = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-pull-request-github";
      publisher = "GitHub";
      version = "0.3.1";
      sha256 = "16d8lkq0jyv4n9cysrmzlfi32bdy96dx3qsq4w971yr3r9xhqhzx";
    };
  };
  ms-python.python = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "python";
      publisher = "ms-python";
      version = "2018.11.0";
      sha256 = "0z9ca14qzy6zw0cfir7hdnhin01c1wsr6lbb2xp6rpq06vh7nivl";
    };
  };
  ms-vscode.cpptools = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "cpptools";
      publisher = "ms-vscode";
      version = "0.20.1";
      sha256 = "1gmnkrn26n57vx2nm5hhalkkl2irak38m2lklgja0bi10jb6y08l";
    };
  };
  vscodevim.vim = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vim";
      publisher = "vscodevim";
      version = "0.16.14";
      sha256 = "0b8d3sj3754l3bwcb5cdn2z4z0nv6vj2vvaiyhrjhrc978zw7mby";
    };
  };
  Atishay-Jain.All-Autocomplete = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "All-Autocomplete";
      publisher = "Atishay-Jain";
      version = "0.0.18";
      sha256 = "03nsx8hvid1pqvya1xjfmz4p0yj243a8xx9l7yvjz9y72c75qlzc";
    };
  };
  eamodio.gitlens = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "gitlens";
      publisher = "eamodio";
      version = "9.1.0";
      sha256 = "0a6iqnqmig0s4d107vzwygybndd9hq99kk6mykc88c8qgwf0zdrr";
    };
  };
  robertohuertasm.vscode-icons = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-icons";
      publisher = "robertohuertasm";
      version = "7.28.0";
      sha256 = "13w5v47rka839zicsg48cybpyvvfzvsqc6kd1h25w84p5s8lgiir";
    };
  };
  redhat.java = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "java";
      publisher = "redhat";
      version = "0.35.0";
      sha256 = "1dszdzs52x8ihf7x64nv6xb74q6gq6pc10mxhrzdh4vhdrb1rspw";
    };
  };
  zhuangtongfa.Material-theme = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "Material-theme";
      publisher = "zhuangtongfa";
      version = "2.17.8";
      sha256 = "1clnvyd6cyc7a3d14d0r4ni39ddw91ikq5fwszwg823pkvhxrryg";
    };
  };
}