{
  pkgs,
  lib,
}:
{
  format =
    {
      format ? "badgerfish",
      withHeader ? true,
    }:
    if format == "badgerfish" then
      {
        type =
          lib.types.attrsOf (
            lib.types.serializableValueWith {
              typeName = "XML";
            }
          )
          // {
            description = "XML value";
          };

        generate =
          name: value:
          pkgs.callPackage (
            {
              runCommand,
              libxml2Python,
              python3Packages,
            }:
            runCommand name
              {
                nativeBuildInputs = [
                  python3Packages.xmltodict
                  libxml2Python
                ];
                inherit value;
                pythonGen = pkgs.writeText "pythonGen" ''
                  import json
                  import os
                  import xmltodict

                  with open(os.environ["NIX_ATTRS_JSON_FILE"], "r") as f:
                      value = json.load(f).get("value")
                      assert type(value) is dict, "value must be an attrset"
                      print(xmltodict.unparse(value, full_document=${
                        if withHeader then "True" else "False"
                      }, pretty=True, indent=" " * 2))
                '';
                preferLocalBuild = true;
                __structuredAttrs = true;
              }
              ''
                python3 "$pythonGen" > $out
                xmllint $out > /dev/null
              ''
          ) { };
      }
    else
      throw "pkgs.formats.xml: Unknown format: ${format}";
}
