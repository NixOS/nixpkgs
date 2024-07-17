# Generated using:  ./generate-sdk-packages.sh developer-tools 11.3.1

{ applePackage' }:

{
  bootstrap_cmds =
    applePackage' "bootstrap_cmds" "116" "developer-tools-11.3.1"
      "06nw99ajkd264vdi6n2zv252ppxp3wx3120hqf3jqdh6c1wavy0b"
      { };
  developer_cmds =
    applePackage' "developer_cmds" "66" "developer-tools-11.3.1"
      "0f7vphpscjcypq49gjckbs20xhm7yjalr4nnbphqcqp8v1al56dc"
      { };
}
