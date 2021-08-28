{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, cerberus
, configparser
, deepdiff
, geoip2
, jinja2
, openpyxl
, tabulate
, yangson
, pytestCheckHook
, pyyaml
}:

let
  ttp_templates = callPackage ./templates.nix { };
in
buildPythonPackage rec {
  pname = "ttp";
  version = "0.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dmulyalin";
    repo = pname;
    rev = version;
    sha256 = "08pglwmnhdrsj9rgys1zclhq1h597izb0jq7waahpdabfg25v2sw";
  };

  propagatedBuildInputs = [
    # https://github.com/dmulyalin/ttp/blob/master/docs/source/Installation.rst#additional-dependencies
    cerberus
    configparser
    deepdiff
    geoip2
    jinja2
    # n2g unpackaged
    # netmiko unpackaged
    # nornir unpackaged
    openpyxl
    tabulate
    yangson
  ];

  pythonImportsCheck = [
    "ttp"
  ];

  checkInputs = [
    pytestCheckHook
    pyyaml
    ttp_templates
  ];

  disabledTestPaths = [
    # missing package n2g
    "test/pytest/test_N2G_formatter.py"
  ];

  disabledTests = [
    # data structure mismatches
    "test_yangson_validate"
    "test_yangson_validate_yang_lib_in_output_tag_data"
    "test_yangson_validate_multiple_inputs_mode_per_input_with_yang_lib_in_file"
    "test_yangson_validate_multiple_inputs_mode_per_template"
    "test_yangson_validate_multiple_inputs_mode_per_input_with_yang_lib_in_file_to_xml"
    "test_yangson_validate_multiple_inputs_mode_per_template_to_xml"
    "test_adding_data_from_files"
    "test_lookup_include_csv"
    "test_inputs_with_template_base_path"
    "test_group_inputs"
    "test_inputs_url_filters_extensions"
    # ValueError: dictionary update sequence element #0 has length 1; 2 is required
    "test_include_attribute_with_yaml_loader"
    # TypeError: string indices must be integers
    "test_lookup_include_yaml"
    # missing package n2g
    "test_n2g_formatter"
  ];

  pytestFlagsArray = [
    "test/pytest"
  ];

  meta = with lib; {
    description = "Template Text Parser";
    homepage = "https://github.com/dmulyalin/ttp";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
