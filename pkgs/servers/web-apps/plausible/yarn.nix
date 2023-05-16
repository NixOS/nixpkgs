{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
<<<<<<< HEAD
      name = "_ampproject_remapping___remapping_2.2.1.tgz";
      path = fetchurl {
        name = "_ampproject_remapping___remapping_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/@ampproject/remapping/-/remapping-2.2.1.tgz";
        sha512 = "lFMjJTrFL3j7L9yBxwYfCq2k6qqwHyzuUl/XBnif78PWTJYyL/dfowQHWE3sp6U6ZzqWiiIZnpTMO96zhkjwtg==";
      };
    }
    {
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      name = "_babel_code_frame___code_frame_7.12.11.tgz";
      path = fetchurl {
        name = "_babel_code_frame___code_frame_7.12.11.tgz";
        url  = "https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.12.11.tgz";
<<<<<<< HEAD
        sha512 = "Zt1yodBx1UcyiePMSkWnU4hPqhwq7hGi2nFL1LeA3EUl+q2LQx16MISgJ0+z7dnmgvP9QtIleuETGOiOH1RcIw==";
      };
    }
    {
      name = "_babel_code_frame___code_frame_7.21.4.tgz";
      path = fetchurl {
        name = "_babel_code_frame___code_frame_7.21.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.21.4.tgz";
        sha512 = "LYvhNKfwWSPpocw8GI7gpK2nq3HSDuEPC/uSYaALSJu9xjsalaaYFOq0Pwt5KmVqwEbZlDu81aLXwBOmD/Fv9g==";
      };
    }
    {
      name = "_babel_compat_data___compat_data_7.21.7.tgz";
      path = fetchurl {
        name = "_babel_compat_data___compat_data_7.21.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/compat-data/-/compat-data-7.21.7.tgz";
        sha512 = "KYMqFYTaenzMK4yUtf4EW9wc4N9ef80FsbMtkwool5zpwl4YrT1SdWYSTRcT94KO4hannogdS+LxY7L+arP3gA==";
      };
    }
    {
      name = "_babel_core___core_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_core___core_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/core/-/core-7.21.5.tgz";
        sha512 = "9M398B/QH5DlfCOTKDZT1ozXr0x8uBEeFd+dJraGUZGiaNpGCDVGCc14hZexsMblw3XxltJ+6kSvogp9J+5a9g==";
      };
    }
    {
      name = "_babel_generator___generator_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_generator___generator_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/generator/-/generator-7.21.5.tgz";
        sha512 = "SrKK/sRv8GesIW1bDagf9cCG38IOMYZusoe1dfg0D8aiUe3Amvoj1QtjTPAWcfrZFvIwlleLb0gxzQidL9w14w==";
      };
    }
    {
      name = "_babel_helper_annotate_as_pure___helper_annotate_as_pure_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_helper_annotate_as_pure___helper_annotate_as_pure_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.18.6.tgz";
        sha512 = "duORpUiYrEpzKIop6iNbjnwKLAKnJ47csTyRACyEmWj0QdUrm5aqNJGHSSEQSUAvNW0ojX0dOmK9dZduvkfeXA==";
      };
    }
    {
      name = "_babel_helper_builder_binary_assignment_operator_visitor___helper_builder_binary_assignment_operator_visitor_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_builder_binary_assignment_operator_visitor___helper_builder_binary_assignment_operator_visitor_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.21.5.tgz";
        sha512 = "uNrjKztPLkUk7bpCNC0jEKDJzzkvel/W+HguzbN8krA+LPfC1CEobJEvAvGka2A/M+ViOqXdcRL0GqPUJSjx9g==";
      };
    }
    {
      name = "_babel_helper_compilation_targets___helper_compilation_targets_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_compilation_targets___helper_compilation_targets_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-compilation-targets/-/helper-compilation-targets-7.21.5.tgz";
        sha512 = "1RkbFGUKex4lvsB9yhIfWltJM5cZKUftB2eNajaDv3dCMEp49iBG0K14uH8NnX9IPux2+mK7JGEOB0jn48/J6w==";
      };
    }
    {
      name = "_babel_helper_create_class_features_plugin___helper_create_class_features_plugin_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_create_class_features_plugin___helper_create_class_features_plugin_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.21.5.tgz";
        sha512 = "yNSEck9SuDvPTEUYm4BSXl6ZVC7yO5ZLEMAhG3v3zi7RDxyL/nQDemWWZmw4L0stPWwhpnznRRyJHPRcbXR2jw==";
      };
    }
    {
      name = "_babel_helper_create_regexp_features_plugin___helper_create_regexp_features_plugin_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_create_regexp_features_plugin___helper_create_regexp_features_plugin_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.21.5.tgz";
        sha512 = "1+DPMcln46eNAta/rPIqQYXYRGvQ/LRy6bRKnSt9Dzt/yLjNUbbsh+6yzD6fUHmtzc9kWvVnAhtcMSMyziHmUA==";
      };
    }
    {
      name = "_babel_helper_define_polyfill_provider___helper_define_polyfill_provider_0.3.3.tgz";
      path = fetchurl {
        name = "_babel_helper_define_polyfill_provider___helper_define_polyfill_provider_0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.3.3.tgz";
        sha512 = "z5aQKU4IzbqCC1XH0nAqfsFLMVSo22SBKUc0BxGrLkolTdPTructy0ToNnlO2zA4j9Q/7pjMZf0DSY+DSTYzww==";
      };
    }
    {
      name = "_babel_helper_environment_visitor___helper_environment_visitor_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_environment_visitor___helper_environment_visitor_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-environment-visitor/-/helper-environment-visitor-7.21.5.tgz";
        sha512 = "IYl4gZ3ETsWocUWgsFZLM5i1BYx9SoemminVEXadgLBa9TdeorzgLKm8wWLA6J1N/kT3Kch8XIk1laNzYoHKvQ==";
      };
    }
    {
      name = "_babel_helper_function_name___helper_function_name_7.21.0.tgz";
      path = fetchurl {
        name = "_babel_helper_function_name___helper_function_name_7.21.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.21.0.tgz";
        sha512 = "HfK1aMRanKHpxemaY2gqBmL04iAPOPRj7DxtNbiDOrJK+gdwkiNRVpCpUJYbUT+aZyemKN8brqTOxzCaG6ExRg==";
      };
    }
    {
      name = "_babel_helper_hoist_variables___helper_hoist_variables_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_helper_hoist_variables___helper_hoist_variables_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-hoist-variables/-/helper-hoist-variables-7.18.6.tgz";
        sha512 = "UlJQPkFqFULIcyW5sbzgbkxn2FKRgwWiRexcuaR8RNJRy8+LLveqPjwZV/bwrLZCN0eUHD/x8D0heK1ozuoo6Q==";
      };
    }
    {
      name = "_babel_helper_member_expression_to_functions___helper_member_expression_to_functions_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_member_expression_to_functions___helper_member_expression_to_functions_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.21.5.tgz";
        sha512 = "nIcGfgwpH2u4n9GG1HpStW5Ogx7x7ekiFHbjjFRKXbn5zUvqO9ZgotCO4x1aNbKn/x/xOUaXEhyNHCwtFCpxWg==";
      };
    }
    {
      name = "_babel_helper_module_imports___helper_module_imports_7.21.4.tgz";
      path = fetchurl {
        name = "_babel_helper_module_imports___helper_module_imports_7.21.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.21.4.tgz";
        sha512 = "orajc5T2PsRYUN3ZryCEFeMDYwyw09c/pZeaQEZPH0MpKzSvn3e0uXsDBu3k03VI+9DBiRo+l22BfKTpKwa/Wg==";
      };
    }
    {
      name = "_babel_helper_module_transforms___helper_module_transforms_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_module_transforms___helper_module_transforms_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-module-transforms/-/helper-module-transforms-7.21.5.tgz";
        sha512 = "bI2Z9zBGY2q5yMHoBvJ2a9iX3ZOAzJPm7Q8Yz6YeoUjU/Cvhmi2G4QyTNyPBqqXSgTjUxRg3L0xV45HvkNWWBw==";
      };
    }
    {
      name = "_babel_helper_optimise_call_expression___helper_optimise_call_expression_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_helper_optimise_call_expression___helper_optimise_call_expression_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.18.6.tgz";
        sha512 = "HP59oD9/fEHQkdcbgFCnbmgH5vIQTJbxh2yf+CdM89/glUNnuzr87Q8GIjGEnOktTROemO0Pe0iPAYbqZuOUiA==";
      };
    }
    {
      name = "_babel_helper_plugin_utils___helper_plugin_utils_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_plugin_utils___helper_plugin_utils_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-plugin-utils/-/helper-plugin-utils-7.21.5.tgz";
        sha512 = "0WDaIlXKOX/3KfBK/dwP1oQGiPh6rjMkT7HIRv7i5RR2VUMwrx5ZL0dwBkKx7+SW1zwNdgjHd34IMk5ZjTeHVg==";
      };
    }
    {
      name = "_babel_helper_remap_async_to_generator___helper_remap_async_to_generator_7.18.9.tgz";
      path = fetchurl {
        name = "_babel_helper_remap_async_to_generator___helper_remap_async_to_generator_7.18.9.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.18.9.tgz";
        sha512 = "dI7q50YKd8BAv3VEfgg7PS7yD3Rtbi2J1XMXaalXO0W0164hYLnh8zpjRS0mte9MfVp/tltvr/cfdXPvJr1opA==";
      };
    }
    {
      name = "_babel_helper_replace_supers___helper_replace_supers_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_replace_supers___helper_replace_supers_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-replace-supers/-/helper-replace-supers-7.21.5.tgz";
        sha512 = "/y7vBgsr9Idu4M6MprbOVUfH3vs7tsIfnVWv/Ml2xgwvyH6LTngdfbf5AdsKwkJy4zgy1X/kuNrEKvhhK28Yrg==";
      };
    }
    {
      name = "_babel_helper_simple_access___helper_simple_access_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_simple_access___helper_simple_access_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-simple-access/-/helper-simple-access-7.21.5.tgz";
        sha512 = "ENPDAMC1wAjR0uaCUwliBdiSl1KBJAVnMTzXqi64c2MG8MPR6ii4qf7bSXDqSFbr4W6W028/rf5ivoHop5/mkg==";
      };
    }
    {
      name = "_babel_helper_skip_transparent_expression_wrappers___helper_skip_transparent_expression_wrappers_7.20.0.tgz";
      path = fetchurl {
        name = "_babel_helper_skip_transparent_expression_wrappers___helper_skip_transparent_expression_wrappers_7.20.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.20.0.tgz";
        sha512 = "5y1JYeNKfvnT8sZcK9DVRtpTbGiomYIHviSP3OQWmDPU3DeH4a1ZlT/N2lyQ5P8egjcRaT/Y9aNqUxK0WsnIIg==";
      };
    }
    {
      name = "_babel_helper_split_export_declaration___helper_split_export_declaration_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_helper_split_export_declaration___helper_split_export_declaration_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.18.6.tgz";
        sha512 = "bde1etTx6ZyTmobl9LLMMQsaizFVZrquTEHOqKeQESMKo4PlObf+8+JA25ZsIpZhT/WEd39+vOdLXAFG/nELpA==";
      };
    }
    {
      name = "_babel_helper_string_parser___helper_string_parser_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helper_string_parser___helper_string_parser_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-string-parser/-/helper-string-parser-7.21.5.tgz";
        sha512 = "5pTUx3hAJaZIdW99sJ6ZUUgWq/Y+Hja7TowEnLNMm1VivRgZQL3vpBY3qUACVsvw+yQU6+YgfBVmcbLaZtrA1w==";
      };
    }
    {
      name = "_babel_helper_validator_identifier___helper_validator_identifier_7.19.1.tgz";
      path = fetchurl {
        name = "_babel_helper_validator_identifier___helper_validator_identifier_7.19.1.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.19.1.tgz";
        sha512 = "awrNfaMtnHUr653GgGEs++LlAvW6w+DcPrOliSMXWCKo597CwL5Acf/wWdNkf/tfEQE3mjkeD1YOVZOUV/od1w==";
      };
    }
    {
      name = "_babel_helper_validator_option___helper_validator_option_7.21.0.tgz";
      path = fetchurl {
        name = "_babel_helper_validator_option___helper_validator_option_7.21.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-validator-option/-/helper-validator-option-7.21.0.tgz";
        sha512 = "rmL/B8/f0mKS2baE9ZpyTcTavvEuWhTTW8amjzXNvYG4AwBsqTLikfXsEofsJEfKHf+HQVQbFOHy6o+4cnC/fQ==";
      };
    }
    {
      name = "_babel_helper_wrap_function___helper_wrap_function_7.20.5.tgz";
      path = fetchurl {
        name = "_babel_helper_wrap_function___helper_wrap_function_7.20.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-wrap-function/-/helper-wrap-function-7.20.5.tgz";
        sha512 = "bYMxIWK5mh+TgXGVqAtnu5Yn1un+v8DDZtqyzKRLUzrh70Eal2O3aZ7aPYiMADO4uKlkzOiRiZ6GX5q3qxvW9Q==";
      };
    }
    {
      name = "_babel_helpers___helpers_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_helpers___helpers_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helpers/-/helpers-7.21.5.tgz";
        sha512 = "BSY+JSlHxOmGsPTydUkPf1MdMQ3M81x5xGCOVgWM3G8XH77sJ292Y2oqcp0CbbgxhqBuI46iUz1tT7hqP7EfgA==";
      };
    }
    {
      name = "_babel_highlight___highlight_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_highlight___highlight_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.18.6.tgz";
        sha512 = "u7stbOuYjaPezCuLj29hNW1v64M2Md2qupEKP1fHc7WdOA3DgLh37suiSrZYY7haUB7iBeQZ9P1uiRF359do3g==";
      };
    }
    {
      name = "_babel_parser___parser_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_parser___parser_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/parser/-/parser-7.21.5.tgz";
        sha512 = "J+IxH2IsxV4HbnTrSWgMAQj0UEo61hDA4Ny8h8PCX0MLXiibqHbqIOVneqdocemSBc22VpBKxt4J6FQzy9HarQ==";
      };
    }
    {
      name = "_babel_plugin_bugfix_safari_id_destructuring_collision_in_function_expression___plugin_bugfix_safari_id_destructuring_collision_in_function_expression_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_bugfix_safari_id_destructuring_collision_in_function_expression___plugin_bugfix_safari_id_destructuring_collision_in_function_expression_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.18.6.tgz";
        sha512 = "Dgxsyg54Fx1d4Nge8UnvTrED63vrwOdPmyvPzlNN/boaliRP54pm3pGzZD1SJUwrBA+Cs/xdG8kXX6Mn/RfISQ==";
      };
    }
    {
      name = "_babel_plugin_bugfix_v8_spread_parameters_in_optional_chaining___plugin_bugfix_v8_spread_parameters_in_optional_chaining_7.20.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_bugfix_v8_spread_parameters_in_optional_chaining___plugin_bugfix_v8_spread_parameters_in_optional_chaining_7.20.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.20.7.tgz";
        sha512 = "sbr9+wNE5aXMBBFBICk01tt7sBf2Oc9ikRFEcem/ZORup9IMUdNhW7/wVLEbbtlWOsEubJet46mHAL2C8+2jKQ==";
      };
    }
    {
      name = "_babel_plugin_proposal_async_generator_functions___plugin_proposal_async_generator_functions_7.20.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_async_generator_functions___plugin_proposal_async_generator_functions_7.20.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-async-generator-functions/-/plugin-proposal-async-generator-functions-7.20.7.tgz";
        sha512 = "xMbiLsn/8RK7Wq7VeVytytS2L6qE69bXPB10YCmMdDZbKF4okCqY74pI/jJQ/8U0b/F6NrT2+14b8/P9/3AMGA==";
      };
    }
    {
      name = "_babel_plugin_proposal_class_properties___plugin_proposal_class_properties_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_class_properties___plugin_proposal_class_properties_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-class-properties/-/plugin-proposal-class-properties-7.18.6.tgz";
        sha512 = "cumfXOF0+nzZrrN8Rf0t7M+tF6sZc7vhQwYQck9q1/5w2OExlD+b4v4RpMJFaV1Z7WcDRgO6FqvxqxGlwo+RHQ==";
      };
    }
    {
      name = "_babel_plugin_proposal_class_static_block___plugin_proposal_class_static_block_7.21.0.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_class_static_block___plugin_proposal_class_static_block_7.21.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-class-static-block/-/plugin-proposal-class-static-block-7.21.0.tgz";
        sha512 = "XP5G9MWNUskFuP30IfFSEFB0Z6HzLIUcjYM4bYOPHXl7eiJ9HFv8tWj6TXTN5QODiEhDZAeI4hLok2iHFFV4hw==";
      };
    }
    {
      name = "_babel_plugin_proposal_dynamic_import___plugin_proposal_dynamic_import_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_dynamic_import___plugin_proposal_dynamic_import_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-dynamic-import/-/plugin-proposal-dynamic-import-7.18.6.tgz";
        sha512 = "1auuwmK+Rz13SJj36R+jqFPMJWyKEDd7lLSdOj4oJK0UTgGueSAtkrCvz9ewmgyU/P941Rv2fQwZJN8s6QruXw==";
      };
    }
    {
      name = "_babel_plugin_proposal_export_namespace_from___plugin_proposal_export_namespace_from_7.18.9.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_export_namespace_from___plugin_proposal_export_namespace_from_7.18.9.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-export-namespace-from/-/plugin-proposal-export-namespace-from-7.18.9.tgz";
        sha512 = "k1NtHyOMvlDDFeb9G5PhUXuGj8m/wiwojgQVEhJ/fsVsMCpLyOP4h0uGEjYJKrRI+EVPlb5Jk+Gt9P97lOGwtA==";
      };
    }
    {
      name = "_babel_plugin_proposal_json_strings___plugin_proposal_json_strings_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_json_strings___plugin_proposal_json_strings_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-json-strings/-/plugin-proposal-json-strings-7.18.6.tgz";
        sha512 = "lr1peyn9kOdbYc0xr0OdHTZ5FMqS6Di+H0Fz2I/JwMzGmzJETNeOFq2pBySw6X/KFL5EWDjlJuMsUGRFb8fQgQ==";
      };
    }
    {
      name = "_babel_plugin_proposal_logical_assignment_operators___plugin_proposal_logical_assignment_operators_7.20.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_logical_assignment_operators___plugin_proposal_logical_assignment_operators_7.20.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-logical-assignment-operators/-/plugin-proposal-logical-assignment-operators-7.20.7.tgz";
        sha512 = "y7C7cZgpMIjWlKE5T7eJwp+tnRYM89HmRvWM5EQuB5BoHEONjmQ8lSNmBUwOyy/GFRsohJED51YBF79hE1djug==";
      };
    }
    {
      name = "_babel_plugin_proposal_nullish_coalescing_operator___plugin_proposal_nullish_coalescing_operator_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_nullish_coalescing_operator___plugin_proposal_nullish_coalescing_operator_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-nullish-coalescing-operator/-/plugin-proposal-nullish-coalescing-operator-7.18.6.tgz";
        sha512 = "wQxQzxYeJqHcfppzBDnm1yAY0jSRkUXR2z8RePZYrKwMKgMlE8+Z6LUno+bd6LvbGh8Gltvy74+9pIYkr+XkKA==";
      };
    }
    {
      name = "_babel_plugin_proposal_numeric_separator___plugin_proposal_numeric_separator_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_numeric_separator___plugin_proposal_numeric_separator_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-numeric-separator/-/plugin-proposal-numeric-separator-7.18.6.tgz";
        sha512 = "ozlZFogPqoLm8WBr5Z8UckIoE4YQ5KESVcNudyXOR8uqIkliTEgJ3RoketfG6pmzLdeZF0H/wjE9/cCEitBl7Q==";
      };
    }
    {
      name = "_babel_plugin_proposal_object_rest_spread___plugin_proposal_object_rest_spread_7.20.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_object_rest_spread___plugin_proposal_object_rest_spread_7.20.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-object-rest-spread/-/plugin-proposal-object-rest-spread-7.20.7.tgz";
        sha512 = "d2S98yCiLxDVmBmE8UjGcfPvNEUbA1U5q5WxaWFUGRzJSVAZqm5W6MbPct0jxnegUZ0niLeNX+IOzEs7wYg9Dg==";
      };
    }
    {
      name = "_babel_plugin_proposal_optional_catch_binding___plugin_proposal_optional_catch_binding_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_optional_catch_binding___plugin_proposal_optional_catch_binding_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-optional-catch-binding/-/plugin-proposal-optional-catch-binding-7.18.6.tgz";
        sha512 = "Q40HEhs9DJQyaZfUjjn6vE8Cv4GmMHCYuMGIWUnlxH6400VGxOuwWsPt4FxXxJkC/5eOzgn0z21M9gMT4MOhbw==";
      };
    }
    {
      name = "_babel_plugin_proposal_optional_chaining___plugin_proposal_optional_chaining_7.21.0.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_optional_chaining___plugin_proposal_optional_chaining_7.21.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-optional-chaining/-/plugin-proposal-optional-chaining-7.21.0.tgz";
        sha512 = "p4zeefM72gpmEe2fkUr/OnOXpWEf8nAgk7ZYVqqfFiyIG7oFfVZcCrU64hWn5xp4tQ9LkV4bTIa5rD0KANpKNA==";
      };
    }
    {
      name = "_babel_plugin_proposal_private_methods___plugin_proposal_private_methods_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_private_methods___plugin_proposal_private_methods_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-private-methods/-/plugin-proposal-private-methods-7.18.6.tgz";
        sha512 = "nutsvktDItsNn4rpGItSNV2sz1XwS+nfU0Rg8aCx3W3NOKVzdMjJRu0O5OkgDp3ZGICSTbgRpxZoWsxoKRvbeA==";
      };
    }
    {
      name = "_babel_plugin_proposal_private_property_in_object___plugin_proposal_private_property_in_object_7.21.0.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_private_property_in_object___plugin_proposal_private_property_in_object_7.21.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0.tgz";
        sha512 = "ha4zfehbJjc5MmXBlHec1igel5TJXXLDDRbuJ4+XT2TJcyD9/V1919BA8gMvsdHcNMBy4WBUBiRb3nw/EQUtBw==";
      };
    }
    {
      name = "_babel_plugin_proposal_unicode_property_regex___plugin_proposal_unicode_property_regex_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_unicode_property_regex___plugin_proposal_unicode_property_regex_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-unicode-property-regex/-/plugin-proposal-unicode-property-regex-7.18.6.tgz";
        sha512 = "2BShG/d5yoZyXZfVePH91urL5wTG6ASZU9M4o03lKK8u8UW1y08OMttBSOADTcJrnPMpvDXRG3G8fyLh4ovs8w==";
=======
        sha1 = "f4ad435aa263db935b8f10f2c552d23fb716a63f";
      };
    }
    {
      name = "_babel_code_frame___code_frame_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_code_frame___code_frame_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.16.7.tgz";
        sha1 = "44416b6bd7624b998f5b1af5d470856c40138789";
      };
    }
    {
      name = "_babel_compat_data___compat_data_7.16.8.tgz";
      path = fetchurl {
        name = "_babel_compat_data___compat_data_7.16.8.tgz";
        url  = "https://registry.yarnpkg.com/@babel/compat-data/-/compat-data-7.16.8.tgz";
        sha1 = "31560f9f29fdf1868de8cb55049538a1b9732a60";
      };
    }
    {
      name = "_babel_core___core_7.16.12.tgz";
      path = fetchurl {
        name = "_babel_core___core_7.16.12.tgz";
        url  = "https://registry.yarnpkg.com/@babel/core/-/core-7.16.12.tgz";
        sha1 = "5edc53c1b71e54881315923ae2aedea2522bb784";
      };
    }
    {
      name = "_babel_generator___generator_7.16.8.tgz";
      path = fetchurl {
        name = "_babel_generator___generator_7.16.8.tgz";
        url  = "https://registry.yarnpkg.com/@babel/generator/-/generator-7.16.8.tgz";
        sha1 = "359d44d966b8cd059d543250ce79596f792f2ebe";
      };
    }
    {
      name = "_babel_helper_annotate_as_pure___helper_annotate_as_pure_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_annotate_as_pure___helper_annotate_as_pure_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.16.7.tgz";
        sha1 = "bb2339a7534a9c128e3102024c60760a3a7f3862";
      };
    }
    {
      name = "_babel_helper_builder_binary_assignment_operator_visitor___helper_builder_binary_assignment_operator_visitor_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_builder_binary_assignment_operator_visitor___helper_builder_binary_assignment_operator_visitor_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.16.7.tgz";
        sha1 = "38d138561ea207f0f69eb1626a418e4f7e6a580b";
      };
    }
    {
      name = "_babel_helper_compilation_targets___helper_compilation_targets_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_compilation_targets___helper_compilation_targets_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-compilation-targets/-/helper-compilation-targets-7.16.7.tgz";
        sha1 = "06e66c5f299601e6c7da350049315e83209d551b";
      };
    }
    {
      name = "_babel_helper_create_class_features_plugin___helper_create_class_features_plugin_7.16.10.tgz";
      path = fetchurl {
        name = "_babel_helper_create_class_features_plugin___helper_create_class_features_plugin_7.16.10.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.16.10.tgz";
        sha1 = "8a6959b9cc818a88815ba3c5474619e9c0f2c21c";
      };
    }
    {
      name = "_babel_helper_create_regexp_features_plugin___helper_create_regexp_features_plugin_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_create_regexp_features_plugin___helper_create_regexp_features_plugin_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.16.7.tgz";
        sha1 = "0cb82b9bac358eb73bfbd73985a776bfa6b14d48";
      };
    }
    {
      name = "_babel_helper_define_polyfill_provider___helper_define_polyfill_provider_0.3.1.tgz";
      path = fetchurl {
        name = "_babel_helper_define_polyfill_provider___helper_define_polyfill_provider_0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.3.1.tgz";
        sha1 = "52411b445bdb2e676869e5a74960d2d3826d2665";
      };
    }
    {
      name = "_babel_helper_environment_visitor___helper_environment_visitor_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_environment_visitor___helper_environment_visitor_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-environment-visitor/-/helper-environment-visitor-7.16.7.tgz";
        sha1 = "ff484094a839bde9d89cd63cba017d7aae80ecd7";
      };
    }
    {
      name = "_babel_helper_explode_assignable_expression___helper_explode_assignable_expression_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_explode_assignable_expression___helper_explode_assignable_expression_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-explode-assignable-expression/-/helper-explode-assignable-expression-7.16.7.tgz";
        sha1 = "12a6d8522fdd834f194e868af6354e8650242b7a";
      };
    }
    {
      name = "_babel_helper_function_name___helper_function_name_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_function_name___helper_function_name_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.16.7.tgz";
        sha1 = "f1ec51551fb1c8956bc8dd95f38523b6cf375f8f";
      };
    }
    {
      name = "_babel_helper_get_function_arity___helper_get_function_arity_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_get_function_arity___helper_get_function_arity_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-get-function-arity/-/helper-get-function-arity-7.16.7.tgz";
        sha1 = "ea08ac753117a669f1508ba06ebcc49156387419";
      };
    }
    {
      name = "_babel_helper_hoist_variables___helper_hoist_variables_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_hoist_variables___helper_hoist_variables_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-hoist-variables/-/helper-hoist-variables-7.16.7.tgz";
        sha1 = "86bcb19a77a509c7b77d0e22323ef588fa58c246";
      };
    }
    {
      name = "_babel_helper_member_expression_to_functions___helper_member_expression_to_functions_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_member_expression_to_functions___helper_member_expression_to_functions_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.16.7.tgz";
        sha1 = "42b9ca4b2b200123c3b7e726b0ae5153924905b0";
      };
    }
    {
      name = "_babel_helper_module_imports___helper_module_imports_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_module_imports___helper_module_imports_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.16.7.tgz";
        sha1 = "25612a8091a999704461c8a222d0efec5d091437";
      };
    }
    {
      name = "_babel_helper_module_transforms___helper_module_transforms_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_module_transforms___helper_module_transforms_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-module-transforms/-/helper-module-transforms-7.16.7.tgz";
        sha1 = "7665faeb721a01ca5327ddc6bba15a5cb34b6a41";
      };
    }
    {
      name = "_babel_helper_optimise_call_expression___helper_optimise_call_expression_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_optimise_call_expression___helper_optimise_call_expression_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.16.7.tgz";
        sha1 = "a34e3560605abbd31a18546bd2aad3e6d9a174f2";
      };
    }
    {
      name = "_babel_helper_plugin_utils___helper_plugin_utils_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_plugin_utils___helper_plugin_utils_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-plugin-utils/-/helper-plugin-utils-7.16.7.tgz";
        sha1 = "aa3a8ab4c3cceff8e65eb9e73d87dc4ff320b2f5";
      };
    }
    {
      name = "_babel_helper_remap_async_to_generator___helper_remap_async_to_generator_7.16.8.tgz";
      path = fetchurl {
        name = "_babel_helper_remap_async_to_generator___helper_remap_async_to_generator_7.16.8.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.16.8.tgz";
        sha1 = "29ffaade68a367e2ed09c90901986918d25e57e3";
      };
    }
    {
      name = "_babel_helper_replace_supers___helper_replace_supers_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_replace_supers___helper_replace_supers_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-replace-supers/-/helper-replace-supers-7.16.7.tgz";
        sha1 = "e9f5f5f32ac90429c1a4bdec0f231ef0c2838ab1";
      };
    }
    {
      name = "_babel_helper_simple_access___helper_simple_access_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_simple_access___helper_simple_access_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-simple-access/-/helper-simple-access-7.16.7.tgz";
        sha1 = "d656654b9ea08dbb9659b69d61063ccd343ff0f7";
      };
    }
    {
      name = "_babel_helper_skip_transparent_expression_wrappers___helper_skip_transparent_expression_wrappers_7.16.0.tgz";
      path = fetchurl {
        name = "_babel_helper_skip_transparent_expression_wrappers___helper_skip_transparent_expression_wrappers_7.16.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.16.0.tgz";
        sha1 = "0ee3388070147c3ae051e487eca3ebb0e2e8bb09";
      };
    }
    {
      name = "_babel_helper_split_export_declaration___helper_split_export_declaration_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_split_export_declaration___helper_split_export_declaration_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.16.7.tgz";
        sha1 = "0b648c0c42da9d3920d85ad585f2778620b8726b";
      };
    }
    {
      name = "_babel_helper_validator_identifier___helper_validator_identifier_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_validator_identifier___helper_validator_identifier_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.16.7.tgz";
        sha1 = "e8c602438c4a8195751243da9031d1607d247cad";
      };
    }
    {
      name = "_babel_helper_validator_option___helper_validator_option_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helper_validator_option___helper_validator_option_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-validator-option/-/helper-validator-option-7.16.7.tgz";
        sha1 = "b203ce62ce5fe153899b617c08957de860de4d23";
      };
    }
    {
      name = "_babel_helper_wrap_function___helper_wrap_function_7.16.8.tgz";
      path = fetchurl {
        name = "_babel_helper_wrap_function___helper_wrap_function_7.16.8.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helper-wrap-function/-/helper-wrap-function-7.16.8.tgz";
        sha1 = "58afda087c4cd235de92f7ceedebca2c41274200";
      };
    }
    {
      name = "_babel_helpers___helpers_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_helpers___helpers_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/helpers/-/helpers-7.16.7.tgz";
        sha1 = "7e3504d708d50344112767c3542fc5e357fffefc";
      };
    }
    {
      name = "_babel_highlight___highlight_7.16.10.tgz";
      path = fetchurl {
        name = "_babel_highlight___highlight_7.16.10.tgz";
        url  = "https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.16.10.tgz";
        sha1 = "744f2eb81579d6eea753c227b0f570ad785aba88";
      };
    }
    {
      name = "_babel_parser___parser_7.16.12.tgz";
      path = fetchurl {
        name = "_babel_parser___parser_7.16.12.tgz";
        url  = "https://registry.yarnpkg.com/@babel/parser/-/parser-7.16.12.tgz";
        sha1 = "9474794f9a650cf5e2f892444227f98e28cdf8b6";
      };
    }
    {
      name = "_babel_plugin_bugfix_safari_id_destructuring_collision_in_function_expression___plugin_bugfix_safari_id_destructuring_collision_in_function_expression_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_bugfix_safari_id_destructuring_collision_in_function_expression___plugin_bugfix_safari_id_destructuring_collision_in_function_expression_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.16.7.tgz";
        sha1 = "4eda6d6c2a0aa79c70fa7b6da67763dfe2141050";
      };
    }
    {
      name = "_babel_plugin_bugfix_v8_spread_parameters_in_optional_chaining___plugin_bugfix_v8_spread_parameters_in_optional_chaining_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_bugfix_v8_spread_parameters_in_optional_chaining___plugin_bugfix_v8_spread_parameters_in_optional_chaining_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.16.7.tgz";
        sha1 = "cc001234dfc139ac45f6bcf801866198c8c72ff9";
      };
    }
    {
      name = "_babel_plugin_proposal_async_generator_functions___plugin_proposal_async_generator_functions_7.16.8.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_async_generator_functions___plugin_proposal_async_generator_functions_7.16.8.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-async-generator-functions/-/plugin-proposal-async-generator-functions-7.16.8.tgz";
        sha1 = "3bdd1ebbe620804ea9416706cd67d60787504bc8";
      };
    }
    {
      name = "_babel_plugin_proposal_class_properties___plugin_proposal_class_properties_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_class_properties___plugin_proposal_class_properties_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-class-properties/-/plugin-proposal-class-properties-7.16.7.tgz";
        sha1 = "925cad7b3b1a2fcea7e59ecc8eb5954f961f91b0";
      };
    }
    {
      name = "_babel_plugin_proposal_class_static_block___plugin_proposal_class_static_block_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_class_static_block___plugin_proposal_class_static_block_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-class-static-block/-/plugin-proposal-class-static-block-7.16.7.tgz";
        sha1 = "712357570b612106ef5426d13dc433ce0f200c2a";
      };
    }
    {
      name = "_babel_plugin_proposal_dynamic_import___plugin_proposal_dynamic_import_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_dynamic_import___plugin_proposal_dynamic_import_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-dynamic-import/-/plugin-proposal-dynamic-import-7.16.7.tgz";
        sha1 = "c19c897eaa46b27634a00fee9fb7d829158704b2";
      };
    }
    {
      name = "_babel_plugin_proposal_export_namespace_from___plugin_proposal_export_namespace_from_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_export_namespace_from___plugin_proposal_export_namespace_from_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-export-namespace-from/-/plugin-proposal-export-namespace-from-7.16.7.tgz";
        sha1 = "09de09df18445a5786a305681423ae63507a6163";
      };
    }
    {
      name = "_babel_plugin_proposal_json_strings___plugin_proposal_json_strings_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_json_strings___plugin_proposal_json_strings_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-json-strings/-/plugin-proposal-json-strings-7.16.7.tgz";
        sha1 = "9732cb1d17d9a2626a08c5be25186c195b6fa6e8";
      };
    }
    {
      name = "_babel_plugin_proposal_logical_assignment_operators___plugin_proposal_logical_assignment_operators_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_logical_assignment_operators___plugin_proposal_logical_assignment_operators_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-logical-assignment-operators/-/plugin-proposal-logical-assignment-operators-7.16.7.tgz";
        sha1 = "be23c0ba74deec1922e639832904be0bea73cdea";
      };
    }
    {
      name = "_babel_plugin_proposal_nullish_coalescing_operator___plugin_proposal_nullish_coalescing_operator_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_nullish_coalescing_operator___plugin_proposal_nullish_coalescing_operator_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-nullish-coalescing-operator/-/plugin-proposal-nullish-coalescing-operator-7.16.7.tgz";
        sha1 = "141fc20b6857e59459d430c850a0011e36561d99";
      };
    }
    {
      name = "_babel_plugin_proposal_numeric_separator___plugin_proposal_numeric_separator_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_numeric_separator___plugin_proposal_numeric_separator_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-numeric-separator/-/plugin-proposal-numeric-separator-7.16.7.tgz";
        sha1 = "d6b69f4af63fb38b6ca2558442a7fb191236eba9";
      };
    }
    {
      name = "_babel_plugin_proposal_object_rest_spread___plugin_proposal_object_rest_spread_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_object_rest_spread___plugin_proposal_object_rest_spread_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-object-rest-spread/-/plugin-proposal-object-rest-spread-7.16.7.tgz";
        sha1 = "94593ef1ddf37021a25bdcb5754c4a8d534b01d8";
      };
    }
    {
      name = "_babel_plugin_proposal_optional_catch_binding___plugin_proposal_optional_catch_binding_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_optional_catch_binding___plugin_proposal_optional_catch_binding_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-optional-catch-binding/-/plugin-proposal-optional-catch-binding-7.16.7.tgz";
        sha1 = "c623a430674ffc4ab732fd0a0ae7722b67cb74cf";
      };
    }
    {
      name = "_babel_plugin_proposal_optional_chaining___plugin_proposal_optional_chaining_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_optional_chaining___plugin_proposal_optional_chaining_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-optional-chaining/-/plugin-proposal-optional-chaining-7.16.7.tgz";
        sha1 = "7cd629564724816c0e8a969535551f943c64c39a";
      };
    }
    {
      name = "_babel_plugin_proposal_private_methods___plugin_proposal_private_methods_7.16.11.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_private_methods___plugin_proposal_private_methods_7.16.11.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-private-methods/-/plugin-proposal-private-methods-7.16.11.tgz";
        sha1 = "e8df108288555ff259f4527dbe84813aac3a1c50";
      };
    }
    {
      name = "_babel_plugin_proposal_private_property_in_object___plugin_proposal_private_property_in_object_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_private_property_in_object___plugin_proposal_private_property_in_object_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.16.7.tgz";
        sha1 = "b0b8cef543c2c3d57e59e2c611994861d46a3fce";
      };
    }
    {
      name = "_babel_plugin_proposal_unicode_property_regex___plugin_proposal_unicode_property_regex_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_proposal_unicode_property_regex___plugin_proposal_unicode_property_regex_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-proposal-unicode-property-regex/-/plugin-proposal-unicode-property-regex-7.16.7.tgz";
        sha1 = "635d18eb10c6214210ffc5ff4932552de08188a2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_async_generators___plugin_syntax_async_generators_7.8.4.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_async_generators___plugin_syntax_async_generators_7.8.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz";
<<<<<<< HEAD
        sha512 = "tycmZxkGfZaxhMRbXlPXuVFpdWlXpir2W4AMhSJgRKzk/eDlIXOhb2LHWoLpDF7TEHylV5zNhykX6KAgHJmTNw==";
=======
        sha1 = "a983fb1aeb2ec3f6ed042a210f640e90e786fe0d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_class_properties___plugin_syntax_class_properties_7.12.13.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_class_properties___plugin_syntax_class_properties_7.12.13.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz";
<<<<<<< HEAD
        sha512 = "fm4idjKla0YahUNgFNLCB0qySdsoPiZP3iQE3rky0mBUtMZ23yDJ9SJdg6dXTSDnulOVqiF3Hgr9nbXvXTQZYA==";
=======
        sha1 = "b5c987274c4a3a82b89714796931a6b53544ae10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_class_static_block___plugin_syntax_class_static_block_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_class_static_block___plugin_syntax_class_static_block_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-class-static-block/-/plugin-syntax-class-static-block-7.14.5.tgz";
<<<<<<< HEAD
        sha512 = "b+YyPmr6ldyNnM6sqYeMWE+bgJcJpO6yS4QD7ymxgH34GBPNDM/THBh8iunyvKIZztiwLH4CJZ0RxTk9emgpjw==";
=======
        sha1 = "195df89b146b4b78b3bf897fd7a257c84659d406";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_dynamic_import___plugin_syntax_dynamic_import_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_dynamic_import___plugin_syntax_dynamic_import_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz";
<<<<<<< HEAD
        sha512 = "5gdGbFon+PszYzqs83S3E5mpi7/y/8M9eC90MRTZfduQOYW76ig6SOSPNe41IG5LoP3FGBn2N0RjVDSQiS94kQ==";
=======
        sha1 = "62bf98b2da3cd21d626154fc96ee5b3cb68eacb3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_export_namespace_from___plugin_syntax_export_namespace_from_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_export_namespace_from___plugin_syntax_export_namespace_from_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz";
<<<<<<< HEAD
        sha512 = "MXf5laXo6c1IbEbegDmzGPwGNTsHZmEy6QGznu5Sh2UCWvueywb2ee+CCE4zQiZstxU9BMoQO9i6zUFSY0Kj0Q==";
      };
    }
    {
      name = "_babel_plugin_syntax_import_assertions___plugin_syntax_import_assertions_7.20.0.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_import_assertions___plugin_syntax_import_assertions_7.20.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.20.0.tgz";
        sha512 = "IUh1vakzNoWalR8ch/areW7qFopR2AEw03JlG7BbrDqmQ4X3q9uuipQwSGrUn7oGiemKjtSLDhNtQHzMHr1JdQ==";
      };
    }
    {
      name = "_babel_plugin_syntax_import_meta___plugin_syntax_import_meta_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_import_meta___plugin_syntax_import_meta_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz";
        sha512 = "Yqfm+XDx0+Prh3VSeEQCPU81yC+JWZ2pDPFSS4ZdpfZhp4MkFMaDC1UqseovEKwSUpnIL7+vK+Clp7bfh0iD7g==";
=======
        sha1 = "028964a9ba80dbc094c915c487ad7c4e7a66465a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_json_strings___plugin_syntax_json_strings_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_json_strings___plugin_syntax_json_strings_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz";
<<<<<<< HEAD
        sha512 = "lY6kdGpWHvjoe2vk4WrAapEuBR69EMxZl+RoGRhrFGNYVK8mOPAW8VfbT/ZgrFbXlDNiiaxQnAtgVCZ6jv30EA==";
      };
    }
    {
      name = "_babel_plugin_syntax_jsx___plugin_syntax_jsx_7.21.4.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_jsx___plugin_syntax_jsx_7.21.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.21.4.tgz";
        sha512 = "5hewiLct5OKyh6PLKEYaFclcqtIgCb6bmELouxjF6up5q3Sov7rOayW4RwhbaBL0dit8rA80GNfY+UuDp2mBbQ==";
=======
        sha1 = "01ca21b668cd8218c9e640cb6dd88c5412b2c96a";
      };
    }
    {
      name = "_babel_plugin_syntax_jsx___plugin_syntax_jsx_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_jsx___plugin_syntax_jsx_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.16.7.tgz";
        sha1 = "50b6571d13f764266a113d77c82b4a6508bbe665";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_logical_assignment_operators___plugin_syntax_logical_assignment_operators_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_logical_assignment_operators___plugin_syntax_logical_assignment_operators_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz";
<<<<<<< HEAD
        sha512 = "d8waShlpFDinQ5MtvGU9xDAOzKH47+FFoney2baFIoMr952hKOLp1HR7VszoZvOsV/4+RRszNY7D17ba0te0ig==";
=======
        sha1 = "ca91ef46303530448b906652bac2e9fe9941f699";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_nullish_coalescing_operator___plugin_syntax_nullish_coalescing_operator_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_nullish_coalescing_operator___plugin_syntax_nullish_coalescing_operator_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz";
<<<<<<< HEAD
        sha512 = "aSff4zPII1u2QD7y+F8oDsz19ew4IGEJg9SVW+bqwpwtfFleiQDMdzA/R+UlWDzfnHFCxxleFT0PMIrR36XLNQ==";
=======
        sha1 = "167ed70368886081f74b5c36c65a88c03b66d1a9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_numeric_separator___plugin_syntax_numeric_separator_7.10.4.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_numeric_separator___plugin_syntax_numeric_separator_7.10.4.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz";
<<<<<<< HEAD
        sha512 = "9H6YdfkcK/uOnY/K7/aA2xpzaAgkQn37yzWUMRK7OaPOqOpGS1+n0H5hxT9AUw9EsSjPW8SVyMJwYRtWs3X3ug==";
=======
        sha1 = "b9b070b3e33570cd9fd07ba7fa91c0dd37b9af97";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_object_rest_spread___plugin_syntax_object_rest_spread_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_object_rest_spread___plugin_syntax_object_rest_spread_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz";
<<<<<<< HEAD
        sha512 = "XoqMijGZb9y3y2XskN+P1wUGiVwWZ5JmoDRwx5+3GmEplNyVM2s2Dg8ILFQm8rWM48orGy5YpI5Bl8U1y7ydlA==";
=======
        sha1 = "60e225edcbd98a640332a2e72dd3e66f1af55871";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_optional_catch_binding___plugin_syntax_optional_catch_binding_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_optional_catch_binding___plugin_syntax_optional_catch_binding_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz";
<<<<<<< HEAD
        sha512 = "6VPD0Pc1lpTqw0aKoeRTMiB+kWhAoT24PA+ksWSBrFtl5SIRVpZlwN3NNPQjehA2E/91FV3RjLWoVTglWcSV3Q==";
=======
        sha1 = "6111a265bcfb020eb9efd0fdfd7d26402b9ed6c1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_optional_chaining___plugin_syntax_optional_chaining_7.8.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_optional_chaining___plugin_syntax_optional_chaining_7.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz";
<<<<<<< HEAD
        sha512 = "KoK9ErH1MBlCPxV0VANkXW2/dw4vlbGDrFgz8bmUsBGYkFRcbRwMh6cIJubdPrkxRwuGdtCk0v/wPTKbQgBjkg==";
=======
        sha1 = "4f69c2ab95167e0180cd5336613f8c5788f7d48a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_private_property_in_object___plugin_syntax_private_property_in_object_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_private_property_in_object___plugin_syntax_private_property_in_object_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-private-property-in-object/-/plugin-syntax-private-property-in-object-7.14.5.tgz";
<<<<<<< HEAD
        sha512 = "0wVnp9dxJ72ZUJDV27ZfbSj6iHLoytYZmh3rFcxNnvsJF3ktkzLDZPy/mA17HGsaQT3/DQsWYX1f1QGWkCoVUg==";
=======
        sha1 = "0dc6671ec0ea22b6e94a1114f857970cd39de1ad";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_plugin_syntax_top_level_await___plugin_syntax_top_level_await_7.14.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_syntax_top_level_await___plugin_syntax_top_level_await_7.14.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz";
<<<<<<< HEAD
        sha512 = "hx++upLv5U1rgYfwe1xBQUhRmU41NEvpUvrp8jkrSCdvGSnM5/qdRMtylJ6PG5OFkBaHkbTAKTnd3/YyESRHFw==";
      };
    }
    {
      name = "_babel_plugin_transform_arrow_functions___plugin_transform_arrow_functions_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_arrow_functions___plugin_transform_arrow_functions_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.21.5.tgz";
        sha512 = "wb1mhwGOCaXHDTcsRYMKF9e5bbMgqwxtqa2Y1ifH96dXJPwbuLX9qHy3clhrxVqgMz7nyNXs8VkxdH8UBcjKqA==";
      };
    }
    {
      name = "_babel_plugin_transform_async_to_generator___plugin_transform_async_to_generator_7.20.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_async_to_generator___plugin_transform_async_to_generator_7.20.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.20.7.tgz";
        sha512 = "Uo5gwHPT9vgnSXQxqGtpdufUiWp96gk7yiP4Mp5bm1QMkEmLXBO7PAGYbKoJ6DhAwiNkcHFBol/x5zZZkL/t0Q==";
      };
    }
    {
      name = "_babel_plugin_transform_block_scoped_functions___plugin_transform_block_scoped_functions_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_block_scoped_functions___plugin_transform_block_scoped_functions_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.18.6.tgz";
        sha512 = "ExUcOqpPWnliRcPqves5HJcJOvHvIIWfuS4sroBUenPuMdmW+SMHDakmtS7qOo13sVppmUijqeTv7qqGsvURpQ==";
      };
    }
    {
      name = "_babel_plugin_transform_block_scoping___plugin_transform_block_scoping_7.21.0.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_block_scoping___plugin_transform_block_scoping_7.21.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.21.0.tgz";
        sha512 = "Mdrbunoh9SxwFZapeHVrwFmri16+oYotcZysSzhNIVDwIAb1UV+kvnxULSYq9J3/q5MDG+4X6w8QVgD1zhBXNQ==";
      };
    }
    {
      name = "_babel_plugin_transform_classes___plugin_transform_classes_7.21.0.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_classes___plugin_transform_classes_7.21.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-classes/-/plugin-transform-classes-7.21.0.tgz";
        sha512 = "RZhbYTCEUAe6ntPehC4hlslPWosNHDox+vAs4On/mCLRLfoDVHf6hVEd7kuxr1RnHwJmxFfUM3cZiZRmPxJPXQ==";
      };
    }
    {
      name = "_babel_plugin_transform_computed_properties___plugin_transform_computed_properties_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_computed_properties___plugin_transform_computed_properties_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.21.5.tgz";
        sha512 = "TR653Ki3pAwxBxUe8srfF3e4Pe3FTA46uaNHYyQwIoM4oWKSoOZiDNyHJ0oIoDIUPSRQbQG7jzgVBX3FPVne1Q==";
      };
    }
    {
      name = "_babel_plugin_transform_destructuring___plugin_transform_destructuring_7.21.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_destructuring___plugin_transform_destructuring_7.21.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.21.3.tgz";
        sha512 = "bp6hwMFzuiE4HqYEyoGJ/V2LeIWn+hLVKc4pnj++E5XQptwhtcGmSayM029d/j2X1bPKGTlsyPwAubuU22KhMA==";
      };
    }
    {
      name = "_babel_plugin_transform_dotall_regex___plugin_transform_dotall_regex_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_dotall_regex___plugin_transform_dotall_regex_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.18.6.tgz";
        sha512 = "6S3jpun1eEbAxq7TdjLotAsl4WpQI9DxfkycRcKrjhQYzU87qpXdknpBg/e+TdcMehqGnLFi7tnFUBR02Vq6wg==";
      };
    }
    {
      name = "_babel_plugin_transform_duplicate_keys___plugin_transform_duplicate_keys_7.18.9.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_duplicate_keys___plugin_transform_duplicate_keys_7.18.9.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.18.9.tgz";
        sha512 = "d2bmXCtZXYc59/0SanQKbiWINadaJXqtvIQIzd4+hNwkWBgyCd5F/2t1kXoUdvPMrxzPvhK6EMQRROxsue+mfw==";
      };
    }
    {
      name = "_babel_plugin_transform_exponentiation_operator___plugin_transform_exponentiation_operator_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_exponentiation_operator___plugin_transform_exponentiation_operator_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.18.6.tgz";
        sha512 = "wzEtc0+2c88FVR34aQmiz56dxEkxr2g8DQb/KfaFa1JYXOFVsbhvAonFN6PwVWj++fKmku8NP80plJ5Et4wqHw==";
      };
    }
    {
      name = "_babel_plugin_transform_for_of___plugin_transform_for_of_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_for_of___plugin_transform_for_of_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.21.5.tgz";
        sha512 = "nYWpjKW/7j/I/mZkGVgHJXh4bA1sfdFnJoOXwJuj4m3Q2EraO/8ZyrkCau9P5tbHQk01RMSt6KYLCsW7730SXQ==";
      };
    }
    {
      name = "_babel_plugin_transform_function_name___plugin_transform_function_name_7.18.9.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_function_name___plugin_transform_function_name_7.18.9.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.18.9.tgz";
        sha512 = "WvIBoRPaJQ5yVHzcnJFor7oS5Ls0PYixlTYE63lCj2RtdQEl15M68FXQlxnG6wdraJIXRdR7KI+hQ7q/9QjrCQ==";
      };
    }
    {
      name = "_babel_plugin_transform_literals___plugin_transform_literals_7.18.9.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_literals___plugin_transform_literals_7.18.9.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-literals/-/plugin-transform-literals-7.18.9.tgz";
        sha512 = "IFQDSRoTPnrAIrI5zoZv73IFeZu2dhu6irxQjY9rNjTT53VmKg9fenjvoiOWOkJ6mm4jKVPtdMzBY98Fp4Z4cg==";
      };
    }
    {
      name = "_babel_plugin_transform_member_expression_literals___plugin_transform_member_expression_literals_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_member_expression_literals___plugin_transform_member_expression_literals_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.18.6.tgz";
        sha512 = "qSF1ihLGO3q+/g48k85tUjD033C29TNTVB2paCwZPVmOsjn9pClvYYrM2VeJpBY2bcNkuny0YUyTNRyRxJ54KA==";
      };
    }
    {
      name = "_babel_plugin_transform_modules_amd___plugin_transform_modules_amd_7.20.11.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_modules_amd___plugin_transform_modules_amd_7.20.11.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.20.11.tgz";
        sha512 = "NuzCt5IIYOW0O30UvqktzHYR2ud5bOWbY0yaxWZ6G+aFzOMJvrs5YHNikrbdaT15+KNO31nPOy5Fim3ku6Zb5g==";
      };
    }
    {
      name = "_babel_plugin_transform_modules_commonjs___plugin_transform_modules_commonjs_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_modules_commonjs___plugin_transform_modules_commonjs_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.21.5.tgz";
        sha512 = "OVryBEgKUbtqMoB7eG2rs6UFexJi6Zj6FDXx+esBLPTCxCNxAY9o+8Di7IsUGJ+AVhp5ncK0fxWUBd0/1gPhrQ==";
      };
    }
    {
      name = "_babel_plugin_transform_modules_systemjs___plugin_transform_modules_systemjs_7.20.11.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_modules_systemjs___plugin_transform_modules_systemjs_7.20.11.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.20.11.tgz";
        sha512 = "vVu5g9BPQKSFEmvt2TA4Da5N+QVS66EX21d8uoOihC+OCpUoGvzVsXeqFdtAEfVa5BILAeFt+U7yVmLbQnAJmw==";
      };
    }
    {
      name = "_babel_plugin_transform_modules_umd___plugin_transform_modules_umd_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_modules_umd___plugin_transform_modules_umd_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.18.6.tgz";
        sha512 = "dcegErExVeXcRqNtkRU/z8WlBLnvD4MRnHgNs3MytRO1Mn1sHRyhbcpYbVMGclAqOjdW+9cfkdZno9dFdfKLfQ==";
      };
    }
    {
      name = "_babel_plugin_transform_named_capturing_groups_regex___plugin_transform_named_capturing_groups_regex_7.20.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_named_capturing_groups_regex___plugin_transform_named_capturing_groups_regex_7.20.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.20.5.tgz";
        sha512 = "mOW4tTzi5iTLnw+78iEq3gr8Aoq4WNRGpmSlrogqaiCBoR1HFhpU4JkpQFOHfeYx3ReVIFWOQJS4aZBRvuZ6mA==";
      };
    }
    {
      name = "_babel_plugin_transform_new_target___plugin_transform_new_target_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_new_target___plugin_transform_new_target_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.18.6.tgz";
        sha512 = "DjwFA/9Iu3Z+vrAn+8pBUGcjhxKguSMlsFqeCKbhb9BAV756v0krzVK04CRDi/4aqmk8BsHb4a/gFcaA5joXRw==";
      };
    }
    {
      name = "_babel_plugin_transform_object_super___plugin_transform_object_super_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_object_super___plugin_transform_object_super_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.18.6.tgz";
        sha512 = "uvGz6zk+pZoS1aTZrOvrbj6Pp/kK2mp45t2B+bTDre2UgsZZ8EZLSJtUg7m/no0zOJUWgFONpB7Zv9W2tSaFlA==";
      };
    }
    {
      name = "_babel_plugin_transform_parameters___plugin_transform_parameters_7.21.3.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_parameters___plugin_transform_parameters_7.21.3.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.21.3.tgz";
        sha512 = "Wxc+TvppQG9xWFYatvCGPvZ6+SIUxQ2ZdiBP+PHYMIjnPXD+uThCshaz4NZOnODAtBjjcVQQ/3OKs9LW28purQ==";
      };
    }
    {
      name = "_babel_plugin_transform_property_literals___plugin_transform_property_literals_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_property_literals___plugin_transform_property_literals_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.18.6.tgz";
        sha512 = "cYcs6qlgafTud3PAzrrRNbQtfpQ8+y/+M5tKmksS9+M1ckbH6kzY8MrexEM9mcA6JDsukE19iIRvAyYl463sMg==";
      };
    }
    {
      name = "_babel_plugin_transform_react_display_name___plugin_transform_react_display_name_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_react_display_name___plugin_transform_react_display_name_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-react-display-name/-/plugin-transform-react-display-name-7.18.6.tgz";
        sha512 = "TV4sQ+T013n61uMoygyMRm+xf04Bd5oqFpv2jAEQwSZ8NwQA7zeRPg1LMVg2PWi3zWBz+CLKD+v5bcpZ/BS0aA==";
      };
    }
    {
      name = "_babel_plugin_transform_react_jsx_development___plugin_transform_react_jsx_development_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_react_jsx_development___plugin_transform_react_jsx_development_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-react-jsx-development/-/plugin-transform-react-jsx-development-7.18.6.tgz";
        sha512 = "SA6HEjwYFKF7WDjWcMcMGUimmw/nhNRDWxr+KaLSCrkD/LMDBvWRmHAYgE1HDeF8KUuI8OAu+RT6EOtKxSW2qA==";
      };
    }
    {
      name = "_babel_plugin_transform_react_jsx___plugin_transform_react_jsx_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_react_jsx___plugin_transform_react_jsx_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-react-jsx/-/plugin-transform-react-jsx-7.21.5.tgz";
        sha512 = "ELdlq61FpoEkHO6gFRpfj0kUgSwQTGoaEU8eMRoS8Dv3v6e7BjEAj5WMtIBRdHUeAioMhKP5HyxNzNnP+heKbA==";
      };
    }
    {
      name = "_babel_plugin_transform_react_pure_annotations___plugin_transform_react_pure_annotations_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_react_pure_annotations___plugin_transform_react_pure_annotations_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-react-pure-annotations/-/plugin-transform-react-pure-annotations-7.18.6.tgz";
        sha512 = "I8VfEPg9r2TRDdvnHgPepTKvuRomzA8+u+nhY7qSI1fR2hRNebasZEETLyM5mAUr0Ku56OkXJ0I7NHJnO6cJiQ==";
      };
    }
    {
      name = "_babel_plugin_transform_regenerator___plugin_transform_regenerator_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_regenerator___plugin_transform_regenerator_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.21.5.tgz";
        sha512 = "ZoYBKDb6LyMi5yCsByQ5jmXsHAQDDYeexT1Szvlmui+lADvfSecr5Dxd/PkrTC3pAD182Fcju1VQkB4oCp9M+w==";
      };
    }
    {
      name = "_babel_plugin_transform_reserved_words___plugin_transform_reserved_words_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_reserved_words___plugin_transform_reserved_words_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.18.6.tgz";
        sha512 = "oX/4MyMoypzHjFrT1CdivfKZ+XvIPMFXwwxHp/r0Ddy2Vuomt4HDFGmft1TAY2yiTKiNSsh3kjBAzcM8kSdsjA==";
      };
    }
    {
      name = "_babel_plugin_transform_shorthand_properties___plugin_transform_shorthand_properties_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_shorthand_properties___plugin_transform_shorthand_properties_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.18.6.tgz";
        sha512 = "eCLXXJqv8okzg86ywZJbRn19YJHU4XUa55oz2wbHhaQVn/MM+XhukiT7SYqp/7o00dg52Rj51Ny+Ecw4oyoygw==";
      };
    }
    {
      name = "_babel_plugin_transform_spread___plugin_transform_spread_7.20.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_spread___plugin_transform_spread_7.20.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-spread/-/plugin-transform-spread-7.20.7.tgz";
        sha512 = "ewBbHQ+1U/VnH1fxltbJqDeWBU1oNLG8Dj11uIv3xVf7nrQu0bPGe5Rf716r7K5Qz+SqtAOVswoVunoiBtGhxw==";
      };
    }
    {
      name = "_babel_plugin_transform_sticky_regex___plugin_transform_sticky_regex_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_sticky_regex___plugin_transform_sticky_regex_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.18.6.tgz";
        sha512 = "kfiDrDQ+PBsQDO85yj1icueWMfGfJFKN1KCkndygtu/C9+XUfydLC8Iv5UYJqRwy4zk8EcplRxEOeLyjq1gm6Q==";
      };
    }
    {
      name = "_babel_plugin_transform_template_literals___plugin_transform_template_literals_7.18.9.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_template_literals___plugin_transform_template_literals_7.18.9.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.18.9.tgz";
        sha512 = "S8cOWfT82gTezpYOiVaGHrCbhlHgKhQt8XH5ES46P2XWmX92yisoZywf5km75wv5sYcXDUCLMmMxOLCtthDgMA==";
      };
    }
    {
      name = "_babel_plugin_transform_typeof_symbol___plugin_transform_typeof_symbol_7.18.9.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_typeof_symbol___plugin_transform_typeof_symbol_7.18.9.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.18.9.tgz";
        sha512 = "SRfwTtF11G2aemAZWivL7PD+C9z52v9EvMqH9BuYbabyPuKUvSWks3oCg6041pT925L4zVFqaVBeECwsmlguEw==";
      };
    }
    {
      name = "_babel_plugin_transform_unicode_escapes___plugin_transform_unicode_escapes_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_unicode_escapes___plugin_transform_unicode_escapes_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.21.5.tgz";
        sha512 = "LYm/gTOwZqsYohlvFUe/8Tujz75LqqVC2w+2qPHLR+WyWHGCZPN1KBpJCJn+4Bk4gOkQy/IXKIge6az5MqwlOg==";
      };
    }
    {
      name = "_babel_plugin_transform_unicode_regex___plugin_transform_unicode_regex_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_unicode_regex___plugin_transform_unicode_regex_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.18.6.tgz";
        sha512 = "gE7A6Lt7YLnNOL3Pb9BNeZvi+d8l7tcRrG4+pwJjK9hD2xX4mEvjlQW60G9EEmfXVYRPv9VRQcyegIVHCql/AA==";
      };
    }
    {
      name = "_babel_preset_env___preset_env_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_preset_env___preset_env_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/preset-env/-/preset-env-7.21.5.tgz";
        sha512 = "wH00QnTTldTbf/IefEVyChtRdw5RJvODT/Vb4Vcxq1AZvtXj6T0YeX0cAcXhI6/BdGuiP3GcNIL4OQbI2DVNxg==";
=======
        sha1 = "c1cfdadc35a646240001f06138247b741c34d94c";
      };
    }
    {
      name = "_babel_plugin_transform_arrow_functions___plugin_transform_arrow_functions_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_arrow_functions___plugin_transform_arrow_functions_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.16.7.tgz";
        sha1 = "44125e653d94b98db76369de9c396dc14bef4154";
      };
    }
    {
      name = "_babel_plugin_transform_async_to_generator___plugin_transform_async_to_generator_7.16.8.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_async_to_generator___plugin_transform_async_to_generator_7.16.8.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.16.8.tgz";
        sha1 = "b83dff4b970cf41f1b819f8b49cc0cfbaa53a808";
      };
    }
    {
      name = "_babel_plugin_transform_block_scoped_functions___plugin_transform_block_scoped_functions_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_block_scoped_functions___plugin_transform_block_scoped_functions_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.16.7.tgz";
        sha1 = "4d0d57d9632ef6062cdf354bb717102ee042a620";
      };
    }
    {
      name = "_babel_plugin_transform_block_scoping___plugin_transform_block_scoping_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_block_scoping___plugin_transform_block_scoping_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.16.7.tgz";
        sha1 = "f50664ab99ddeaee5bc681b8f3a6ea9d72ab4f87";
      };
    }
    {
      name = "_babel_plugin_transform_classes___plugin_transform_classes_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_classes___plugin_transform_classes_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-classes/-/plugin-transform-classes-7.16.7.tgz";
        sha1 = "8f4b9562850cd973de3b498f1218796eb181ce00";
      };
    }
    {
      name = "_babel_plugin_transform_computed_properties___plugin_transform_computed_properties_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_computed_properties___plugin_transform_computed_properties_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.16.7.tgz";
        sha1 = "66dee12e46f61d2aae7a73710f591eb3df616470";
      };
    }
    {
      name = "_babel_plugin_transform_destructuring___plugin_transform_destructuring_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_destructuring___plugin_transform_destructuring_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.16.7.tgz";
        sha1 = "ca9588ae2d63978a4c29d3f33282d8603f618e23";
      };
    }
    {
      name = "_babel_plugin_transform_dotall_regex___plugin_transform_dotall_regex_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_dotall_regex___plugin_transform_dotall_regex_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.16.7.tgz";
        sha1 = "6b2d67686fab15fb6a7fd4bd895d5982cfc81241";
      };
    }
    {
      name = "_babel_plugin_transform_duplicate_keys___plugin_transform_duplicate_keys_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_duplicate_keys___plugin_transform_duplicate_keys_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.16.7.tgz";
        sha1 = "2207e9ca8f82a0d36a5a67b6536e7ef8b08823c9";
      };
    }
    {
      name = "_babel_plugin_transform_exponentiation_operator___plugin_transform_exponentiation_operator_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_exponentiation_operator___plugin_transform_exponentiation_operator_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.16.7.tgz";
        sha1 = "efa9862ef97e9e9e5f653f6ddc7b665e8536fe9b";
      };
    }
    {
      name = "_babel_plugin_transform_for_of___plugin_transform_for_of_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_for_of___plugin_transform_for_of_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.16.7.tgz";
        sha1 = "649d639d4617dff502a9a158c479b3b556728d8c";
      };
    }
    {
      name = "_babel_plugin_transform_function_name___plugin_transform_function_name_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_function_name___plugin_transform_function_name_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.16.7.tgz";
        sha1 = "5ab34375c64d61d083d7d2f05c38d90b97ec65cf";
      };
    }
    {
      name = "_babel_plugin_transform_literals___plugin_transform_literals_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_literals___plugin_transform_literals_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-literals/-/plugin-transform-literals-7.16.7.tgz";
        sha1 = "254c9618c5ff749e87cb0c0cef1a0a050c0bdab1";
      };
    }
    {
      name = "_babel_plugin_transform_member_expression_literals___plugin_transform_member_expression_literals_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_member_expression_literals___plugin_transform_member_expression_literals_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.16.7.tgz";
        sha1 = "6e5dcf906ef8a098e630149d14c867dd28f92384";
      };
    }
    {
      name = "_babel_plugin_transform_modules_amd___plugin_transform_modules_amd_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_modules_amd___plugin_transform_modules_amd_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.16.7.tgz";
        sha1 = "b28d323016a7daaae8609781d1f8c9da42b13186";
      };
    }
    {
      name = "_babel_plugin_transform_modules_commonjs___plugin_transform_modules_commonjs_7.16.8.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_modules_commonjs___plugin_transform_modules_commonjs_7.16.8.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.16.8.tgz";
        sha1 = "cdee19aae887b16b9d331009aa9a219af7c86afe";
      };
    }
    {
      name = "_babel_plugin_transform_modules_systemjs___plugin_transform_modules_systemjs_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_modules_systemjs___plugin_transform_modules_systemjs_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.16.7.tgz";
        sha1 = "887cefaef88e684d29558c2b13ee0563e287c2d7";
      };
    }
    {
      name = "_babel_plugin_transform_modules_umd___plugin_transform_modules_umd_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_modules_umd___plugin_transform_modules_umd_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.16.7.tgz";
        sha1 = "23dad479fa585283dbd22215bff12719171e7618";
      };
    }
    {
      name = "_babel_plugin_transform_named_capturing_groups_regex___plugin_transform_named_capturing_groups_regex_7.16.8.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_named_capturing_groups_regex___plugin_transform_named_capturing_groups_regex_7.16.8.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.16.8.tgz";
        sha1 = "7f860e0e40d844a02c9dcf9d84965e7dfd666252";
      };
    }
    {
      name = "_babel_plugin_transform_new_target___plugin_transform_new_target_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_new_target___plugin_transform_new_target_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.16.7.tgz";
        sha1 = "9967d89a5c243818e0800fdad89db22c5f514244";
      };
    }
    {
      name = "_babel_plugin_transform_object_super___plugin_transform_object_super_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_object_super___plugin_transform_object_super_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.16.7.tgz";
        sha1 = "ac359cf8d32cf4354d27a46867999490b6c32a94";
      };
    }
    {
      name = "_babel_plugin_transform_parameters___plugin_transform_parameters_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_parameters___plugin_transform_parameters_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.16.7.tgz";
        sha1 = "a1721f55b99b736511cb7e0152f61f17688f331f";
      };
    }
    {
      name = "_babel_plugin_transform_property_literals___plugin_transform_property_literals_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_property_literals___plugin_transform_property_literals_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.16.7.tgz";
        sha1 = "2dadac85155436f22c696c4827730e0fe1057a55";
      };
    }
    {
      name = "_babel_plugin_transform_react_display_name___plugin_transform_react_display_name_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_react_display_name___plugin_transform_react_display_name_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-react-display-name/-/plugin-transform-react-display-name-7.16.7.tgz";
        sha1 = "7b6d40d232f4c0f550ea348593db3b21e2404340";
      };
    }
    {
      name = "_babel_plugin_transform_react_jsx_development___plugin_transform_react_jsx_development_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_react_jsx_development___plugin_transform_react_jsx_development_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-react-jsx-development/-/plugin-transform-react-jsx-development-7.16.7.tgz";
        sha1 = "43a00724a3ed2557ed3f276a01a929e6686ac7b8";
      };
    }
    {
      name = "_babel_plugin_transform_react_jsx___plugin_transform_react_jsx_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_react_jsx___plugin_transform_react_jsx_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-react-jsx/-/plugin-transform-react-jsx-7.16.7.tgz";
        sha1 = "86a6a220552afd0e4e1f0388a68a372be7add0d4";
      };
    }
    {
      name = "_babel_plugin_transform_react_pure_annotations___plugin_transform_react_pure_annotations_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_react_pure_annotations___plugin_transform_react_pure_annotations_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-react-pure-annotations/-/plugin-transform-react-pure-annotations-7.16.7.tgz";
        sha1 = "232bfd2f12eb551d6d7d01d13fe3f86b45eb9c67";
      };
    }
    {
      name = "_babel_plugin_transform_regenerator___plugin_transform_regenerator_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_regenerator___plugin_transform_regenerator_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.16.7.tgz";
        sha1 = "9e7576dc476cb89ccc5096fff7af659243b4adeb";
      };
    }
    {
      name = "_babel_plugin_transform_reserved_words___plugin_transform_reserved_words_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_reserved_words___plugin_transform_reserved_words_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.16.7.tgz";
        sha1 = "1d798e078f7c5958eec952059c460b220a63f586";
      };
    }
    {
      name = "_babel_plugin_transform_shorthand_properties___plugin_transform_shorthand_properties_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_shorthand_properties___plugin_transform_shorthand_properties_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.16.7.tgz";
        sha1 = "e8549ae4afcf8382f711794c0c7b6b934c5fbd2a";
      };
    }
    {
      name = "_babel_plugin_transform_spread___plugin_transform_spread_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_spread___plugin_transform_spread_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-spread/-/plugin-transform-spread-7.16.7.tgz";
        sha1 = "a303e2122f9f12e0105daeedd0f30fb197d8ff44";
      };
    }
    {
      name = "_babel_plugin_transform_sticky_regex___plugin_transform_sticky_regex_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_sticky_regex___plugin_transform_sticky_regex_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.16.7.tgz";
        sha1 = "c84741d4f4a38072b9a1e2e3fd56d359552e8660";
      };
    }
    {
      name = "_babel_plugin_transform_template_literals___plugin_transform_template_literals_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_template_literals___plugin_transform_template_literals_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.16.7.tgz";
        sha1 = "f3d1c45d28967c8e80f53666fc9c3e50618217ab";
      };
    }
    {
      name = "_babel_plugin_transform_typeof_symbol___plugin_transform_typeof_symbol_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_typeof_symbol___plugin_transform_typeof_symbol_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.16.7.tgz";
        sha1 = "9cdbe622582c21368bd482b660ba87d5545d4f7e";
      };
    }
    {
      name = "_babel_plugin_transform_unicode_escapes___plugin_transform_unicode_escapes_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_unicode_escapes___plugin_transform_unicode_escapes_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.16.7.tgz";
        sha1 = "da8717de7b3287a2c6d659750c964f302b31ece3";
      };
    }
    {
      name = "_babel_plugin_transform_unicode_regex___plugin_transform_unicode_regex_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_plugin_transform_unicode_regex___plugin_transform_unicode_regex_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.16.7.tgz";
        sha1 = "0f7aa4a501198976e25e82702574c34cfebe9ef2";
      };
    }
    {
      name = "_babel_preset_env___preset_env_7.16.11.tgz";
      path = fetchurl {
        name = "_babel_preset_env___preset_env_7.16.11.tgz";
        url  = "https://registry.yarnpkg.com/@babel/preset-env/-/preset-env-7.16.11.tgz";
        sha1 = "5dd88fd885fae36f88fd7c8342475c9f0abe2982";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_babel_preset_modules___preset_modules_0.1.5.tgz";
      path = fetchurl {
        name = "_babel_preset_modules___preset_modules_0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/preset-modules/-/preset-modules-0.1.5.tgz";
<<<<<<< HEAD
        sha512 = "A57th6YRG7oR3cq/yt/Y84MvGgE0eJG2F1JLhKuyG+jFxEgrd/HAMJatiFtmOiZurz+0DkrvbheCLaV5f2JfjA==";
      };
    }
    {
      name = "_babel_preset_react___preset_react_7.18.6.tgz";
      path = fetchurl {
        name = "_babel_preset_react___preset_react_7.18.6.tgz";
        url  = "https://registry.yarnpkg.com/@babel/preset-react/-/preset-react-7.18.6.tgz";
        sha512 = "zXr6atUmyYdiWRVLOZahakYmOBHtWc2WGCkP8PYTgZi0iJXDY2CN180TdrIW4OGOAdLc7TifzDIvtx6izaRIzg==";
      };
    }
    {
      name = "_babel_regjsgen___regjsgen_0.8.0.tgz";
      path = fetchurl {
        name = "_babel_regjsgen___regjsgen_0.8.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/regjsgen/-/regjsgen-0.8.0.tgz";
        sha512 = "x/rqGMdzj+fWZvCOYForTghzbtqPDZ5gPwaoNGHdgDfF2QA/XZbCBp4Moo5scrkAMPhB7z26XM/AaHuIJdgauA==";
      };
    }
    {
      name = "_babel_runtime___runtime_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_runtime___runtime_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.21.5.tgz";
        sha512 = "8jI69toZqqcsnqGGqwGS4Qb1VwLOEp4hz+CXPywcvjs60u3B4Pom/U/7rm4W8tMOYEB+E9wgD0mW1l3r8qlI9Q==";
      };
    }
    {
      name = "_babel_template___template_7.20.7.tgz";
      path = fetchurl {
        name = "_babel_template___template_7.20.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/template/-/template-7.20.7.tgz";
        sha512 = "8SegXApWe6VoNw0r9JHpSteLKTpTiLZ4rMlGIm9JQ18KiCtyQiAMEazujAHrUS5flrcqYZa75ukev3P6QmUwUw==";
      };
    }
    {
      name = "_babel_traverse___traverse_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_traverse___traverse_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.21.5.tgz";
        sha512 = "AhQoI3YjWi6u/y/ntv7k48mcrCXmus0t79J9qPNlk/lAsFlCiJ047RmbfMOawySTHtywXhbXgpx/8nXMYd+oFw==";
      };
    }
    {
      name = "_babel_types___types_7.21.5.tgz";
      path = fetchurl {
        name = "_babel_types___types_7.21.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/types/-/types-7.21.5.tgz";
        sha512 = "m4AfNvVF2mVC/F7fDEdH2El3HzUg9It/XsCxZiOTTA3m3qYfcSVSbTfM6Q9xG+hYDniZssYhlXKKUMD5m8tF4Q==";
      };
    }
    {
      name = "_csstools_selector_specificity___selector_specificity_2.2.0.tgz";
      path = fetchurl {
        name = "_csstools_selector_specificity___selector_specificity_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@csstools/selector-specificity/-/selector-specificity-2.2.0.tgz";
        sha512 = "+OJ9konv95ClSTOJCmMZqpd5+YGsB2S+x6w3E1oaM8UuR5j8nTNHYSz8c9BEPGDOCMQYIEEGlVPj/VY64iTbGw==";
      };
    }
    {
      name = "_discoveryjs_json_ext___json_ext_0.5.7.tgz";
      path = fetchurl {
        name = "_discoveryjs_json_ext___json_ext_0.5.7.tgz";
        url  = "https://registry.yarnpkg.com/@discoveryjs/json-ext/-/json-ext-0.5.7.tgz";
        sha512 = "dBVuXR082gk3jsFp7Rd/JI4kytwGHecnCoTtXFb7DB6CNHp4rg5k1bhg0nWdLGLnOV71lmDzGQaLMy8iPLY0pw==";
=======
        sha1 = "ef939d6e7f268827e1841638dc6ff95515e115d9";
      };
    }
    {
      name = "_babel_preset_react___preset_react_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_preset_react___preset_react_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/preset-react/-/preset-react-7.16.7.tgz";
        sha1 = "4c18150491edc69c183ff818f9f2aecbe5d93852";
      };
    }
    {
      name = "_babel_runtime_corejs3___runtime_corejs3_7.16.8.tgz";
      path = fetchurl {
        name = "_babel_runtime_corejs3___runtime_corejs3_7.16.8.tgz";
        url  = "https://registry.yarnpkg.com/@babel/runtime-corejs3/-/runtime-corejs3-7.16.8.tgz";
        sha1 = "ea533d96eda6fdc76b1812248e9fbd0c11d4a1a7";
      };
    }
    {
      name = "_babel_runtime___runtime_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_runtime___runtime_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.16.7.tgz";
        sha1 = "03ff99f64106588c9c403c6ecb8c3bafbbdff1fa";
      };
    }
    {
      name = "_babel_template___template_7.16.7.tgz";
      path = fetchurl {
        name = "_babel_template___template_7.16.7.tgz";
        url  = "https://registry.yarnpkg.com/@babel/template/-/template-7.16.7.tgz";
        sha1 = "8d126c8701fde4d66b264b3eba3d96f07666d155";
      };
    }
    {
      name = "_babel_traverse___traverse_7.16.10.tgz";
      path = fetchurl {
        name = "_babel_traverse___traverse_7.16.10.tgz";
        url  = "https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.16.10.tgz";
        sha1 = "448f940defbe95b5a8029975b051f75993e8239f";
      };
    }
    {
      name = "_babel_types___types_7.16.8.tgz";
      path = fetchurl {
        name = "_babel_types___types_7.16.8.tgz";
        url  = "https://registry.yarnpkg.com/@babel/types/-/types-7.16.8.tgz";
        sha1 = "0ba5da91dd71e0a4e7781a30f22770831062e3c1";
      };
    }
    {
      name = "_discoveryjs_json_ext___json_ext_0.5.6.tgz";
      path = fetchurl {
        name = "_discoveryjs_json_ext___json_ext_0.5.6.tgz";
        url  = "https://registry.yarnpkg.com/@discoveryjs/json-ext/-/json-ext-0.5.6.tgz";
        sha1 = "d5e0706cf8c6acd8c6032f8d54070af261bbbb2f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_eslint_eslintrc___eslintrc_0.4.3.tgz";
      path = fetchurl {
        name = "_eslint_eslintrc___eslintrc_0.4.3.tgz";
        url  = "https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-0.4.3.tgz";
<<<<<<< HEAD
        sha512 = "J6KFFz5QCYUJq3pf0mjEcCJVERbzv71PUIDczuh9JkwGEzced6CO5ADLHB1rbf/+oPBtoPfMYNOpGDzCANlbXw==";
      };
    }
    {
      name = "_headlessui_react___react_1.7.14.tgz";
      path = fetchurl {
        name = "_headlessui_react___react_1.7.14.tgz";
        url  = "https://registry.yarnpkg.com/@headlessui/react/-/react-1.7.14.tgz";
        sha512 = "znzdq9PG8rkwcu9oQ2FwIy0ZFtP9Z7ycS+BAqJ3R5EIqC/0bJGvhT7193rFf+45i9nnPsYvCQVW4V/bB9Xc+gA==";
      };
    }
    {
      name = "_heroicons_react___react_2.0.17.tgz";
      path = fetchurl {
        name = "_heroicons_react___react_2.0.17.tgz";
        url  = "https://registry.yarnpkg.com/@heroicons/react/-/react-2.0.17.tgz";
        sha512 = "90GMZktkA53YbNzHp6asVEDevUQCMtxWH+2UK2S8OpnLEu7qckTJPhNxNQG52xIR1WFTwFqtH6bt7a60ZNcLLA==";
=======
        sha1 = "9e42981ef035beb3dd49add17acb96e8ff6f394c";
      };
    }
    {
      name = "_headlessui_react___react_1.4.3.tgz";
      path = fetchurl {
        name = "_headlessui_react___react_1.4.3.tgz";
        url  = "https://registry.yarnpkg.com/@headlessui/react/-/react-1.4.3.tgz";
        sha1 = "f77c6bb5cb4a614a5d730fb880cab502d48abf37";
      };
    }
    {
      name = "_heroicons_react___react_1.0.5.tgz";
      path = fetchurl {
        name = "_heroicons_react___react_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/@heroicons/react/-/react-1.0.5.tgz";
        sha1 = "2fe4df9d33eb6ce6d5178a0f862e97b61c01e27d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_humanwhocodes_config_array___config_array_0.5.0.tgz";
      path = fetchurl {
        name = "_humanwhocodes_config_array___config_array_0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/@humanwhocodes/config-array/-/config-array-0.5.0.tgz";
<<<<<<< HEAD
        sha512 = "FagtKFz74XrTl7y6HCzQpwDfXP0yhxe9lHLD1UZxjvZIcbyRz8zTFF/yYNfSfzU414eDwZ1SrO0Qvtyf+wFMQg==";
=======
        sha1 = "1407967d4c6eecd7388f83acf1eaf4d0c6e58ef9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_humanwhocodes_object_schema___object_schema_1.2.1.tgz";
      path = fetchurl {
        name = "_humanwhocodes_object_schema___object_schema_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/@humanwhocodes/object-schema/-/object-schema-1.2.1.tgz";
<<<<<<< HEAD
        sha512 = "ZnQMnLV4e7hDlUvw8H+U8ASL02SS2Gn6+9Ac3wGGLIe7+je2AeAOxPY+izIPJDfFDb7eDjev0Us8MO1iFRN8hA==";
      };
    }
    {
      name = "_jridgewell_gen_mapping___gen_mapping_0.3.3.tgz";
      path = fetchurl {
        name = "_jridgewell_gen_mapping___gen_mapping_0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/@jridgewell/gen-mapping/-/gen-mapping-0.3.3.tgz";
        sha512 = "HLhSWOLRi875zjjMG/r+Nv0oCW8umGb0BgEhyX3dDX3egwZtB8PqLnjz3yedt8R5StBrzcg4aBpnh8UA9D1BoQ==";
      };
    }
    {
      name = "_jridgewell_resolve_uri___resolve_uri_3.1.0.tgz";
      path = fetchurl {
        name = "_jridgewell_resolve_uri___resolve_uri_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/@jridgewell/resolve-uri/-/resolve-uri-3.1.0.tgz";
        sha512 = "F2msla3tad+Mfht5cJq7LSXcdudKTWCVYUgw6pLFOOHSTtZlj6SWNYAp+AhuqLmWdBO2X5hPrLcu8cVP8fy28w==";
      };
    }
    {
      name = "_jridgewell_set_array___set_array_1.1.2.tgz";
      path = fetchurl {
        name = "_jridgewell_set_array___set_array_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/@jridgewell/set-array/-/set-array-1.1.2.tgz";
        sha512 = "xnkseuNADM0gt2bs+BvhO0p78Mk762YnZdsuzFV018NoG1Sj1SCQvpSqa7XUaTam5vAGasABV9qXASMKnFMwMw==";
      };
    }
    {
      name = "_jridgewell_source_map___source_map_0.3.3.tgz";
      path = fetchurl {
        name = "_jridgewell_source_map___source_map_0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/@jridgewell/source-map/-/source-map-0.3.3.tgz";
        sha512 = "b+fsZXeLYi9fEULmfBrhxn4IrPlINf8fiNarzTof004v3lFdntdwa9PF7vFJqm3mg7s+ScJMxXaE3Acp1irZcg==";
      };
    }
    {
      name = "_jridgewell_sourcemap_codec___sourcemap_codec_1.4.14.tgz";
      path = fetchurl {
        name = "_jridgewell_sourcemap_codec___sourcemap_codec_1.4.14.tgz";
        url  = "https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz";
        sha512 = "XPSJHWmi394fuUuzDnGz1wiKqWfo1yXecHQMRf2l6hztTO+nPru658AyDngaBe7isIxEkRsPR3FZh+s7iVa4Uw==";
      };
    }
    {
      name = "_jridgewell_sourcemap_codec___sourcemap_codec_1.4.15.tgz";
      path = fetchurl {
        name = "_jridgewell_sourcemap_codec___sourcemap_codec_1.4.15.tgz";
        url  = "https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz";
        sha512 = "eF2rxCRulEKXHTRiDrDy6erMYWqNw4LPdQ8UQA4huuxaQsVeRPFl2oM8oDGxMFhJUWZf9McpLtJasDDZb/Bpeg==";
      };
    }
    {
      name = "_jridgewell_trace_mapping___trace_mapping_0.3.18.tgz";
      path = fetchurl {
        name = "_jridgewell_trace_mapping___trace_mapping_0.3.18.tgz";
        url  = "https://registry.yarnpkg.com/@jridgewell/trace-mapping/-/trace-mapping-0.3.18.tgz";
        sha512 = "w+niJYzMHdd7USdiH2U6869nqhD2nbfZXND5Yp93qIbEmnDNk7PD48o+YchRVpzMU7M6jVCbenTR7PA1FLQ9pA==";
      };
    }
    {
      name = "_juggle_resize_observer___resize_observer_3.4.0.tgz";
      path = fetchurl {
        name = "_juggle_resize_observer___resize_observer_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/@juggle/resize-observer/-/resize-observer-3.4.0.tgz";
        sha512 = "dfLbk+PwWvFzSxwk3n5ySL0hfBog779o8h68wK/7/APo/7cgyWp5jcXockbxdk5kFRkbeXWm4Fbi9FrdN381sA==";
      };
    }
    {
      name = "_kunukn_react_collapse___react_collapse_2.2.10.tgz";
      path = fetchurl {
        name = "_kunukn_react_collapse___react_collapse_2.2.10.tgz";
        url  = "https://registry.yarnpkg.com/@kunukn/react-collapse/-/react-collapse-2.2.10.tgz";
        sha512 = "1qCB9+UDw9tLolhFfO4ywfATylV0cflmkLYRGGV8mQhtAzYDPyDU0HUog98IdlmZBowcdfmxFTbtoD99Eyq5SA==";
=======
        sha1 = "b520529ec21d8e5945a1851dfd1c32e94e39ff45";
      };
    }
    {
      name = "_juggle_resize_observer___resize_observer_3.3.1.tgz";
      path = fetchurl {
        name = "_juggle_resize_observer___resize_observer_3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/@juggle/resize-observer/-/resize-observer-3.3.1.tgz";
        sha1 = "b50a781709c81e10701004214340f25475a171a0";
      };
    }
    {
      name = "_kunukn_react_collapse___react_collapse_2.2.9.tgz";
      path = fetchurl {
        name = "_kunukn_react_collapse___react_collapse_2.2.9.tgz";
        url  = "https://registry.yarnpkg.com/@kunukn/react-collapse/-/react-collapse-2.2.9.tgz";
        sha1 = "89787666b25145d179b65c55fcd335af7fa8fb6d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_nodelib_fs.scandir___fs.scandir_2.1.5.tgz";
      path = fetchurl {
        name = "_nodelib_fs.scandir___fs.scandir_2.1.5.tgz";
        url  = "https://registry.yarnpkg.com/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz";
<<<<<<< HEAD
        sha512 = "vq24Bq3ym5HEQm2NKCr3yXDwjc7vTsEThRDnkp2DK9p1uqLR+DHurm/NOTo0KG7HYHU7eppKZj3MyqYuMBf62g==";
=======
        sha1 = "7619c2eb21b25483f6d167548b4cfd5a7488c3d5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_nodelib_fs.stat___fs.stat_2.0.5.tgz";
      path = fetchurl {
        name = "_nodelib_fs.stat___fs.stat_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz";
<<<<<<< HEAD
        sha512 = "RkhPPp2zrqDAQA/2jNhnztcPAlv64XdhIp7a7454A5ovI7Bukxgt7MX7udwAu3zg1DcpPU0rz3VV1SeaqvY4+A==";
=======
        sha1 = "5bd262af94e9d25bd1e71b05deed44876a222e8b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_nodelib_fs.walk___fs.walk_1.2.8.tgz";
      path = fetchurl {
        name = "_nodelib_fs.walk___fs.walk_1.2.8.tgz";
        url  = "https://registry.yarnpkg.com/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz";
<<<<<<< HEAD
        sha512 = "oGB+UxlgWcgQkgwo8GcEGwemoTFt3FIO9ababBmaGwXIoBKZ+GTy0pP185beGg7Llih/NSHSV2XAs1lnznocSg==";
=======
        sha1 = "e95737e8bb6746ddedf69c556953494f196fe69a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_polka_url___url_1.0.0_next.21.tgz";
      path = fetchurl {
        name = "_polka_url___url_1.0.0_next.21.tgz";
        url  = "https://registry.yarnpkg.com/@polka/url/-/url-1.0.0-next.21.tgz";
<<<<<<< HEAD
        sha512 = "a5Sab1C4/icpTZVzZc5Ghpz88yQtGOyNqYXcZgOssB2uuAr+wF/MvN6bgtW32q7HHrvBki+BsZ0OuNv6EV3K9g==";
      };
    }
    {
      name = "_popperjs_core___core_2.11.7.tgz";
      path = fetchurl {
        name = "_popperjs_core___core_2.11.7.tgz";
        url  = "https://registry.yarnpkg.com/@popperjs/core/-/core-2.11.7.tgz";
        sha512 = "Cr4OjIkipTtcXKjAsm8agyleBuDHvxzeBoa1v543lbv1YaIwQjESsVcmjiWiPEbC1FIeHOG/Op9kdCmAmiS3Kw==";
=======
        sha1 = "5de5a2385a35309427f6011992b544514d559aa1";
      };
    }
    {
      name = "_stylelint_postcss_css_in_js___postcss_css_in_js_0.37.2.tgz";
      path = fetchurl {
        name = "_stylelint_postcss_css_in_js___postcss_css_in_js_0.37.2.tgz";
        url  = "https://registry.yarnpkg.com/@stylelint/postcss-css-in-js/-/postcss-css-in-js-0.37.2.tgz";
        sha1 = "7e5a84ad181f4234a2480803422a47b8749af3d2";
      };
    }
    {
      name = "_stylelint_postcss_markdown___postcss_markdown_0.36.2.tgz";
      path = fetchurl {
        name = "_stylelint_postcss_markdown___postcss_markdown_0.36.2.tgz";
        url  = "https://registry.yarnpkg.com/@stylelint/postcss-markdown/-/postcss-markdown-0.36.2.tgz";
        sha1 = "0a540c4692f8dcdfc13c8e352c17e7bfee2bb391";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_tailwindcss_aspect_ratio___aspect_ratio_0.2.2.tgz";
      path = fetchurl {
        name = "_tailwindcss_aspect_ratio___aspect_ratio_0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/@tailwindcss/aspect-ratio/-/aspect-ratio-0.2.2.tgz";
<<<<<<< HEAD
        sha512 = "yjvYH1qKQapYUVz0rCRAQ29KlKuiDsWJF/0d24lpTPWtTKBimcKWHiAMjZOILbnRd25PogILsbOyFFVOjFd6Ow==";
=======
        sha1 = "68819ac65bc91c1833fec1f4af5cc3bfb3f25922";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_tailwindcss_forms___forms_0.3.4.tgz";
      path = fetchurl {
        name = "_tailwindcss_forms___forms_0.3.4.tgz";
        url  = "https://registry.yarnpkg.com/@tailwindcss/forms/-/forms-0.3.4.tgz";
<<<<<<< HEAD
        sha512 = "vlAoBifNJUkagB+PAdW4aHMe4pKmSLroH398UPgIogBFc91D2VlHUxe4pjxQhiJl0Nfw53sHSJSQBSTQBZP3vA==";
=======
        sha1 = "e4939dc16450eccf4fd2029770096f38cbb556d4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_tailwindcss_typography___typography_0.4.1.tgz";
      path = fetchurl {
        name = "_tailwindcss_typography___typography_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/@tailwindcss/typography/-/typography-0.4.1.tgz";
<<<<<<< HEAD
        sha512 = "ovPPLUhs7zAIJfr0y1dbGlyCuPhpuv/jpBoFgqAc658DWGGrOBWBMpAWLw2KlzbNeVk4YBJMzue1ekvIbdw6XA==";
=======
        sha1 = "51ddbceea6a0ee9902c649dbe58871c81a831212";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_trysound_sax___sax_0.2.0.tgz";
      path = fetchurl {
        name = "_trysound_sax___sax_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@trysound/sax/-/sax-0.2.0.tgz";
<<<<<<< HEAD
        sha512 = "L7z9BgrNEcYyUYtF+HaEfiS5ebkh9jXqbszz7pC0hRBPaatV0XjSD3+eHrpqFemQfgwiFF0QPIarnIihIDn7OA==";
=======
        sha1 = "cccaab758af56761eb7bf37af6f03f326dd798ad";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_types_d3___d3_3.5.38.tgz";
      path = fetchurl {
        name = "_types_d3___d3_3.5.38.tgz";
        url  = "https://registry.yarnpkg.com/@types/d3/-/d3-3.5.38.tgz";
<<<<<<< HEAD
        sha512 = "O/gRkjWULp3xVX8K85V0H3tsSGole0WYt77KVpGZO2xTGLuVFuvE6JIsIli3fvFHCYBhGFn/8OHEEyMYF+QehA==";
      };
    }
    {
      name = "_types_eslint_scope___eslint_scope_3.7.4.tgz";
      path = fetchurl {
        name = "_types_eslint_scope___eslint_scope_3.7.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/eslint-scope/-/eslint-scope-3.7.4.tgz";
        sha512 = "9K4zoImiZc3HlIp6AVUDE4CWYx22a+lhSZMYNpbjW04+YF0KWj4pJXnEMjdnFTiQibFFmElcsasJXDbdI/EPhA==";
      };
    }
    {
      name = "_types_eslint___eslint_8.37.0.tgz";
      path = fetchurl {
        name = "_types_eslint___eslint_8.37.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/eslint/-/eslint-8.37.0.tgz";
        sha512 = "Piet7dG2JBuDIfohBngQ3rCt7MgO9xCO4xIMKxBThCq5PNRB91IjlJ10eJVwfoNtvTErmxLzwBZ7rHZtbOMmFQ==";
      };
    }
    {
      name = "_types_estree___estree_1.0.1.tgz";
      path = fetchurl {
        name = "_types_estree___estree_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/estree/-/estree-1.0.1.tgz";
        sha512 = "LG4opVs2ANWZ1TJoKc937iMmNstM/d0ae1vNbnBvBhqCSezgVUOzcLCqbI5elV8Vy6WKwKjaqR+zO9VKirBBCA==";
=======
        sha1 = "76f8f2e9159ae562965b2fa0e6fbee1aa643a1bc";
      };
    }
    {
      name = "_types_eslint_scope___eslint_scope_3.7.3.tgz";
      path = fetchurl {
        name = "_types_eslint_scope___eslint_scope_3.7.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/eslint-scope/-/eslint-scope-3.7.3.tgz";
        sha1 = "125b88504b61e3c8bc6f870882003253005c3224";
      };
    }
    {
      name = "_types_eslint___eslint_8.4.1.tgz";
      path = fetchurl {
        name = "_types_eslint___eslint_8.4.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/eslint/-/eslint-8.4.1.tgz";
        sha1 = "c48251553e8759db9e656de3efc846954ac32304";
      };
    }
    {
      name = "_types_estree___estree_0.0.50.tgz";
      path = fetchurl {
        name = "_types_estree___estree_0.0.50.tgz";
        url  = "https://registry.yarnpkg.com/@types/estree/-/estree-0.0.50.tgz";
        sha1 = "1e0caa9364d3fccd2931c3ed96fdbeaa5d4cca83";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_types_estree___estree_0.0.47.tgz";
      path = fetchurl {
        name = "_types_estree___estree_0.0.47.tgz";
        url  = "https://registry.yarnpkg.com/@types/estree/-/estree-0.0.47.tgz";
<<<<<<< HEAD
        sha512 = "c5ciR06jK8u9BstrmJyO97m+klJrrhCf9u3rLu3DEAJBirxRqSCvDQoYKmxuYwQI5SZChAWu+tq9oVlGRuzPAg==";
      };
    }
    {
      name = "_types_json_schema___json_schema_7.0.11.tgz";
      path = fetchurl {
        name = "_types_json_schema___json_schema_7.0.11.tgz";
        url  = "https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.11.tgz";
        sha512 = "wOuvG1SN4Us4rez+tylwwwCV1psiNVOkJeM3AUWUNWg/jDQY2+HE/444y5gc+jBmRqASOm2Oeh5c1axHobwRKQ==";
=======
        sha1 = "d7a51db20f0650efec24cd04994f523d93172ed4";
      };
    }
    {
      name = "_types_json_schema___json_schema_7.0.9.tgz";
      path = fetchurl {
        name = "_types_json_schema___json_schema_7.0.9.tgz";
        url  = "https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.9.tgz";
        sha1 = "97edc9037ea0c38585320b28964dde3b39e4660d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_types_json5___json5_0.0.29.tgz";
      path = fetchurl {
        name = "_types_json5___json5_0.0.29.tgz";
        url  = "https://registry.yarnpkg.com/@types/json5/-/json5-0.0.29.tgz";
<<<<<<< HEAD
        sha512 = "dRLjCWHYg4oaA77cxO64oO+7JwCwnIzkZPdrrC71jQmQtlhM556pwKo5bUzqvZndkVbeFLIIi+9TC40JNF5hNQ==";
      };
    }
    {
      name = "_types_lodash___lodash_4.14.194.tgz";
      path = fetchurl {
        name = "_types_lodash___lodash_4.14.194.tgz";
        url  = "https://registry.yarnpkg.com/@types/lodash/-/lodash-4.14.194.tgz";
        sha512 = "r22s9tAS7imvBt2lyHC9B8AGwWnXaYb1tY09oyLkXDs4vArpYJzw09nj8MLx5VfciBPGIb+ZwG0ssYnEPJxn/g==";
=======
        sha1 = "ee28707ae94e11d2b827bcbe5270bcea7f3e71ee";
      };
    }
    {
      name = "_types_mdast___mdast_3.0.10.tgz";
      path = fetchurl {
        name = "_types_mdast___mdast_3.0.10.tgz";
        url  = "https://registry.yarnpkg.com/@types/mdast/-/mdast-3.0.10.tgz";
        sha1 = "4724244a82a4598884cbbe9bcfd73dff927ee8af";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_types_minimist___minimist_1.2.2.tgz";
      path = fetchurl {
        name = "_types_minimist___minimist_1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/minimist/-/minimist-1.2.2.tgz";
<<<<<<< HEAD
        sha512 = "jhuKLIRrhvCPLqwPcx6INqmKeiA5EWrsCOPhrlFSrbrmU4ZMPjj5Ul/oLCMDO98XRUIwVm78xICz4EPCektzeQ==";
      };
    }
    {
      name = "_types_node___node_18.16.3.tgz";
      path = fetchurl {
        name = "_types_node___node_18.16.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-18.16.3.tgz";
        sha512 = "OPs5WnnT1xkCBiuQrZA4+YAV4HEJejmHneyraIaxsbev5yCEr6KMwINNFP9wQeFIw8FWcoTqF3vQsa5CDaI+8Q==";
=======
        sha1 = "ee771e2ba4b3dc5b372935d549fd9617bf345b8c";
      };
    }
    {
      name = "_types_node___node_17.0.13.tgz";
      path = fetchurl {
        name = "_types_node___node_17.0.13.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-17.0.13.tgz";
        sha1 = "5ed7ed7c662948335fcad6c412bb42d99ea754e3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_types_normalize_package_data___normalize_package_data_2.4.1.tgz";
      path = fetchurl {
        name = "_types_normalize_package_data___normalize_package_data_2.4.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/normalize-package-data/-/normalize-package-data-2.4.1.tgz";
<<<<<<< HEAD
        sha512 = "Gj7cI7z+98M282Tqmp2K5EIsoouUEzbBJhQQzDE3jSIRk6r9gsz0oUokqIUR4u1R3dMHo0pDHM7sNOHyhulypw==";
=======
        sha1 = "d3357479a0fdfdd5907fe67e17e0a85c906e1301";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_types_parse_json___parse_json_4.0.0.tgz";
      path = fetchurl {
        name = "_types_parse_json___parse_json_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/parse-json/-/parse-json-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "//oorEZjL6sbPcKUaCdIGlIUeH26mgzimjBB77G6XRgnDl/L5wOnpyBGRe/Mmf5CVW3PwEBE1NjiMZ/ssFh4wA==";
=======
        sha1 = "2f8bb441434d163b35fb8ffdccd7138927ffb8c0";
      };
    }
    {
      name = "_types_unist___unist_2.0.6.tgz";
      path = fetchurl {
        name = "_types_unist___unist_2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/@types/unist/-/unist-2.0.6.tgz";
        sha1 = "250a7b16c3b91f672a24552ec64678eeb1d3a08d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_ast___ast_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_ast___ast_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/ast/-/ast-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "kX2W49LWsbthrmIRMbQZuQDhGtjyqXfEmmHyEi4XWnSZtPmxY0+3anPIzsnRb45VH/J55zlOfWvZuY47aJZTJg==";
=======
        sha1 = "a5aa679efdc9e51707a4207139da57920555961f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_floating_point_hex_parser___floating_point_hex_parser_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_floating_point_hex_parser___floating_point_hex_parser_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "Q/aVYs/VnPDVYvsCBL/gSgwmfjeCb4LW8+TMrO3cSzJImgv8lxxEPM2JA5jMrivE7LSz3V+PFqtMbls3m1exDA==";
=======
        sha1 = "34d62052f453cd43101d72eab4966a022587947c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_helper_api_error___helper_api_error_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_helper_api_error___helper_api_error_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "baT/va95eXiXb2QflSx95QGT5ClzWpGaa8L7JnJbgzoYeaA27FCvuBXU758l+KXWRndEmUXjP0Q5fibhavIn8w==";
=======
        sha1 = "aaea8fb3b923f4aaa9b512ff541b013ffb68d2d4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_helper_buffer___helper_buffer_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_helper_buffer___helper_buffer_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-buffer/-/helper-buffer-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "u9HPBEl4DS+vA8qLQdEQ6N/eJQ7gT7aNvMIo8AAWvAl/xMrcOSiI2M0MAnMCy3jIFke7bEee/JwdX1nUpCtdyA==";
=======
        sha1 = "d026c25d175e388a7dbda9694e91e743cbe9b642";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_helper_numbers___helper_numbers_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_helper_numbers___helper_numbers_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "DhRQKelIj01s5IgdsOJMKLppI+4zpmcMQ3XboFPLwCpSNH6Hqo1ritgHgD0nqHeSYqofA6aBN/NmXuGjM1jEfQ==";
=======
        sha1 = "7ab04172d54e312cc6ea4286d7d9fa27c88cd4f9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_helper_wasm_bytecode___helper_wasm_bytecode_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_helper_wasm_bytecode___helper_wasm_bytecode_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "MbmhvxXExm542tWREgSFnOVo07fDpsBJg3sIl6fSp9xuu75eGz5lz31q7wTLffwL3Za7XNRCMZy210+tnsUSEA==";
=======
        sha1 = "85fdcda4129902fe86f81abf7e7236953ec5a4e1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_helper_wasm_section___helper_wasm_section_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_helper_wasm_section___helper_wasm_section_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "3Eb88hcbfY/FCukrg6i3EH8H2UsD7x8Vy47iVJrP967A9JGqgBVL9aH71SETPx1JrGsOUVLo0c7vMCN22ytJew==";
=======
        sha1 = "9ce2cc89300262509c801b4af113d1ca25c1a75b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_ieee754___ieee754_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_ieee754___ieee754_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/ieee754/-/ieee754-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "KXzOqpcYQwAfeQ6WbF6HXo+0udBNmw0iXDmEK5sFlmQdmND+tr773Ti8/5T/M6Tl/413ArSJErATd8In3B+WBA==";
=======
        sha1 = "46975d583f9828f5d094ac210e219441c4e6f5cf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_leb128___leb128_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_leb128___leb128_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/leb128/-/leb128-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "aqbsHa1mSQAbeeNcl38un6qVY++hh8OpCOzxhixSYgbRfNWcxJNJQwe2rezK9XEcssJbbWIkblaJRwGMS9zp+g==";
=======
        sha1 = "f7353de1df38aa201cba9fb88b43f41f75ff403b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_utf8___utf8_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_utf8___utf8_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/utf8/-/utf8-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "A/lclGxH6SpSLSyFowMzO/+aDEPU4hvEiooCMXQPcQFPPJaYcPQNKGOCLUySJsYJ4trbpr+Fs08n4jelkVTGVw==";
=======
        sha1 = "86e48f959cf49e0e5091f069a709b862f5a2cadf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_wasm_edit___wasm_edit_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_wasm_edit___wasm_edit_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wasm-edit/-/wasm-edit-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "JHQ0damXy0G6J9ucyKVXO2j08JVJ2ntkdJlq1UTiUrIgfGMmA7Ik5VdC/L8hBK46kVJgujkBIoMtT8yVr+yVOQ==";
=======
        sha1 = "ee4a5c9f677046a210542ae63897094c2027cb78";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_wasm_gen___wasm_gen_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_wasm_gen___wasm_gen_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wasm-gen/-/wasm-gen-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "BEUv1aj0WptCZ9kIS30th5ILASUnAPEvE3tVMTrItnZRT9tXCLW2LEXT8ezLw59rqPP9klh9LPmpU+WmRQmCPQ==";
=======
        sha1 = "3cdb35e70082d42a35166988dda64f24ceb97abe";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_wasm_opt___wasm_opt_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_wasm_opt___wasm_opt_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wasm-opt/-/wasm-opt-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "tHUSP5F4ywyh3hZ0+fDQuWxKx3mJiPeFufg+9gwTpYp324mPCQgnuVKwzLTZVqj0duRDovnPaZqDwoyhIO8kYg==";
=======
        sha1 = "1638ae188137f4bb031f568a413cd24d32f92978";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_wasm_parser___wasm_parser_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_wasm_parser___wasm_parser_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wasm-parser/-/wasm-parser-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "6L285Sgu9gphrcpDXINvm0M9BskznnzJTE7gYkjDbxET28shDqp27wpruyx3C2S/dvEwiigBwLA1cz7lNUi0kw==";
=======
        sha1 = "3e680b8830d5b13d1ec86cc42f38f3d4a7700754";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_webassemblyjs_wast_printer___wast_printer_1.11.0.tgz";
      path = fetchurl {
        name = "_webassemblyjs_wast_printer___wast_printer_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/@webassemblyjs/wast-printer/-/wast-printer-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "Fg5OX46pRdTgB7rKIUojkh9vXaVN6sGYCnEiJN1GYkb0RPwShZXp6KTDqmoMdQPKhcroOXh3fEzmkWmCYaKYhQ==";
      };
    }
    {
      name = "_webpack_cli_configtest___configtest_1.2.0.tgz";
      path = fetchurl {
        name = "_webpack_cli_configtest___configtest_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@webpack-cli/configtest/-/configtest-1.2.0.tgz";
        sha512 = "4FB8Tj6xyVkyqjj1OaTqCjXYULB9FMkqQ8yGrZjRDrYh0nOE+7Lhs45WioWQQMV+ceFlE368Ukhe6xdvJM9Egg==";
      };
    }
    {
      name = "_webpack_cli_info___info_1.5.0.tgz";
      path = fetchurl {
        name = "_webpack_cli_info___info_1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/@webpack-cli/info/-/info-1.5.0.tgz";
        sha512 = "e8tSXZpw2hPl2uMJY6fsMswaok5FdlGNRTktvFk2sD8RjH0hE2+XistawJx1vmKteh4NmGmNUrp+Tb2w+udPcQ==";
      };
    }
    {
      name = "_webpack_cli_serve___serve_1.7.0.tgz";
      path = fetchurl {
        name = "_webpack_cli_serve___serve_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/@webpack-cli/serve/-/serve-1.7.0.tgz";
        sha512 = "oxnCNGj88fL+xzV+dacXs44HcDwf1ovs3AuEzvP7mqXw7fQntqIhQ1BRmynh4qEKQSSSRSWVyXRjmTbZIX9V2Q==";
=======
        sha1 = "680d1f6a5365d6d401974a8e949e05474e1fab7e";
      };
    }
    {
      name = "_webpack_cli_configtest___configtest_1.1.1.tgz";
      path = fetchurl {
        name = "_webpack_cli_configtest___configtest_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/@webpack-cli/configtest/-/configtest-1.1.1.tgz";
        sha1 = "9f53b1b7946a6efc2a749095a4f450e2932e8356";
      };
    }
    {
      name = "_webpack_cli_info___info_1.4.1.tgz";
      path = fetchurl {
        name = "_webpack_cli_info___info_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/@webpack-cli/info/-/info-1.4.1.tgz";
        sha1 = "2360ea1710cbbb97ff156a3f0f24556e0fc1ebea";
      };
    }
    {
      name = "_webpack_cli_serve___serve_1.6.1.tgz";
      path = fetchurl {
        name = "_webpack_cli_serve___serve_1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/@webpack-cli/serve/-/serve-1.6.1.tgz";
        sha1 = "0de2875ac31b46b6c5bb1ae0a7d7f0ba5678dffe";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_xtuc_ieee754___ieee754_1.2.0.tgz";
      path = fetchurl {
        name = "_xtuc_ieee754___ieee754_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@xtuc/ieee754/-/ieee754-1.2.0.tgz";
<<<<<<< HEAD
        sha512 = "DX8nKgqcGwsc0eJSqYt5lwP4DH5FlHnmuWWBRy7X0NcaGR0ZtuyeESgMwTYVEtxmsNGY+qit4QYT/MIYTOTPeA==";
=======
        sha1 = "eef014a3145ae477a1cbc00cd1e552336dceb790";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "_xtuc_long___long_4.2.2.tgz";
      path = fetchurl {
        name = "_xtuc_long___long_4.2.2.tgz";
        url  = "https://registry.yarnpkg.com/@xtuc/long/-/long-4.2.2.tgz";
<<<<<<< HEAD
        sha512 = "NuHqBY1PB/D8xU6s/thBgOAiAP7HOYDQ32+BFZILJ8ivkUkAHQnWfn6WhL79Owj1qmUnoN/YPhktdIoucipkAQ==";
      };
    }
    {
      name = "abortcontroller_polyfill___abortcontroller_polyfill_1.7.5.tgz";
      path = fetchurl {
        name = "abortcontroller_polyfill___abortcontroller_polyfill_1.7.5.tgz";
        url  = "https://registry.yarnpkg.com/abortcontroller-polyfill/-/abortcontroller-polyfill-1.7.5.tgz";
        sha512 = "JMJ5soJWP18htbbxJjG7bG6yuI6pRhgJ0scHHTfkUjf6wjP912xZWvM+A4sJK3gqd9E8fcPbDnOefbA9Th/FIQ==";
=======
        sha1 = "d291c6a4e97989b5c61d9acf396ae4fe133a718d";
      };
    }
    {
      name = "abortcontroller_polyfill___abortcontroller_polyfill_1.7.3.tgz";
      path = fetchurl {
        name = "abortcontroller_polyfill___abortcontroller_polyfill_1.7.3.tgz";
        url  = "https://registry.yarnpkg.com/abortcontroller-polyfill/-/abortcontroller-polyfill-1.7.3.tgz";
        sha1 = "1b5b487bd6436b5b764fd52a612509702c3144b5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "acorn_jsx___acorn_jsx_5.3.2.tgz";
      path = fetchurl {
        name = "acorn_jsx___acorn_jsx_5.3.2.tgz";
        url  = "https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.2.tgz";
<<<<<<< HEAD
        sha512 = "rq9s+JNhf0IChjtDXxllJ7g41oZk5SlXtp0LHwyA5cejwn7vKmKp4pPri6YEePv2PU65sAsegbXtIinmDFDXgQ==";
=======
        sha1 = "7ed5bb55908b3b2f1bc55c6af1653bada7f07937";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "acorn_node___acorn_node_1.8.2.tgz";
      path = fetchurl {
        name = "acorn_node___acorn_node_1.8.2.tgz";
        url  = "https://registry.yarnpkg.com/acorn-node/-/acorn-node-1.8.2.tgz";
<<<<<<< HEAD
        sha512 = "8mt+fslDufLYntIoPAaIMUe/lrbrehIiwmR3t2k9LljIzoigEPF27eLk2hy8zSGzmR/ogr7zbRKINMo1u0yh5A==";
=======
        sha1 = "114c95d64539e53dede23de8b9d96df7c7ae2af8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "acorn_walk___acorn_walk_7.2.0.tgz";
      path = fetchurl {
        name = "acorn_walk___acorn_walk_7.2.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn-walk/-/acorn-walk-7.2.0.tgz";
<<<<<<< HEAD
        sha512 = "OPdCF6GsMIP+Az+aWfAAOEt2/+iVDKE7oy6lJ098aoe59oAmK76qV6Gw60SbZ8jHuG2wH058GF4pLFbYamYrVA==";
=======
        sha1 = "0de889a601203909b0fbe07b8938dc21d2e967bc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "acorn_walk___acorn_walk_8.2.0.tgz";
      path = fetchurl {
        name = "acorn_walk___acorn_walk_8.2.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn-walk/-/acorn-walk-8.2.0.tgz";
<<<<<<< HEAD
        sha512 = "k+iyHEuPgSw6SbuDpGQM+06HQUa04DZ3o+F6CSzXMvvI5KMvnaEqXe+YVe555R9nn6GPt404fos4wcgpw12SDA==";
=======
        sha1 = "741210f2e2426454508853a2f44d0ab83b7f69c1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "acorn___acorn_7.4.1.tgz";
      path = fetchurl {
        name = "acorn___acorn_7.4.1.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-7.4.1.tgz";
<<<<<<< HEAD
        sha512 = "nQyp0o1/mNdbTO1PO6kHkwSrmgZ0MT/jCCpNiwbUjGoRN4dlBhqJtoQuCnEOKzgTVwg0ZWiCoQy6SxMebQVh8A==";
      };
    }
    {
      name = "acorn___acorn_8.8.2.tgz";
      path = fetchurl {
        name = "acorn___acorn_8.8.2.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-8.8.2.tgz";
        sha512 = "xjIYgE8HBrkpd/sJqOGNspf8uHG+NOHGOw6a/Urj8taM2EXfdNAH2oFcPeIFfsv3+kz/mJrS5VuMqbNLjCa2vw==";
=======
        sha1 = "feaed255973d2e77555b83dbc08851a6c63520fa";
      };
    }
    {
      name = "acorn___acorn_8.7.0.tgz";
      path = fetchurl {
        name = "acorn___acorn_8.7.0.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-8.7.0.tgz";
        sha1 = "90951fde0f8f09df93549481e5fc141445b791cf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ajv_formats___ajv_formats_2.1.1.tgz";
      path = fetchurl {
        name = "ajv_formats___ajv_formats_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ajv-formats/-/ajv-formats-2.1.1.tgz";
<<<<<<< HEAD
        sha512 = "Wx0Kx52hxE7C18hkMEggYlEifqWZtYaRgouJor+WMdPnQyEK13vgEWyVNup7SoeeoLMsr4kf5h6dOW11I15MUA==";
=======
        sha1 = "6e669400659eb74973bbf2e33327180a0996b520";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ajv_keywords___ajv_keywords_3.5.2.tgz";
      path = fetchurl {
        name = "ajv_keywords___ajv_keywords_3.5.2.tgz";
        url  = "https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.5.2.tgz";
<<<<<<< HEAD
        sha512 = "5p6WTN0DdTGVQk6VjcEju19IgaHudalcfabD7yhDGeA6bcQnmL+CpveLJq/3hvfwd1aof6L386Ougkx6RfyMIQ==";
=======
        sha1 = "31f29da5ab6e00d1c2d329acf7b5929614d5014d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ajv_keywords___ajv_keywords_5.1.0.tgz";
      path = fetchurl {
        name = "ajv_keywords___ajv_keywords_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-5.1.0.tgz";
<<<<<<< HEAD
        sha512 = "YCS/JNFAUyr5vAuhk1DWm1CBxRHW9LbJ2ozWeemrIqpbsqKjHVxYPyi5GC0rjZIT5JxJ3virVTS8wk4i/Z+krw==";
=======
        sha1 = "69d4d385a4733cdbeab44964a1170a88f87f0e16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ajv___ajv_6.12.6.tgz";
      path = fetchurl {
        name = "ajv___ajv_6.12.6.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz";
<<<<<<< HEAD
        sha512 = "j3fVLgvTo527anyYyJOGTYJbG+vnnQYvE0m5mmkc1TK+nxAppkCLMIL0aZ4dblVCNoGShhm+kzE4ZUykBoMg4g==";
      };
    }
    {
      name = "ajv___ajv_8.12.0.tgz";
      path = fetchurl {
        name = "ajv___ajv_8.12.0.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-8.12.0.tgz";
        sha512 = "sRu1kpcO9yLtYxBKvqfTeh9KzZEwO3STyX1HT+4CaDzC6HpTGYhIhPIzj9XuKU7KYDwnaeh5hcOwjy1QuJzBPA==";
=======
        sha1 = "baf5a62e802b07d977034586f8c3baf5adf26df4";
      };
    }
    {
      name = "ajv___ajv_8.9.0.tgz";
      path = fetchurl {
        name = "ajv___ajv_8.9.0.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-8.9.0.tgz";
        sha1 = "738019146638824dea25edcf299dcba1b0e7eb18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "alpinejs___alpinejs_2.8.2.tgz";
      path = fetchurl {
        name = "alpinejs___alpinejs_2.8.2.tgz";
        url  = "https://registry.yarnpkg.com/alpinejs/-/alpinejs-2.8.2.tgz";
<<<<<<< HEAD
        sha512 = "5yOUtckn4CBp0qsHpo2qgjZyZit84uXvHbB7NJ27sn4FA6UlFl2i9PGUAdTXkcbFvvxDJBM+zpOD8RuNYFvQAw==";
      };
    }
    {
      name = "ansi_colors___ansi_colors_4.1.3.tgz";
      path = fetchurl {
        name = "ansi_colors___ansi_colors_4.1.3.tgz";
        url  = "https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.3.tgz";
        sha512 = "/6w/C21Pm1A7aZitlI5Ni/2J6FFQN8i1Cvz3kHABAAbw93v/NlvKdVOqz7CCWz/3iv/JplRSEEZ83XION15ovw==";
=======
        sha1 = "b14ec21ae3cd78dcee4aed0a78ed0f01b676dac4";
      };
    }
    {
      name = "ansi_colors___ansi_colors_4.1.1.tgz";
      path = fetchurl {
        name = "ansi_colors___ansi_colors_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz";
        sha1 = "cbb9ae256bf750af1eab344f229aa27fe94ba348";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ansi_regex___ansi_regex_5.0.1.tgz";
      path = fetchurl {
        name = "ansi_regex___ansi_regex_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz";
<<<<<<< HEAD
        sha512 = "quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==";
=======
        sha1 = "082cb2c89c9fe8659a311a53bd6a4dc5301db304";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ansi_styles___ansi_styles_3.2.1.tgz";
      path = fetchurl {
        name = "ansi_styles___ansi_styles_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz";
<<<<<<< HEAD
        sha512 = "VT0ZI6kZRdTh8YyJw3SMbYm/u+NqfsAxEpWO0Pf9sq8/e94WxxOpPKx9FR1FlyCtOVDNOQ+8ntlqFxiRc+r5qA==";
=======
        sha1 = "41fbb20243e50b12be0f04b8dedbf07520ce841d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ansi_styles___ansi_styles_4.3.0.tgz";
      path = fetchurl {
        name = "ansi_styles___ansi_styles_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz";
<<<<<<< HEAD
        sha512 = "zbB9rCJAT1rbjiVDb2hqKFHNYLxgtk8NURxZ3IZwD3F6NtxbXZQCnnSi1Lkx+IDohdPlFp222wVALIheZJQSEg==";
      };
    }
    {
      name = "anymatch___anymatch_3.1.3.tgz";
      path = fetchurl {
        name = "anymatch___anymatch_3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.3.tgz";
        sha512 = "KMReFUr0B4t+D+OBkjR3KYqvocp2XaSzO55UcB6mgQMd3KbcE+mWTyvVV7D/zsdEbNnV6acZUutkiHQXvTr1Rw==";
      };
    }
    {
      name = "arg___arg_5.0.2.tgz";
      path = fetchurl {
        name = "arg___arg_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/arg/-/arg-5.0.2.tgz";
        sha512 = "PYjyFOLKQ9y57JvQ6QLo8dAgNqswh8M1RMJYdQduT6xbWSgK36P/Z/v+p888pM69jMMfS8Xd8F6I1kQ/I9HUGg==";
=======
        sha1 = "edd803628ae71c04c85ae7a0906edad34b648937";
      };
    }
    {
      name = "anymatch___anymatch_3.1.2.tgz";
      path = fetchurl {
        name = "anymatch___anymatch_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.2.tgz";
        sha1 = "c0557c096af32f106198f4f4e2a383537e378716";
      };
    }
    {
      name = "arg___arg_5.0.1.tgz";
      path = fetchurl {
        name = "arg___arg_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/arg/-/arg-5.0.1.tgz";
        sha1 = "eb0c9a8f77786cad2af8ff2b862899842d7b6adb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "argparse___argparse_1.0.10.tgz";
      path = fetchurl {
        name = "argparse___argparse_1.0.10.tgz";
        url  = "https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz";
<<<<<<< HEAD
        sha512 = "o5Roy6tNG4SL/FOkCAN6RzjiakZS25RLYFrcMttJqbdd8BWrnA+fGz57iN5Pb06pvBGvl5gQ0B48dJlslXvoTg==";
      };
    }
    {
      name = "aria_query___aria_query_5.1.3.tgz";
      path = fetchurl {
        name = "aria_query___aria_query_5.1.3.tgz";
        url  = "https://registry.yarnpkg.com/aria-query/-/aria-query-5.1.3.tgz";
        sha512 = "R5iJ5lkuHybztUfuOAznmboyjWq8O6sqNqtK7CLOqdydi54VNbORp49mb14KbWgG1QD3JFO9hJdZ+y4KutfdOQ==";
      };
    }
    {
      name = "array_buffer_byte_length___array_buffer_byte_length_1.0.0.tgz";
      path = fetchurl {
        name = "array_buffer_byte_length___array_buffer_byte_length_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz";
        sha512 = "LPuwb2P+NrQw3XhxGc36+XSvuBPopovXYTR9Ew++Du9Yb/bx5AzBfrIsBoj0EZUifjQU+sHL21sseZ3jerWO/A==";
      };
    }
    {
      name = "array_includes___array_includes_3.1.6.tgz";
      path = fetchurl {
        name = "array_includes___array_includes_3.1.6.tgz";
        url  = "https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.6.tgz";
        sha512 = "sgTbLvL6cNnw24FnbaDyjmvddQ2ML8arZsgaJhoABMoplz/4QRhtrYS+alr1BUM1Bwp6dhx8vVCBSLG+StwOFw==";
=======
        sha1 = "bcd6791ea5ae09725e17e5ad988134cd40b3d911";
      };
    }
    {
      name = "aria_query___aria_query_4.2.2.tgz";
      path = fetchurl {
        name = "aria_query___aria_query_4.2.2.tgz";
        url  = "https://registry.yarnpkg.com/aria-query/-/aria-query-4.2.2.tgz";
        sha1 = "0d2ca6c9aceb56b8977e9fed6aed7e15bbd2f83b";
      };
    }
    {
      name = "array_includes___array_includes_3.1.4.tgz";
      path = fetchurl {
        name = "array_includes___array_includes_3.1.4.tgz";
        url  = "https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.4.tgz";
        sha1 = "f5b493162c760f3539631f005ba2bb46acb45ba9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "array_union___array_union_2.1.0.tgz";
      path = fetchurl {
        name = "array_union___array_union_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/array-union/-/array-union-2.1.0.tgz";
<<<<<<< HEAD
        sha512 = "HGyxoOTYUyCM6stUe6EJgnd4EoewAI7zMdfqO+kGjnlZmBDz/cR5pf8r/cR4Wq60sL/p0IkcjUEEPwS3GFrIyw==";
      };
    }
    {
      name = "array.prototype.flat___array.prototype.flat_1.3.1.tgz";
      path = fetchurl {
        name = "array.prototype.flat___array.prototype.flat_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.3.1.tgz";
        sha512 = "roTU0KWIOmJ4DRLmwKd19Otg0/mT3qPNt0Qb3GWW8iObuZXxrjB/pzn0R3hqpRSWg4HCwqx+0vwOnWnvlOyeIA==";
      };
    }
    {
      name = "array.prototype.flatmap___array.prototype.flatmap_1.3.1.tgz";
      path = fetchurl {
        name = "array.prototype.flatmap___array.prototype.flatmap_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.3.1.tgz";
        sha512 = "8UGn9O1FDVvMNB0UlLv4voxRMze7+FpHyF5mSMRjWHUMlpoDViniy05870VlxhfgTnLbpuwTzvD76MTtWxB/mQ==";
      };
    }
    {
      name = "array.prototype.tosorted___array.prototype.tosorted_1.1.1.tgz";
      path = fetchurl {
        name = "array.prototype.tosorted___array.prototype.tosorted_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/array.prototype.tosorted/-/array.prototype.tosorted-1.1.1.tgz";
        sha512 = "pZYPXPRl2PqWcsUs6LOMn+1f1532nEoPTYowBtqLwAW+W8vSVhkIGnmOX1t/UQjD6YGI0vcD2B1U7ZFGQH9jnQ==";
=======
        sha1 = "b798420adbeb1de828d84acd8a2e23d3efe85e8d";
      };
    }
    {
      name = "array.prototype.flat___array.prototype.flat_1.2.5.tgz";
      path = fetchurl {
        name = "array.prototype.flat___array.prototype.flat_1.2.5.tgz";
        url  = "https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.2.5.tgz";
        sha1 = "07e0975d84bbc7c48cd1879d609e682598d33e13";
      };
    }
    {
      name = "array.prototype.flatmap___array.prototype.flatmap_1.2.5.tgz";
      path = fetchurl {
        name = "array.prototype.flatmap___array.prototype.flatmap_1.2.5.tgz";
        url  = "https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.2.5.tgz";
        sha1 = "908dc82d8a406930fdf38598d51e7411d18d4446";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "arrify___arrify_1.0.1.tgz";
      path = fetchurl {
        name = "arrify___arrify_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/arrify/-/arrify-1.0.1.tgz";
<<<<<<< HEAD
        sha512 = "3CYzex9M9FGQjCGMGyi6/31c8GJbgb0qGyrx5HWxPd0aCwh4cB2YjMb2Xf9UuoogrMrlO9cTqnB5rI5GHZTcUA==";
=======
        sha1 = "898508da2226f380df904728456849c1501a4b0d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ast_types_flow___ast_types_flow_0.0.7.tgz";
      path = fetchurl {
        name = "ast_types_flow___ast_types_flow_0.0.7.tgz";
        url  = "https://registry.yarnpkg.com/ast-types-flow/-/ast-types-flow-0.0.7.tgz";
<<<<<<< HEAD
        sha512 = "eBvWn1lvIApYMhzQMsu9ciLfkBY499mFZlNqG+/9WR7PVlroQw0vG30cOQQbaKz3sCEc44TAOu2ykzqXSNnwag==";
=======
        sha1 = "f70b735c6bca1a5c9c22d982c3e39e7feba3bdad";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "astral_regex___astral_regex_2.0.0.tgz";
      path = fetchurl {
        name = "astral_regex___astral_regex_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz";
<<<<<<< HEAD
        sha512 = "Z7tMw1ytTXt5jqMcOP+OQteU1VuNK9Y02uuJtKQ1Sv69jXQKKg5cibLwGJow8yzZP+eAc18EmLGPal0bp36rvQ==";
      };
    }
    {
      name = "autoprefixer___autoprefixer_10.4.14.tgz";
      path = fetchurl {
        name = "autoprefixer___autoprefixer_10.4.14.tgz";
        url  = "https://registry.yarnpkg.com/autoprefixer/-/autoprefixer-10.4.14.tgz";
        sha512 = "FQzyfOsTlwVzjHxKEqRIAdJx9niO6VCBCoEwax/VLSoQF29ggECcPuBqUMZ+u8jCZOPSy8b8/8KnuFbp0SaFZQ==";
      };
    }
    {
      name = "available_typed_arrays___available_typed_arrays_1.0.5.tgz";
      path = fetchurl {
        name = "available_typed_arrays___available_typed_arrays_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz";
        sha512 = "DMD0KiN46eipeziST1LPP/STfDU0sufISXmjSgvVsoU2tqxctQeASejWcfNtxYKqETM1UxQ8sp2OrSBWpHY6sw==";
      };
    }
    {
      name = "axe_core___axe_core_4.7.0.tgz";
      path = fetchurl {
        name = "axe_core___axe_core_4.7.0.tgz";
        url  = "https://registry.yarnpkg.com/axe-core/-/axe-core-4.7.0.tgz";
        sha512 = "M0JtH+hlOL5pLQwHOLNYZaXuhqmvS8oExsqB1SBYgA4Dk7u/xx+YdGHXaK5pyUfed5mYXdlYiphWq3G8cRi5JQ==";
      };
    }
    {
      name = "axios___axios_0.21.4.tgz";
      path = fetchurl {
        name = "axios___axios_0.21.4.tgz";
        url  = "https://registry.yarnpkg.com/axios/-/axios-0.21.4.tgz";
        sha512 = "ut5vewkiu8jjGBdqpM44XxjuCjq9LAKeHVmoVfHVzy8eHgxxq8SbAVQNovDA8mVi05kP0Ea/n/UzcSHcTJQfNg==";
      };
    }
    {
      name = "axobject_query___axobject_query_3.1.1.tgz";
      path = fetchurl {
        name = "axobject_query___axobject_query_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/axobject-query/-/axobject-query-3.1.1.tgz";
        sha512 = "goKlv8DZrK9hUh975fnHzhNIO4jUnFCfv/dszV5VwUGDFjI6vQ2VwoyjYjYNEbBE8AH87TduWP5uyDR1D+Iteg==";
=======
        sha1 = "483143c567aeed4785759c0865786dc77d7d2e31";
      };
    }
    {
      name = "autoprefixer___autoprefixer_10.4.2.tgz";
      path = fetchurl {
        name = "autoprefixer___autoprefixer_10.4.2.tgz";
        url  = "https://registry.yarnpkg.com/autoprefixer/-/autoprefixer-10.4.2.tgz";
        sha1 = "25e1df09a31a9fba5c40b578936b90d35c9d4d3b";
      };
    }
    {
      name = "autoprefixer___autoprefixer_9.8.8.tgz";
      path = fetchurl {
        name = "autoprefixer___autoprefixer_9.8.8.tgz";
        url  = "https://registry.yarnpkg.com/autoprefixer/-/autoprefixer-9.8.8.tgz";
        sha1 = "fd4bd4595385fa6f06599de749a4d5f7a474957a";
      };
    }
    {
      name = "axe_core___axe_core_4.3.5.tgz";
      path = fetchurl {
        name = "axe_core___axe_core_4.3.5.tgz";
        url  = "https://registry.yarnpkg.com/axe-core/-/axe-core-4.3.5.tgz";
        sha1 = "78d6911ba317a8262bfee292aeafcc1e04b49cc5";
      };
    }
    {
      name = "axobject_query___axobject_query_2.2.0.tgz";
      path = fetchurl {
        name = "axobject_query___axobject_query_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/axobject-query/-/axobject-query-2.2.0.tgz";
        sha1 = "943d47e10c0b704aa42275e20edf3722648989be";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "babel_eslint___babel_eslint_10.1.0.tgz";
      path = fetchurl {
        name = "babel_eslint___babel_eslint_10.1.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-eslint/-/babel-eslint-10.1.0.tgz";
<<<<<<< HEAD
        sha512 = "ifWaTHQ0ce+448CYop8AdrQiBsGrnC+bMgfyKFdi6EsPLTAWG+QfyDeM6OH+FmWnKvEq5NnBMLvlBUPKQZoDSg==";
      };
    }
    {
      name = "babel_loader___babel_loader_8.3.0.tgz";
      path = fetchurl {
        name = "babel_loader___babel_loader_8.3.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-loader/-/babel-loader-8.3.0.tgz";
        sha512 = "H8SvsMF+m9t15HNLMipppzkC+Y2Yq+v3SonZyU70RBL/h1gxPkH08Ot8pEE9Z4Kd+czyWJClmFS8qzIP9OZ04Q==";
      };
    }
    {
      name = "babel_plugin_polyfill_corejs2___babel_plugin_polyfill_corejs2_0.3.3.tgz";
      path = fetchurl {
        name = "babel_plugin_polyfill_corejs2___babel_plugin_polyfill_corejs2_0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.3.3.tgz";
        sha512 = "8hOdmFYFSZhqg2C/JgLUQ+t52o5nirNwaWM2B9LWteozwIvM14VSwdsCAUET10qT+kmySAlseadmfeeSWFCy+Q==";
      };
    }
    {
      name = "babel_plugin_polyfill_corejs3___babel_plugin_polyfill_corejs3_0.6.0.tgz";
      path = fetchurl {
        name = "babel_plugin_polyfill_corejs3___babel_plugin_polyfill_corejs3_0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.6.0.tgz";
        sha512 = "+eHqR6OPcBhJOGgsIar7xoAB1GcSwVUA3XjAd7HJNzOXT4wv6/H7KIdA/Nc60cvUlDbKApmqNvD1B1bzOt4nyA==";
      };
    }
    {
      name = "babel_plugin_polyfill_regenerator___babel_plugin_polyfill_regenerator_0.4.1.tgz";
      path = fetchurl {
        name = "babel_plugin_polyfill_regenerator___babel_plugin_polyfill_regenerator_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.4.1.tgz";
        sha512 = "NtQGmyQDXjQqQ+IzRkBVwEOz9lQ4zxAQZgoAYEtU9dJjnl1Oc98qnN7jcp+bE7O7aYzVpavXE3/VKXNzUbh7aw==";
=======
        sha1 = "6968e568a910b78fb3779cdd8b6ac2f479943232";
      };
    }
    {
      name = "babel_loader___babel_loader_8.2.3.tgz";
      path = fetchurl {
        name = "babel_loader___babel_loader_8.2.3.tgz";
        url  = "https://registry.yarnpkg.com/babel-loader/-/babel-loader-8.2.3.tgz";
        sha1 = "8986b40f1a64cacfcb4b8429320085ef68b1342d";
      };
    }
    {
      name = "babel_plugin_dynamic_import_node___babel_plugin_dynamic_import_node_2.3.3.tgz";
      path = fetchurl {
        name = "babel_plugin_dynamic_import_node___babel_plugin_dynamic_import_node_2.3.3.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-dynamic-import-node/-/babel-plugin-dynamic-import-node-2.3.3.tgz";
        sha1 = "84fda19c976ec5c6defef57f9427b3def66e17a3";
      };
    }
    {
      name = "babel_plugin_polyfill_corejs2___babel_plugin_polyfill_corejs2_0.3.1.tgz";
      path = fetchurl {
        name = "babel_plugin_polyfill_corejs2___babel_plugin_polyfill_corejs2_0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.3.1.tgz";
        sha1 = "440f1b70ccfaabc6b676d196239b138f8a2cfba5";
      };
    }
    {
      name = "babel_plugin_polyfill_corejs3___babel_plugin_polyfill_corejs3_0.5.1.tgz";
      path = fetchurl {
        name = "babel_plugin_polyfill_corejs3___babel_plugin_polyfill_corejs3_0.5.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.5.1.tgz";
        sha1 = "d66183bf10976ea677f4149a7fcc4d8df43d4060";
      };
    }
    {
      name = "babel_plugin_polyfill_regenerator___babel_plugin_polyfill_regenerator_0.3.1.tgz";
      path = fetchurl {
        name = "babel_plugin_polyfill_regenerator___babel_plugin_polyfill_regenerator_0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.3.1.tgz";
        sha1 = "2c0678ea47c75c8cc2fbb1852278d8fb68233990";
      };
    }
    {
      name = "bail___bail_1.0.5.tgz";
      path = fetchurl {
        name = "bail___bail_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/bail/-/bail-1.0.5.tgz";
        sha1 = "b6fa133404a392cbc1f8c4bf63f5953351e7a776";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "balanced_match___balanced_match_1.0.2.tgz";
      path = fetchurl {
        name = "balanced_match___balanced_match_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz";
<<<<<<< HEAD
        sha512 = "3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==";
=======
        sha1 = "e83e3a7e3f300b34cb9d87f615fa0cbf357690ee";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "balanced_match___balanced_match_2.0.0.tgz";
      path = fetchurl {
        name = "balanced_match___balanced_match_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-2.0.0.tgz";
<<<<<<< HEAD
        sha512 = "1ugUSr8BHXRnK23KfuYS+gVMC3LB8QGH9W1iGtDPsNWoQbgtXSExkBu2aDR4epiGWZOjZsj6lDl/N/AqqTC3UA==";
=======
        sha1 = "dc70f920d78db8b858535795867bf48f820633d9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "big.js___big.js_5.2.2.tgz";
      path = fetchurl {
        name = "big.js___big.js_5.2.2.tgz";
        url  = "https://registry.yarnpkg.com/big.js/-/big.js-5.2.2.tgz";
<<<<<<< HEAD
        sha512 = "vyL2OymJxmarO8gxMr0mhChsO9QGwhynfuu4+MHTAW6czfq9humCB7rKpUjDd9YUiDPU4mzpyupFSvOClAwbmQ==";
=======
        sha1 = "65f0af382f578bcdc742bd9c281e9cb2d7768328";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "binary_extensions___binary_extensions_2.2.0.tgz";
      path = fetchurl {
        name = "binary_extensions___binary_extensions_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.2.0.tgz";
<<<<<<< HEAD
        sha512 = "jDctJ/IVQbZoJykoeHbhXpOlNBqGNcwXJKJog42E5HDPUwQTSdjCHdihjj0DlnheQ7blbT6dHOafNAiS8ooQKA==";
=======
        sha1 = "75f502eeaf9ffde42fc98829645be4ea76bd9e2d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "boolbase___boolbase_1.0.0.tgz";
      path = fetchurl {
        name = "boolbase___boolbase_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/boolbase/-/boolbase-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "JZOSA7Mo9sNGB8+UjSgzdLtokWAky1zbztM3WRLCbZ70/3cTANmQmOdR7y2g+J0e2WXywy1yS468tY+IruqEww==";
=======
        sha1 = "68dff5fbe60c51eb37725ea9e3ed310dcc1e776e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "brace_expansion___brace_expansion_1.1.11.tgz";
      path = fetchurl {
        name = "brace_expansion___brace_expansion_1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz";
<<<<<<< HEAD
        sha512 = "iCuPHDFgrHX7H2vEI/5xpz07zSHB00TpugqhmYtVmMO6518mCuRMoOYFldEBl0g187ufozdaHgWKcYFb61qGiA==";
=======
        sha1 = "3c7fcbf529d87226f3d2f52b966ff5271eb441dd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "braces___braces_3.0.2.tgz";
      path = fetchurl {
        name = "braces___braces_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz";
<<<<<<< HEAD
        sha512 = "b8um+L1RzM3WDSzvhm6gIz1yfTbBt6YTlcEKAvsmqCZZFw46z626lVj9j1yEPW33H5H+lBQpZMP1k8l+78Ha0A==";
=======
        sha1 = "3454e1a462ee8d599e236df336cd9ea4f8afe107";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "brfs___brfs_1.6.1.tgz";
      path = fetchurl {
        name = "brfs___brfs_1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/brfs/-/brfs-1.6.1.tgz";
<<<<<<< HEAD
        sha512 = "OfZpABRQQf+Xsmju8XE9bDjs+uU4vLREGolP7bDgcpsI17QREyZ4Bl+2KLxxx1kCgA0fAIhKQBaBYh+PEcCqYQ==";
      };
    }
    {
      name = "brotli_size___brotli_size_4.0.0.tgz";
      path = fetchurl {
        name = "brotli_size___brotli_size_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/brotli-size/-/brotli-size-4.0.0.tgz";
        sha512 = "uA9fOtlTRC0iqKfzff1W34DXUA3GyVqbUaeo3Rw3d4gd1eavKVCETXrn3NzO74W+UVkG3UHu8WxUi+XvKI/huA==";
      };
    }
    {
      name = "browserslist___browserslist_4.21.5.tgz";
      path = fetchurl {
        name = "browserslist___browserslist_4.21.5.tgz";
        url  = "https://registry.yarnpkg.com/browserslist/-/browserslist-4.21.5.tgz";
        sha512 = "tUkiguQGW7S3IhB7N+c2MV/HZPSCPAAiYBZXLsBhFB/PCy6ZKKsZrmBayHV9fdGV/ARIfJ14NkxKzRDjvp7L6w==";
=======
        sha1 = "b78ce2336d818e25eea04a0947cba6d4fb8849c3";
      };
    }
    {
      name = "browserslist___browserslist_4.19.1.tgz";
      path = fetchurl {
        name = "browserslist___browserslist_4.19.1.tgz";
        url  = "https://registry.yarnpkg.com/browserslist/-/browserslist-4.19.1.tgz";
        sha1 = "4ac0435b35ab655896c31d53018b6dd5e9e4c9a3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "buffer_equal___buffer_equal_0.0.1.tgz";
      path = fetchurl {
        name = "buffer_equal___buffer_equal_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/buffer-equal/-/buffer-equal-0.0.1.tgz";
<<<<<<< HEAD
        sha512 = "RgSV6InVQ9ODPdLWJ5UAqBqJBOg370Nz6ZQtRzpt6nUjc8v0St97uJ4PYC6NztqIScrAXafKM3mZPMygSe1ggA==";
=======
        sha1 = "91bc74b11ea405bc916bc6aa908faafa5b4aac4b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "buffer_from___buffer_from_1.1.2.tgz";
      path = fetchurl {
        name = "buffer_from___buffer_from_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.2.tgz";
<<<<<<< HEAD
        sha512 = "E+XQCRwSbaaiChtv6k6Dwgc+bx+Bs6vuKJHHl5kox/BaKbhiXzqQOwK4cO22yElGp2OCmjwVhT3HmxgyPGnJfQ==";
      };
    }
    {
      name = "bundlemon_utils___bundlemon_utils_1.2.0.tgz";
      path = fetchurl {
        name = "bundlemon_utils___bundlemon_utils_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/bundlemon-utils/-/bundlemon-utils-1.2.0.tgz";
        sha512 = "yC8DPG8y6WyBxLYbwRs6yydPtcsWfgGmbUI8+LDPUa+zcMVCGSZOszysJ7SJGlnN7dI7PW+8Ed7RtWpOZI2hOQ==";
      };
    }
    {
      name = "bundlemon___bundlemon_1.4.0.tgz";
      path = fetchurl {
        name = "bundlemon___bundlemon_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/bundlemon/-/bundlemon-1.4.0.tgz";
        sha512 = "A5mzeMZrnUzKNNo8ng1PFlxZr57XM2HDsaX07kJ1u59BDWn2JFYNeUIUSXhmLdoqBHK9Ln7wTLXDnoqOlcJP5A==";
=======
        sha1 = "2b146a6fd72e80b4f55d255f35ed59a3a9a41bd5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "bytes___bytes_3.1.2.tgz";
      path = fetchurl {
        name = "bytes___bytes_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/bytes/-/bytes-3.1.2.tgz";
<<<<<<< HEAD
        sha512 = "/Nf7TyzTx6S3yRJObOAV7956r8cr2+Oj8AC5dt8wSP3BQAoeX58NoHyCU8P8zGkNXStjTSi6fzO6F0pBdcYbEg==";
=======
        sha1 = "8b0beeb98605adf1b128fa4386403c009e0221a5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "call_bind___call_bind_1.0.2.tgz";
      path = fetchurl {
        name = "call_bind___call_bind_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz";
<<<<<<< HEAD
        sha512 = "7O+FbCihrB5WGbFYesctwmTKae6rOiIzmz1icreWJ+0aA7LJfuqhEso2T9ncpcFtzMQtzXf2QGGueWJGTYsqrA==";
=======
        sha1 = "b1d4e89e688119c3c9a903ad30abb2f6a919be3c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "callsites___callsites_3.1.0.tgz";
      path = fetchurl {
        name = "callsites___callsites_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz";
<<<<<<< HEAD
        sha512 = "P8BjAsXvZS+VIDUI11hHCQEv74YT67YUi5JJFNWIqL235sBmjX4+qx9Muvls5ivyNENctx46xQLQ3aTuE7ssaQ==";
=======
        sha1 = "b3630abd8943432f54b3f0519238e33cd7df2f73";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "camelcase_css___camelcase_css_2.0.1.tgz";
      path = fetchurl {
        name = "camelcase_css___camelcase_css_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/camelcase-css/-/camelcase-css-2.0.1.tgz";
<<<<<<< HEAD
        sha512 = "QOSvevhslijgYwRx6Rv7zKdMF8lbRmx+uQGx2+vDc+KI/eBnsy9kit5aj23AgGu3pa4t9AgwbnXWqS+iOY+2aA==";
=======
        sha1 = "ee978f6947914cc30c6b44741b6ed1df7f043fd5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "camelcase_keys___camelcase_keys_6.2.2.tgz";
      path = fetchurl {
        name = "camelcase_keys___camelcase_keys_6.2.2.tgz";
        url  = "https://registry.yarnpkg.com/camelcase-keys/-/camelcase-keys-6.2.2.tgz";
<<<<<<< HEAD
        sha512 = "YrwaA0vEKazPBkn0ipTiMpSajYDSe+KjQfrjhcBMxJt/znbvlHd8Pw/Vamaz5EB4Wfhs3SUR3Z9mwRu/P3s3Yg==";
=======
        sha1 = "5e755d6ba51aa223ec7d3d52f25778210f9dc3c0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "camelcase___camelcase_5.3.1.tgz";
      path = fetchurl {
        name = "camelcase___camelcase_5.3.1.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz";
<<<<<<< HEAD
        sha512 = "L28STB170nwWS63UjtlEOE3dldQApaJXZkOI1uMFfzf3rRuPegHaHesyee+YxQ+W6SvRDQV6UrdOdRiR153wJg==";
=======
        sha1 = "e3c9b31569e106811df242f715725a1f4c494320";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "caniuse_api___caniuse_api_3.0.0.tgz";
      path = fetchurl {
        name = "caniuse_api___caniuse_api_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/caniuse-api/-/caniuse-api-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "bsTwuIg/BZZK/vreVTYYbSWoe2F+71P7K5QGEX+pT250DZbfU1MQ5prOKpPR+LL6uWKK3KMwMCAS74QB3Um1uw==";
      };
    }
    {
      name = "caniuse_lite___caniuse_lite_1.0.30001481.tgz";
      path = fetchurl {
        name = "caniuse_lite___caniuse_lite_1.0.30001481.tgz";
        url  = "https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30001481.tgz";
        sha512 = "KCqHwRnaa1InZBtqXzP98LPg0ajCVujMKjqKDhZEthIpAsJl/YEIa3YvXjGXPVqzZVguccuu7ga9KOE1J9rKPQ==";
=======
        sha1 = "5e4d90e2274961d46291997df599e3ed008ee4c0";
      };
    }
    {
      name = "caniuse_lite___caniuse_lite_1.0.30001304.tgz";
      path = fetchurl {
        name = "caniuse_lite___caniuse_lite_1.0.30001304.tgz";
        url  = "https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30001304.tgz";
        sha1 = "38af55ed3fc8220cb13e35e6e7309c8c65a05559";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "chalk___chalk_2.4.2.tgz";
      path = fetchurl {
        name = "chalk___chalk_2.4.2.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz";
<<<<<<< HEAD
        sha512 = "Mti+f9lpJNcwF4tWV8/OrTTtF1gZi+f8FqlyAdouralcFWFQWF2+NgCHShjkCb+IFBLq9buZwE1xckQU4peSuQ==";
=======
        sha1 = "cd42541677a54333cf541a49108c1432b44c9424";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "chalk___chalk_4.1.2.tgz";
      path = fetchurl {
        name = "chalk___chalk_4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz";
<<<<<<< HEAD
        sha512 = "oKnbhFyRIXpUuez8iBMmyEa4nbj4IOQyuhc/wy9kY7/WVPcwIO9VA668Pu8RkO7+0G76SLROeyw9CpQ061i4mA==";
      };
    }
    {
      name = "chart.js___chart.js_3.9.1.tgz";
      path = fetchurl {
        name = "chart.js___chart.js_3.9.1.tgz";
        url  = "https://registry.yarnpkg.com/chart.js/-/chart.js-3.9.1.tgz";
        sha512 = "Ro2JbLmvg83gXF5F4sniaQ+lTbSv18E+TIf2cOeiH1Iqd2PGFOtem+DUufMZsCJwFE7ywPOpfXFBwRTGq7dh6w==";
=======
        sha1 = "aac4e2b7734a740867aeb16bf02aad556a1e7a01";
      };
    }
    {
      name = "character_entities_legacy___character_entities_legacy_1.1.4.tgz";
      path = fetchurl {
        name = "character_entities_legacy___character_entities_legacy_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/character-entities-legacy/-/character-entities-legacy-1.1.4.tgz";
        sha1 = "94bc1845dce70a5bb9d2ecc748725661293d8fc1";
      };
    }
    {
      name = "character_entities___character_entities_1.2.4.tgz";
      path = fetchurl {
        name = "character_entities___character_entities_1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/character-entities/-/character-entities-1.2.4.tgz";
        sha1 = "e12c3939b7eaf4e5b15e7ad4c5e28e1d48c5b16b";
      };
    }
    {
      name = "character_reference_invalid___character_reference_invalid_1.1.4.tgz";
      path = fetchurl {
        name = "character_reference_invalid___character_reference_invalid_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/character-reference-invalid/-/character-reference-invalid-1.1.4.tgz";
        sha1 = "083329cda0eae272ab3dbbf37e9a382c13af1560";
      };
    }
    {
      name = "chart.js___chart.js_3.7.0.tgz";
      path = fetchurl {
        name = "chart.js___chart.js_3.7.0.tgz";
        url  = "https://registry.yarnpkg.com/chart.js/-/chart.js-3.7.0.tgz";
        sha1 = "7a19c93035341df801d613993c2170a1fcf1d882";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "chokidar___chokidar_3.5.3.tgz";
      path = fetchurl {
        name = "chokidar___chokidar_3.5.3.tgz";
        url  = "https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.3.tgz";
<<<<<<< HEAD
        sha512 = "Dr3sfKRP6oTcjf2JmUmFJfeVMvXBdegxB0iVQ5eb2V10uFJUCAS8OByZdVAyVb8xXNz3GjjTgj9kLWsZTqE6kw==";
=======
        sha1 = "1cf37c8707b932bd1af1ae22c0432e2acd1903bd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "chrome_trace_event___chrome_trace_event_1.0.3.tgz";
      path = fetchurl {
        name = "chrome_trace_event___chrome_trace_event_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/chrome-trace-event/-/chrome-trace-event-1.0.3.tgz";
<<<<<<< HEAD
        sha512 = "p3KULyQg4S7NIHixdwbGX+nFHkoBiA4YQmyWtjb8XngSKV124nJmRysgAeujbUVb15vh+RvFUfCPqU7rXk+hZg==";
      };
    }
    {
      name = "classnames___classnames_2.3.2.tgz";
      path = fetchurl {
        name = "classnames___classnames_2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/classnames/-/classnames-2.3.2.tgz";
        sha512 = "CSbhY4cFEJRe6/GQzIk5qXZ4Jeg5pcsP7b5peFSDpffpe1cqjASH/n9UTjBwOp6XpMSTwQ8Za2K5V02ueA7Tmw==";
      };
    }
    {
      name = "client_only___client_only_0.0.1.tgz";
      path = fetchurl {
        name = "client_only___client_only_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/client-only/-/client-only-0.0.1.tgz";
        sha512 = "IV3Ou0jSMzZrd3pZ48nLkT9DA7Ag1pnPzaiQhpW7c3RbcqqzvzzVu+L8gfqMp/8IM2MQtSiqaCxrrcfu8I8rMA==";
=======
        sha1 = "1015eced4741e15d06664a957dbbf50d041e26ac";
      };
    }
    {
      name = "classnames___classnames_2.3.1.tgz";
      path = fetchurl {
        name = "classnames___classnames_2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/classnames/-/classnames-2.3.1.tgz";
        sha1 = "dfcfa3891e306ec1dad105d0e88f4417b8535e8e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "clone_deep___clone_deep_4.0.1.tgz";
      path = fetchurl {
        name = "clone_deep___clone_deep_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/clone-deep/-/clone-deep-4.0.1.tgz";
<<<<<<< HEAD
        sha512 = "neHB9xuzh/wk0dIHweyAXv2aPGZIVk3pLMe+/RNzINf17fe0OG96QroktYAUm7SM1PBnzTabaLboqqxDyMU+SQ==";
=======
        sha1 = "c19fd9bdbbf85942b4fd979c84dcf7d5f07c2387";
      };
    }
    {
      name = "clone_regexp___clone_regexp_2.2.0.tgz";
      path = fetchurl {
        name = "clone_regexp___clone_regexp_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/clone-regexp/-/clone-regexp-2.2.0.tgz";
        sha1 = "7d65e00885cd8796405c35a737e7a86b7429e36f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "color_convert___color_convert_1.9.3.tgz";
      path = fetchurl {
        name = "color_convert___color_convert_1.9.3.tgz";
        url  = "https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz";
<<<<<<< HEAD
        sha512 = "QfAUtd+vFdAtFQcC8CCyYt1fYWxSqAiK2cSD6zDB8N3cpsEBAvRxp9zOGg6G/SHHJYAT88/az/IuDGALsNVbGg==";
=======
        sha1 = "bb71850690e1f136567de629d2d5471deda4c1e8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "color_convert___color_convert_2.0.1.tgz";
      path = fetchurl {
        name = "color_convert___color_convert_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz";
<<<<<<< HEAD
        sha512 = "RRECPsj7iu/xb5oKYcsFHSppFNnsj/52OVTRKb4zP5onXwVF3zVmmToNcOfGC+CRDpfK/U584fMg38ZHCaElKQ==";
=======
        sha1 = "72d3a68d598c9bdb3af2ad1e84f21d896abd4de3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "color_name___color_name_1.1.3.tgz";
      path = fetchurl {
        name = "color_name___color_name_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz";
<<<<<<< HEAD
        sha512 = "72fSenhMw2HZMTVHeCA9KCmpEIbzWiQsjN+BHcBbS9vr1mtt+vJjPdksIBNUmKAW8TFUDPJK5SUU3QhE9NEXDw==";
=======
        sha1 = "a7d0558bd89c42f795dd42328f740831ca53bc25";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "color_name___color_name_1.1.4.tgz";
      path = fetchurl {
        name = "color_name___color_name_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz";
<<<<<<< HEAD
        sha512 = "dOy+3AuW3a2wNbZHIuMZpTcgjGuLU/uBL/ubcZF9OXbDo8ff4O8yVp5Bf0efS8uEoYo5q4Fx7dY9OgQGXgAsQA==";
      };
    }
    {
      name = "color_string___color_string_1.9.1.tgz";
      path = fetchurl {
        name = "color_string___color_string_1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/color-string/-/color-string-1.9.1.tgz";
        sha512 = "shrVawQFojnZv6xM40anx4CkoDP+fZsw/ZerEMsW/pyzsRbElpsL/DBVW7q3ExxwusdNXI3lXpuhEZkzs8p5Eg==";
      };
    }
    {
      name = "color___color_4.2.3.tgz";
      path = fetchurl {
        name = "color___color_4.2.3.tgz";
        url  = "https://registry.yarnpkg.com/color/-/color-4.2.3.tgz";
        sha512 = "1rXeuUUiGGrykh+CeBdu5Ie7OJwinCgQY0bc7GCRxy5xVHy+moaqkpL/jqQq0MtQOeYcrqEz4abc5f0KtU7W4A==";
      };
    }
    {
      name = "colord___colord_2.9.3.tgz";
      path = fetchurl {
        name = "colord___colord_2.9.3.tgz";
        url  = "https://registry.yarnpkg.com/colord/-/colord-2.9.3.tgz";
        sha512 = "jeC1axXpnb0/2nn/Y1LPuLdgXBLH7aDcHu4KEKfqw3CUhX7ZpfBSlPKyqXE6btIgEzfWtrX3/tyBCaCvXvMkOw==";
      };
    }
    {
      name = "colorette___colorette_2.0.20.tgz";
      path = fetchurl {
        name = "colorette___colorette_2.0.20.tgz";
        url  = "https://registry.yarnpkg.com/colorette/-/colorette-2.0.20.tgz";
        sha512 = "IfEDxwoWIjkeXL1eXcDiow4UbKjhLdq6/EuSVR9GMN7KVH3r9gQ83e73hsz1Nd1T3ijd5xv1wcWRYO+D6kCI2w==";
=======
        sha1 = "c2a09a87acbde69543de6f63fa3995c826c536a2";
      };
    }
    {
      name = "color_string___color_string_1.9.0.tgz";
      path = fetchurl {
        name = "color_string___color_string_1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/color-string/-/color-string-1.9.0.tgz";
        sha1 = "63b6ebd1bec11999d1df3a79a7569451ac2be8aa";
      };
    }
    {
      name = "color___color_4.2.0.tgz";
      path = fetchurl {
        name = "color___color_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/color/-/color-4.2.0.tgz";
        sha1 = "0c782459a3e98838ea01e4bc0fb43310ca35af78";
      };
    }
    {
      name = "colord___colord_2.9.2.tgz";
      path = fetchurl {
        name = "colord___colord_2.9.2.tgz";
        url  = "https://registry.yarnpkg.com/colord/-/colord-2.9.2.tgz";
        sha1 = "25e2bacbbaa65991422c07ea209e2089428effb1";
      };
    }
    {
      name = "colorette___colorette_2.0.16.tgz";
      path = fetchurl {
        name = "colorette___colorette_2.0.16.tgz";
        url  = "https://registry.yarnpkg.com/colorette/-/colorette-2.0.16.tgz";
        sha1 = "713b9af84fdb000139f04546bd4a93f62a5085da";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "commander___commander_2.20.3.tgz";
      path = fetchurl {
        name = "commander___commander_2.20.3.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz";
<<<<<<< HEAD
        sha512 = "GpVkmM8vF2vQUkj2LvZmD35JxeJOLCwJ9cUkugyk2nuhbv3+mJvpLYYt+0+USMxE+oj+ey/lJEnhZw75x/OMcQ==";
=======
        sha1 = "fd485e84c03eb4881c20722ba48035e8531aeb33";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "commander___commander_7.2.0.tgz";
      path = fetchurl {
        name = "commander___commander_7.2.0.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-7.2.0.tgz";
<<<<<<< HEAD
        sha512 = "QrWXB+ZQSVPmIWIhtEO9H+gwHaMGYiF5ChvoJ+K9ZGHG/sVsa6yiesAD1GC/x46sET00Xlwo1u49RVVVzvcSkw==";
=======
        sha1 = "a36cb57d0b501ce108e4d20559a150a391d97ab7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "commander___commander_8.3.0.tgz";
      path = fetchurl {
        name = "commander___commander_8.3.0.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-8.3.0.tgz";
<<<<<<< HEAD
        sha512 = "OkTL9umf+He2DZkUq8f8J9of7yL6RJKI24dVITBmNfZBmri9zYZQrKkuXiKhyfPSu8tUhnVBB1iKXevvnlR4Ww==";
=======
        sha1 = "4837ea1b2da67b9c616a67afbb0fafee567bca66";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "commondir___commondir_1.0.1.tgz";
      path = fetchurl {
        name = "commondir___commondir_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz";
<<<<<<< HEAD
        sha512 = "W9pAhw0ja1Edb5GVdIF1mjZw/ASI0AlShXM83UUGe2DVr5TdAPEA1OA8m/g8zWp9x6On7gqufY+FatDbC3MDQg==";
      };
    }
    {
      name = "compute_scroll_into_view___compute_scroll_into_view_1.0.20.tgz";
      path = fetchurl {
        name = "compute_scroll_into_view___compute_scroll_into_view_1.0.20.tgz";
        url  = "https://registry.yarnpkg.com/compute-scroll-into-view/-/compute-scroll-into-view-1.0.20.tgz";
        sha512 = "UCB0ioiyj8CRjtrvaceBLqqhZCVP+1B8+NWQhmdsm0VXOJtobBCf1dBQmebCCo34qZmUwZfIH2MZLqNHazrfjg==";
=======
        sha1 = "ddd800da0c66127393cca5950ea968a3aaf1253b";
      };
    }
    {
      name = "compute_scroll_into_view___compute_scroll_into_view_1.0.17.tgz";
      path = fetchurl {
        name = "compute_scroll_into_view___compute_scroll_into_view_1.0.17.tgz";
        url  = "https://registry.yarnpkg.com/compute-scroll-into-view/-/compute-scroll-into-view-1.0.17.tgz";
        sha1 = "6a88f18acd9d42e9cf4baa6bec7e0522607ab7ab";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "concat_map___concat_map_0.0.1.tgz";
      path = fetchurl {
        name = "concat_map___concat_map_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz";
<<<<<<< HEAD
        sha512 = "/Srv4dswyQNBfohGpz9o6Yb3Gz3SrUDqBH5rTuhGR7ahtlbYKnVxw2bCFMRljaA7EXHaXZ8wsHdodFvbkhKmqg==";
=======
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "concat_stream___concat_stream_1.6.2.tgz";
      path = fetchurl {
        name = "concat_stream___concat_stream_1.6.2.tgz";
        url  = "https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz";
<<<<<<< HEAD
        sha512 = "27HBghJxjiZtIk3Ycvn/4kbJk/1uZuJFfuPEns6LaEvpvG1f0hTea8lilrouyo9mVc2GWdcEZ8OLoGmSADlrCw==";
      };
    }
    {
      name = "convert_source_map___convert_source_map_1.9.0.tgz";
      path = fetchurl {
        name = "convert_source_map___convert_source_map_1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.9.0.tgz";
        sha512 = "ASFBup0Mz1uyiIjANan1jzLQami9z1PoYSZCiiYW2FczPbenXc45FZdBZLzOT+r6+iciuEModtmCti+hjaAk0A==";
=======
        sha1 = "904bdf194cd3122fc675c77fc4ac3d4ff0fd1a34";
      };
    }
    {
      name = "convert_source_map___convert_source_map_1.8.0.tgz";
      path = fetchurl {
        name = "convert_source_map___convert_source_map_1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.8.0.tgz";
        sha1 = "f3373c32d21b4d780dd8004514684fb791ca4369";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "copy_webpack_plugin___copy_webpack_plugin_9.1.0.tgz";
      path = fetchurl {
        name = "copy_webpack_plugin___copy_webpack_plugin_9.1.0.tgz";
        url  = "https://registry.yarnpkg.com/copy-webpack-plugin/-/copy-webpack-plugin-9.1.0.tgz";
<<<<<<< HEAD
        sha512 = "rxnR7PaGigJzhqETHGmAcxKnLZSR5u1Y3/bcIv/1FnqXedcL/E2ewK7ZCNrArJKCiSv8yVXhTqetJh8inDvfsA==";
      };
    }
    {
      name = "core_js_compat___core_js_compat_3.30.1.tgz";
      path = fetchurl {
        name = "core_js_compat___core_js_compat_3.30.1.tgz";
        url  = "https://registry.yarnpkg.com/core-js-compat/-/core-js-compat-3.30.1.tgz";
        sha512 = "d690npR7MC6P0gq4npTl5n2VQeNAmUrJ90n+MHiKS7W2+xno4o3F5GDEuylSdi6EJ3VssibSGXOa1r3YXD3Mhw==";
=======
        sha1 = "2d2c460c4c4695ec0a58afb2801a1205256c4e6b";
      };
    }
    {
      name = "core_js_compat___core_js_compat_3.20.3.tgz";
      path = fetchurl {
        name = "core_js_compat___core_js_compat_3.20.3.tgz";
        url  = "https://registry.yarnpkg.com/core-js-compat/-/core-js-compat-3.20.3.tgz";
        sha1 = "d71f85f94eb5e4bea3407412e549daa083d23bd6";
      };
    }
    {
      name = "core_js_pure___core_js_pure_3.20.3.tgz";
      path = fetchurl {
        name = "core_js_pure___core_js_pure_3.20.3.tgz";
        url  = "https://registry.yarnpkg.com/core-js-pure/-/core-js-pure-3.20.3.tgz";
        sha1 = "6cc4f36da06c61d95254efc54024fe4797fd5d02";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "core_util_is___core_util_is_1.0.3.tgz";
      path = fetchurl {
        name = "core_util_is___core_util_is_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.3.tgz";
<<<<<<< HEAD
        sha512 = "ZQBvi1DcpJ4GDqanjucZ2Hj3wEO5pZDS89BWbkcrvdxksJorwUDDZamX9ldFkp9aw2lmBDLgkObEA4DWNJ9FYQ==";
      };
    }
    {
      name = "cosmiconfig___cosmiconfig_7.1.0.tgz";
      path = fetchurl {
        name = "cosmiconfig___cosmiconfig_7.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-7.1.0.tgz";
        sha512 = "AdmX6xUzdNASswsFtmwSt7Vj8po9IuqXm0UXz7QKPuEUmPB4XyjGfaAr2PSuELMwkRMVH1EpIkX5bTZGRB3eCA==";
=======
        sha1 = "a6042d3634c2b27e9328f837b965fac83808db85";
      };
    }
    {
      name = "cosmiconfig___cosmiconfig_7.0.1.tgz";
      path = fetchurl {
        name = "cosmiconfig___cosmiconfig_7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-7.0.1.tgz";
        sha1 = "714d756522cace867867ccb4474c5d01bbae5d6d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "cross_spawn___cross_spawn_7.0.3.tgz";
      path = fetchurl {
        name = "cross_spawn___cross_spawn_7.0.3.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz";
<<<<<<< HEAD
        sha512 = "iRDPJKUPVEND7dHPO8rkbOnPpyDygcDFtWjpeWNCgy8WP2rXcxXL8TskReQl6OrB2G7+UJrags1q15Fudc7G6w==";
=======
        sha1 = "f73a85b9d5d41d045551c177e2882d4ac85728a6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "css_color_names___css_color_names_0.0.4.tgz";
      path = fetchurl {
        name = "css_color_names___css_color_names_0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/css-color-names/-/css-color-names-0.0.4.tgz";
<<<<<<< HEAD
        sha512 = "zj5D7X1U2h2zsXOAM8EyUREBnnts6H+Jm+d1M2DbiQQcUtnqgQsMrdo8JW9R80YFUmIdBZeMu5wvYM7hcgWP/Q==";
      };
    }
    {
      name = "css_declaration_sorter___css_declaration_sorter_6.4.0.tgz";
      path = fetchurl {
        name = "css_declaration_sorter___css_declaration_sorter_6.4.0.tgz";
        url  = "https://registry.yarnpkg.com/css-declaration-sorter/-/css-declaration-sorter-6.4.0.tgz";
        sha512 = "jDfsatwWMWN0MODAFuHszfjphEXfNw9JUAhmY4pLu3TyTU+ohUpsbVtbU+1MZn4a47D9kqh03i4eyOm+74+zew==";
      };
    }
    {
      name = "css_functions_list___css_functions_list_3.1.0.tgz";
      path = fetchurl {
        name = "css_functions_list___css_functions_list_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/css-functions-list/-/css-functions-list-3.1.0.tgz";
        sha512 = "/9lCvYZaUbBGvYUgYGFJ4dcYiyqdhSjG7IPVluoV8A1ILjkF7ilmhp1OGUz8n+nmBcu0RNrQAzgD8B6FJbrt2w==";
=======
        sha1 = "808adc2e79cf84738069b646cb20ec27beb629e0";
      };
    }
    {
      name = "css_declaration_sorter___css_declaration_sorter_6.1.4.tgz";
      path = fetchurl {
        name = "css_declaration_sorter___css_declaration_sorter_6.1.4.tgz";
        url  = "https://registry.yarnpkg.com/css-declaration-sorter/-/css-declaration-sorter-6.1.4.tgz";
        sha1 = "b9bfb4ed9a41f8dcca9bf7184d849ea94a8294b4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "css_loader___css_loader_5.2.7.tgz";
      path = fetchurl {
        name = "css_loader___css_loader_5.2.7.tgz";
        url  = "https://registry.yarnpkg.com/css-loader/-/css-loader-5.2.7.tgz";
<<<<<<< HEAD
        sha512 = "Q7mOvpBNBG7YrVGMxRxcBJZFL75o+cH2abNASdibkj/fffYD8qWbInZrD0S9ccI6vZclF3DsHE7njGlLtaHbhg==";
=======
        sha1 = "9b9f111edf6fb2be5dc62525644cbc9c232064ae";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "css_minimizer_webpack_plugin___css_minimizer_webpack_plugin_3.4.1.tgz";
      path = fetchurl {
        name = "css_minimizer_webpack_plugin___css_minimizer_webpack_plugin_3.4.1.tgz";
        url  = "https://registry.yarnpkg.com/css-minimizer-webpack-plugin/-/css-minimizer-webpack-plugin-3.4.1.tgz";
<<<<<<< HEAD
        sha512 = "1u6D71zeIfgngN2XNRJefc/hY7Ybsxd74Jm4qngIXyUEk7fss3VUzuHxLAq/R8NAba4QU9OUSaMZlbpRc7bM4Q==";
      };
    }
    {
      name = "css_select___css_select_4.3.0.tgz";
      path = fetchurl {
        name = "css_select___css_select_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/css-select/-/css-select-4.3.0.tgz";
        sha512 = "wPpOYtnsVontu2mODhA19JrqWxNsfdatRKd64kmpRbQgh1KtItko5sTnEpPdpSaJszTOhEMlF/RPz28qj4HqhQ==";
=======
        sha1 = "ab78f781ced9181992fe7b6e4f3422e76429878f";
      };
    }
    {
      name = "css_select___css_select_4.2.1.tgz";
      path = fetchurl {
        name = "css_select___css_select_4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/css-select/-/css-select-4.2.1.tgz";
        sha1 = "9e665d6ae4c7f9d65dbe69d0316e3221fb274cdd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "css_tree___css_tree_1.1.3.tgz";
      path = fetchurl {
        name = "css_tree___css_tree_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/css-tree/-/css-tree-1.1.3.tgz";
<<<<<<< HEAD
        sha512 = "tRpdppF7TRazZrjJ6v3stzv93qxRcSsFmW6cX0Zm2NVKpxE1WV1HblnghVv9TreireHkqI/VDEsfolRF1p6y7Q==";
=======
        sha1 = "eb4870fb6fd7707327ec95c2ff2ab09b5e8db91d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "css_unit_converter___css_unit_converter_1.1.2.tgz";
      path = fetchurl {
        name = "css_unit_converter___css_unit_converter_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/css-unit-converter/-/css-unit-converter-1.1.2.tgz";
<<<<<<< HEAD
        sha512 = "IiJwMC8rdZE0+xiEZHeru6YoONC4rfPMqGm2W85jMIbkFvv5nFTwJVFHam2eFrN6txmoUYFAFXiv8ICVeTO0MA==";
      };
    }
    {
      name = "css_what___css_what_6.1.0.tgz";
      path = fetchurl {
        name = "css_what___css_what_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/css-what/-/css-what-6.1.0.tgz";
        sha512 = "HTUrgRJ7r4dsZKU6GjmpfRK1O76h97Z8MfS1G0FozR+oF2kG6Vfe8JE6zwrkbxigziPHinCJ+gCPjA9EaBDtRw==";
=======
        sha1 = "4c77f5a1954e6dbff60695ecb214e3270436ab21";
      };
    }
    {
      name = "css_what___css_what_5.1.0.tgz";
      path = fetchurl {
        name = "css_what___css_what_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/css-what/-/css-what-5.1.0.tgz";
        sha1 = "3f7b707aadf633baf62c2ceb8579b545bb40f7fe";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "cssesc___cssesc_3.0.0.tgz";
      path = fetchurl {
        name = "cssesc___cssesc_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/cssesc/-/cssesc-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "/Tb/JcjK111nNScGob5MNtsntNM1aCNUDipB/TkwZFhyDrrE47SOx/18wF2bbjgc3ZzCSKW1T5nt5EbFoAz/Vg==";
      };
    }
    {
      name = "cssnano_preset_default___cssnano_preset_default_5.2.14.tgz";
      path = fetchurl {
        name = "cssnano_preset_default___cssnano_preset_default_5.2.14.tgz";
        url  = "https://registry.yarnpkg.com/cssnano-preset-default/-/cssnano-preset-default-5.2.14.tgz";
        sha512 = "t0SFesj/ZV2OTylqQVOrFgEh5uanxbO6ZAdeCrNsUQ6fVuXwYTxJPNAGvGTxHbD68ldIJNec7PyYZDBrfDQ+6A==";
      };
    }
    {
      name = "cssnano_utils___cssnano_utils_3.1.0.tgz";
      path = fetchurl {
        name = "cssnano_utils___cssnano_utils_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cssnano-utils/-/cssnano-utils-3.1.0.tgz";
        sha512 = "JQNR19/YZhz4psLX/rQ9M83e3z2Wf/HdJbryzte4a3NSuafyp9w/I4U+hx5C2S9g41qlstH7DEWnZaaj83OuEA==";
      };
    }
    {
      name = "cssnano___cssnano_5.1.15.tgz";
      path = fetchurl {
        name = "cssnano___cssnano_5.1.15.tgz";
        url  = "https://registry.yarnpkg.com/cssnano/-/cssnano-5.1.15.tgz";
        sha512 = "j+BKgDcLDQA+eDifLx0EO4XSA56b7uut3BQFH+wbSaSTuGLuiyTa/wbRYthUXX8LC9mLg+WWKe8h+qJuwTAbHw==";
=======
        sha1 = "37741919903b868565e1c09ea747445cd18983ee";
      };
    }
    {
      name = "cssnano_preset_default___cssnano_preset_default_5.1.11.tgz";
      path = fetchurl {
        name = "cssnano_preset_default___cssnano_preset_default_5.1.11.tgz";
        url  = "https://registry.yarnpkg.com/cssnano-preset-default/-/cssnano-preset-default-5.1.11.tgz";
        sha1 = "db10fb1ecee310e8285c5aca45bd8237be206828";
      };
    }
    {
      name = "cssnano_utils___cssnano_utils_3.0.1.tgz";
      path = fetchurl {
        name = "cssnano_utils___cssnano_utils_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/cssnano-utils/-/cssnano-utils-3.0.1.tgz";
        sha1 = "d3cc0a142d3d217f8736837ec0a2ccff6a89c6ea";
      };
    }
    {
      name = "cssnano___cssnano_5.0.16.tgz";
      path = fetchurl {
        name = "cssnano___cssnano_5.0.16.tgz";
        url  = "https://registry.yarnpkg.com/cssnano/-/cssnano-5.0.16.tgz";
        sha1 = "4ee97d30411693f3de24cef70b36f7ae2a843e04";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "csso___csso_4.2.0.tgz";
      path = fetchurl {
        name = "csso___csso_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/csso/-/csso-4.2.0.tgz";
<<<<<<< HEAD
        sha512 = "wvlcdIbf6pwKEk7vHj8/Bkc0B4ylXZruLvOgs9doS5eOsOpuodOV2zJChSpkp+pRpYQLQMeF04nr3Z68Sta9jA==";
      };
    }
    {
      name = "csstype___csstype_3.1.2.tgz";
      path = fetchurl {
        name = "csstype___csstype_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/csstype/-/csstype-3.1.2.tgz";
        sha512 = "I7K1Uu0MBPzaFKg4nI5Q7Vs2t+3gWWW648spaF+Rg7pI9ds18Ugn+lvg4SHczUdKlHI5LWBXyqfS8+DufyBsgQ==";
=======
        sha1 = "ea3a561346e8dc9f546d6febedd50187cf389529";
      };
    }
    {
      name = "csstype___csstype_3.0.10.tgz";
      path = fetchurl {
        name = "csstype___csstype_3.0.10.tgz";
        url  = "https://registry.yarnpkg.com/csstype/-/csstype-3.0.10.tgz";
        sha1 = "2ad3a7bed70f35b965707c092e5f30b327c290e5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "d3_geo_projection___d3_geo_projection_0.2.16.tgz";
      path = fetchurl {
        name = "d3_geo_projection___d3_geo_projection_0.2.16.tgz";
        url  = "https://registry.yarnpkg.com/d3-geo-projection/-/d3-geo-projection-0.2.16.tgz";
<<<<<<< HEAD
        sha512 = "NB4/NRMnfJnpodvRbNY/nOzuoU17P229ASYf2l1GwjZyfD7l5aIuMylDMbIBF4y42BGZZvGdUwFW8iFM/5UBzg==";
=======
        sha1 = "4994ecd1033ddb1533b6c4c5528a1c81dcc29427";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "d3_queue___d3_queue_1.2.3.tgz";
      path = fetchurl {
        name = "d3_queue___d3_queue_1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/d3-queue/-/d3-queue-1.2.3.tgz";
<<<<<<< HEAD
        sha512 = "m6KtxX4V5pmVf1PqhH4SkQVMshSJfyCLM2vf2oFPi9FWFVT3+rtbCGerk766b/JXymHQDU3oqXHaZoiQ/e8yUQ==";
=======
        sha1 = "143a701cfa65fe021292f321c10d14e98abd491b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "d3_queue___d3_queue_2.0.3.tgz";
      path = fetchurl {
        name = "d3_queue___d3_queue_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/d3-queue/-/d3-queue-2.0.3.tgz";
<<<<<<< HEAD
        sha512 = "ejbdHqZYEmk9ns/ljSbEcD6VRiuNwAkZMdFf6rsUb3vHROK5iMFd8xewDQnUVr6m/ba2BG63KmR/LySfsluxbg==";
=======
        sha1 = "07fbda3acae5358a9c5299aaf880adf0953ed2c2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "d3___d3_3.5.17.tgz";
      path = fetchurl {
        name = "d3___d3_3.5.17.tgz";
        url  = "https://registry.yarnpkg.com/d3/-/d3-3.5.17.tgz";
<<<<<<< HEAD
        sha512 = "yFk/2idb8OHPKkbAL8QaOaqENNoMhIaSHZerk3oQsECwkObkCpJyjYwCe+OHiq6UEdhe1m8ZGARRRO3ljFjlKg==";
=======
        sha1 = "bc46748004378b21a360c9fc7cf5231790762fb8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "damerau_levenshtein___damerau_levenshtein_1.0.8.tgz";
      path = fetchurl {
        name = "damerau_levenshtein___damerau_levenshtein_1.0.8.tgz";
        url  = "https://registry.yarnpkg.com/damerau-levenshtein/-/damerau-levenshtein-1.0.8.tgz";
<<<<<<< HEAD
        sha512 = "sdQSFB7+llfUcQHUQO3+B8ERRj0Oa4w9POWMI/puGtuf7gFywGmkaLCElnudfTiKZV+NvHqL0ifzdrI8Ro7ESA==";
=======
        sha1 = "b43d286ccbd36bc5b2f7ed41caf2d0aba1f8a6e7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "datamaps___datamaps_0.5.9.tgz";
      path = fetchurl {
        name = "datamaps___datamaps_0.5.9.tgz";
        url  = "https://registry.yarnpkg.com/datamaps/-/datamaps-0.5.9.tgz";
<<<<<<< HEAD
        sha512 = "GUXpO713URNzaExVUgBtqA5fr2UuxUG/fVitI04zEFHVL2FHSjd672alHq8E16oQqRNzF0m1bmx8WlTnDrGSqQ==";
=======
        sha1 = "2a775473aaab29b55025208b2245e840ecfd4fe1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "debounce_promise___debounce_promise_3.1.2.tgz";
      path = fetchurl {
        name = "debounce_promise___debounce_promise_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/debounce-promise/-/debounce-promise-3.1.2.tgz";
<<<<<<< HEAD
        sha512 = "rZHcgBkbYavBeD9ej6sP56XfG53d51CD4dnaw989YX/nZ/ZJfgRx/9ePKmTNiUiyQvh4mtrMoS3OAWW+yoYtpg==";
=======
        sha1 = "320fb8c7d15a344455cd33cee5ab63530b6dc7c5";
      };
    }
    {
      name = "debug___debug_2.6.9.tgz";
      path = fetchurl {
        name = "debug___debug_2.6.9.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz";
        sha1 = "5d128515df134ff327e90a4c93f4e077a536341f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "debug___debug_3.2.7.tgz";
      path = fetchurl {
        name = "debug___debug_3.2.7.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz";
<<<<<<< HEAD
        sha512 = "CFjzYYAi4ThfiQvizrFQevTTXHtnCqWfe7x1AhgEscTz6ZbLbfoLRLPugTQyBth6f8ZERVUSyWHFD/7Wu4t1XQ==";
      };
    }
    {
      name = "debug___debug_4.3.4.tgz";
      path = fetchurl {
        name = "debug___debug_4.3.4.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz";
        sha512 = "PRWFHuSU3eDtQJPvnNY7Jcket1j0t5OuOsFzPPzsekD52Zl8qUfFIPEiswXqIvHWGVHOgX+7G/vCNNhehwxfkQ==";
      };
    }
    {
      name = "decamelize_keys___decamelize_keys_1.1.1.tgz";
      path = fetchurl {
        name = "decamelize_keys___decamelize_keys_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/decamelize-keys/-/decamelize-keys-1.1.1.tgz";
        sha512 = "WiPxgEirIV0/eIOMcnFBA3/IJZAZqKnwAwWyvvdi4lsr1WCN22nhdf/3db3DoZcUjTV2SqfzIwNyp6y2xs3nmg==";
=======
        sha1 = "72580b7e9145fb39b6676f9c5e5fb100b934179a";
      };
    }
    {
      name = "debug___debug_4.3.3.tgz";
      path = fetchurl {
        name = "debug___debug_4.3.3.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-4.3.3.tgz";
        sha1 = "04266e0b70a98d4462e6e288e38259213332b664";
      };
    }
    {
      name = "decamelize_keys___decamelize_keys_1.1.0.tgz";
      path = fetchurl {
        name = "decamelize_keys___decamelize_keys_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/decamelize-keys/-/decamelize-keys-1.1.0.tgz";
        sha1 = "d171a87933252807eb3cb61dc1c1445d078df2d9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "decamelize___decamelize_1.2.0.tgz";
      path = fetchurl {
        name = "decamelize___decamelize_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz";
<<<<<<< HEAD
        sha512 = "z2S+W9X73hAUUki+N+9Za2lBlun89zigOyGrsax+KUQ6wKW4ZoWpEYBkGhQjwAjjDCkWxhY0VKEhk8wzY7F5cA==";
      };
    }
    {
      name = "deep_equal___deep_equal_2.2.1.tgz";
      path = fetchurl {
        name = "deep_equal___deep_equal_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/deep-equal/-/deep-equal-2.2.1.tgz";
        sha512 = "lKdkdV6EOGoVn65XaOsPdH4rMxTZOnmFyuIkMjM1i5HHCbfjC97dawgTAy0deYNfuqUqW+Q5VrVaQYtUpSd6yQ==";
=======
        sha1 = "f6534d15148269b20352e7bee26f501f9a191290";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "deep_is___deep_is_0.1.4.tgz";
      path = fetchurl {
        name = "deep_is___deep_is_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.4.tgz";
<<<<<<< HEAD
        sha512 = "oIPzksmTg4/MriiaYGO+okXDT7ztn/w3Eptv/+gSIdMdKsJo0u4CfYNFJPy+4SKMuCqGw2wxnA+URMg3t8a/bQ==";
      };
    }
    {
      name = "define_properties___define_properties_1.2.0.tgz";
      path = fetchurl {
        name = "define_properties___define_properties_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.0.tgz";
        sha512 = "xvqAVKGfT1+UAvPwKTVw/njhdQ8ZhXK4lI0bCIuCMrp2up9nPnaDftrLtmpTazqd1o+UY4zgzU+avtMbDP+ldA==";
      };
    }
    {
      name = "defined___defined_1.0.1.tgz";
      path = fetchurl {
        name = "defined___defined_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/defined/-/defined-1.0.1.tgz";
        sha512 = "hsBd2qSVCRE+5PmNdHt1uzyrFu5d3RwmFDKzyNZMFq/EwDNJF7Ee5+D5oEKF0hU6LhtoUF1macFvOe4AskQC1Q==";
      };
    }
    {
      name = "detective___detective_5.2.1.tgz";
      path = fetchurl {
        name = "detective___detective_5.2.1.tgz";
        url  = "https://registry.yarnpkg.com/detective/-/detective-5.2.1.tgz";
        sha512 = "v9XE1zRnz1wRtgurGu0Bs8uHKFSTdteYZNbIPFVhUZ39L/S79ppMpdmVOZAnoz1jfEFodc48n6MX483Xo3t1yw==";
=======
        sha1 = "a6f2dce612fadd2ef1f519b73551f17e85199831";
      };
    }
    {
      name = "define_properties___define_properties_1.1.3.tgz";
      path = fetchurl {
        name = "define_properties___define_properties_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/define-properties/-/define-properties-1.1.3.tgz";
        sha1 = "cf88da6cbee26fe6db7094f61d870cbd84cee9f1";
      };
    }
    {
      name = "defined___defined_1.0.0.tgz";
      path = fetchurl {
        name = "defined___defined_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/defined/-/defined-1.0.0.tgz";
        sha1 = "c98d9bcef75674188e110969151199e39b1fa693";
      };
    }
    {
      name = "detective___detective_5.2.0.tgz";
      path = fetchurl {
        name = "detective___detective_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/detective/-/detective-5.2.0.tgz";
        sha1 = "feb2a77e85b904ecdea459ad897cc90a99bd2a7b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "didyoumean___didyoumean_1.2.2.tgz";
      path = fetchurl {
        name = "didyoumean___didyoumean_1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/didyoumean/-/didyoumean-1.2.2.tgz";
<<<<<<< HEAD
        sha512 = "gxtyfqMg7GKyhQmb056K7M3xszy/myH8w+B4RT+QXBQsvAOdc3XymqDDPHx1BgPgsdAA5SIifona89YtRATDzw==";
=======
        sha1 = "989346ffe9e839b4555ecf5666edea0d3e8ad037";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "dir_glob___dir_glob_3.0.1.tgz";
      path = fetchurl {
        name = "dir_glob___dir_glob_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/dir-glob/-/dir-glob-3.0.1.tgz";
<<<<<<< HEAD
        sha512 = "WkrWp9GR4KXfKGYzOLmTuGVi1UWFfws377n9cc55/tb6DuqyF6pcQ5AbiHEshaDpY9v6oaSr2XCDidGmMwdzIA==";
=======
        sha1 = "56dbf73d992a4a93ba1584f4534063fd2e41717f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "dlv___dlv_1.1.3.tgz";
      path = fetchurl {
        name = "dlv___dlv_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/dlv/-/dlv-1.1.3.tgz";
<<<<<<< HEAD
        sha512 = "+HlytyjlPKnIG8XuRG8WvmBP8xs8P71y+SKKS6ZXWoEgLuePxtDoUEiH7WkdePWrQ5JBpE6aoVqfZfJUQkjXwA==";
=======
        sha1 = "5c198a8a11453596e751494d49874bc7732f2e79";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "doctrine___doctrine_2.1.0.tgz";
      path = fetchurl {
        name = "doctrine___doctrine_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz";
<<<<<<< HEAD
        sha512 = "35mSku4ZXK0vfCuHEDAwt55dg2jNajHZ1odvF+8SSr82EsZY4QmXfuWso8oEd8zRhVObSN18aM0CjSdoBX7zIw==";
=======
        sha1 = "5cd01fc101621b42c4cd7f5d1a66243716d3f39d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "doctrine___doctrine_3.0.0.tgz";
      path = fetchurl {
        name = "doctrine___doctrine_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "yS+Q5i3hBf7GBkd4KG8a7eBNNWNGLTaEwwYWUijIYM7zrlYDM0BFXHjjPWlWZ1Rg7UaddZeIDmi9jF3HmqiQ2w==";
=======
        sha1 = "addebead72a6574db783639dc87a121773973961";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "dom_helpers___dom_helpers_5.2.1.tgz";
      path = fetchurl {
        name = "dom_helpers___dom_helpers_5.2.1.tgz";
        url  = "https://registry.yarnpkg.com/dom-helpers/-/dom-helpers-5.2.1.tgz";
<<<<<<< HEAD
        sha512 = "nRCa7CK3VTrM2NmGkIy4cbK7IZlgBE/PYMn55rrXefr5xXDP0LdtfPnblFDoVdcAfslJ7or6iqAUnx0CCGIWQA==";
      };
    }
    {
      name = "dom_serializer___dom_serializer_1.4.1.tgz";
      path = fetchurl {
        name = "dom_serializer___dom_serializer_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-1.4.1.tgz";
        sha512 = "VHwB3KfrcOOkelEG2ZOfxqLZdfkil8PtJi4P8N2MMXucZq2yLp75ClViUlOVwyoHEDjYU433Aq+5zWP61+RGag==";
      };
    }
    {
      name = "domelementtype___domelementtype_2.3.0.tgz";
      path = fetchurl {
        name = "domelementtype___domelementtype_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/domelementtype/-/domelementtype-2.3.0.tgz";
        sha512 = "OLETBj6w0OsagBwdXnPdN0cnMfF9opN69co+7ZrbfPGrdpPVNBUj02spi6B1N7wChLQiPn4CSH/zJvXw56gmHw==";
      };
    }
    {
      name = "domhandler___domhandler_4.3.1.tgz";
      path = fetchurl {
        name = "domhandler___domhandler_4.3.1.tgz";
        url  = "https://registry.yarnpkg.com/domhandler/-/domhandler-4.3.1.tgz";
        sha512 = "GrwoxYN+uWlzO8uhUXRl0P+kHE4GtVPfYzVLcUxPL7KNdHKj66vvlhiweIHqYYXWlw+T8iLMp42Lm67ghw4WMQ==";
=======
        sha1 = "d9400536b2bf8225ad98fe052e029451ac40e902";
      };
    }
    {
      name = "dom_serializer___dom_serializer_0.2.2.tgz";
      path = fetchurl {
        name = "dom_serializer___dom_serializer_0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-0.2.2.tgz";
        sha1 = "1afb81f533717175d478655debc5e332d9f9bb51";
      };
    }
    {
      name = "dom_serializer___dom_serializer_1.3.2.tgz";
      path = fetchurl {
        name = "dom_serializer___dom_serializer_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-1.3.2.tgz";
        sha1 = "6206437d32ceefaec7161803230c7a20bc1b4d91";
      };
    }
    {
      name = "domelementtype___domelementtype_1.3.1.tgz";
      path = fetchurl {
        name = "domelementtype___domelementtype_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/domelementtype/-/domelementtype-1.3.1.tgz";
        sha1 = "d048c44b37b0d10a7f2a3d5fee3f4333d790481f";
      };
    }
    {
      name = "domelementtype___domelementtype_2.2.0.tgz";
      path = fetchurl {
        name = "domelementtype___domelementtype_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/domelementtype/-/domelementtype-2.2.0.tgz";
        sha1 = "9a0b6c2782ed6a1c7323d42267183df9bd8b1d57";
      };
    }
    {
      name = "domhandler___domhandler_2.4.2.tgz";
      path = fetchurl {
        name = "domhandler___domhandler_2.4.2.tgz";
        url  = "https://registry.yarnpkg.com/domhandler/-/domhandler-2.4.2.tgz";
        sha1 = "8805097e933d65e85546f726d60f5eb88b44f803";
      };
    }
    {
      name = "domhandler___domhandler_4.3.0.tgz";
      path = fetchurl {
        name = "domhandler___domhandler_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/domhandler/-/domhandler-4.3.0.tgz";
        sha1 = "16c658c626cf966967e306f966b431f77d4a5626";
      };
    }
    {
      name = "domutils___domutils_1.7.0.tgz";
      path = fetchurl {
        name = "domutils___domutils_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/domutils/-/domutils-1.7.0.tgz";
        sha1 = "56ea341e834e06e6748af7a1cb25da67ea9f8c2a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "domutils___domutils_2.8.0.tgz";
      path = fetchurl {
        name = "domutils___domutils_2.8.0.tgz";
        url  = "https://registry.yarnpkg.com/domutils/-/domutils-2.8.0.tgz";
<<<<<<< HEAD
        sha512 = "w96Cjofp72M5IIhpjgobBimYEfoPjx1Vx0BSX9P30WBdZW2WIKU0T1Bd0kz2eNZ9ikjKgHbEyKx8BB6H1L3h3A==";
      };
    }
    {
      name = "downshift___downshift_6.1.12.tgz";
      path = fetchurl {
        name = "downshift___downshift_6.1.12.tgz";
        url  = "https://registry.yarnpkg.com/downshift/-/downshift-6.1.12.tgz";
        sha512 = "7XB/iaSJVS4T8wGFT3WRXmSF1UlBHAA40DshZtkrIscIN+VC+Lh363skLxFTvJwtNgHxAMDGEHT4xsyQFWL+UA==";
=======
        sha1 = "4437def5db6e2d1f5d6ee859bd95ca7d02048135";
      };
    }
    {
      name = "downshift___downshift_6.1.7.tgz";
      path = fetchurl {
        name = "downshift___downshift_6.1.7.tgz";
        url  = "https://registry.yarnpkg.com/downshift/-/downshift-6.1.7.tgz";
        sha1 = "fdb4c4e4f1d11587985cd76e21e8b4b3fa72e44c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "duplexer2___duplexer2_0.1.4.tgz";
      path = fetchurl {
        name = "duplexer2___duplexer2_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/duplexer2/-/duplexer2-0.1.4.tgz";
<<<<<<< HEAD
        sha512 = "asLFVfWWtJ90ZyOUHMqk7/S2w2guQKxUI2itj3d92ADHhxUSbCMGi1f1cBcJ7xM1To+pE/Khbwo1yuNbMEPKeA==";
      };
    }
    {
      name = "duplexer___duplexer_0.1.1.tgz";
      path = fetchurl {
        name = "duplexer___duplexer_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/duplexer/-/duplexer-0.1.1.tgz";
        sha512 = "sxNZ+ljy+RA1maXoUReeqBBpBC6RLKmg5ewzV+x+mSETmWNoKdZN6vcQjpFROemza23hGFskJtFNoUWUaQ+R4Q==";
=======
        sha1 = "8b12dab878c0d69e3e7891051662a32fc6bddcc1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "duplexer___duplexer_0.1.2.tgz";
      path = fetchurl {
        name = "duplexer___duplexer_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/duplexer/-/duplexer-0.1.2.tgz";
<<<<<<< HEAD
        sha512 = "jtD6YG370ZCIi/9GTaJKQxWTZD045+4R4hTk/x1UyoqadyJ9x9CgSi1RlVDQF8U2sxLLSnFkCaMihqljHIWgMg==";
      };
    }
    {
      name = "electron_to_chromium___electron_to_chromium_1.4.377.tgz";
      path = fetchurl {
        name = "electron_to_chromium___electron_to_chromium_1.4.377.tgz";
        url  = "https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.4.377.tgz";
        sha512 = "H3BYG6DW5Z+l0xcfXaicJGxrpA4kMlCxnN71+iNX+dBLkRMOdVJqFJiAmbNZZKA1zISpRg17JR03qGifXNsJtw==";
=======
        sha1 = "3abe43aef3835f8ae077d136ddce0f276b0400e6";
      };
    }
    {
      name = "electron_to_chromium___electron_to_chromium_1.4.57.tgz";
      path = fetchurl {
        name = "electron_to_chromium___electron_to_chromium_1.4.57.tgz";
        url  = "https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.4.57.tgz";
        sha1 = "2b2766df76ac8dbc0a1d41249bc5684a31849892";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "emoji_regex___emoji_regex_8.0.0.tgz";
      path = fetchurl {
        name = "emoji_regex___emoji_regex_8.0.0.tgz";
        url  = "https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz";
<<<<<<< HEAD
        sha512 = "MSjYzcWNOA0ewAHpz0MxpYFvwg6yjy1NG3xteoqz644VCo/RPgnr1/GGt+ic3iJTzQ8Eu3TdM14SawnVUmGE6A==";
=======
        sha1 = "e818fd69ce5ccfcb404594f842963bf53164cc37";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "emoji_regex___emoji_regex_9.2.2.tgz";
      path = fetchurl {
        name = "emoji_regex___emoji_regex_9.2.2.tgz";
        url  = "https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-9.2.2.tgz";
<<<<<<< HEAD
        sha512 = "L18DaJsXSUk2+42pv8mLs5jJT2hqFkFE4j21wOmgbUqsZ2hL72NsUU785g9RXgo3s0ZNgVl42TiHp3ZtOv/Vyg==";
=======
        sha1 = "840c8803b0d8047f4ff0cf963176b32d4ef3ed72";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "emojis_list___emojis_list_3.0.0.tgz";
      path = fetchurl {
        name = "emojis_list___emojis_list_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/emojis-list/-/emojis-list-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "/kyM18EfinwXZbno9FyUGeFh87KC8HRQBQGildHZbEuRyWFOmv1U10o9BBp8XVZDVNNuQKyIGIu5ZYAAXJ0V2Q==";
      };
    }
    {
      name = "enhanced_resolve___enhanced_resolve_5.13.0.tgz";
      path = fetchurl {
        name = "enhanced_resolve___enhanced_resolve_5.13.0.tgz";
        url  = "https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-5.13.0.tgz";
        sha512 = "eyV8f0y1+bzyfh8xAwW/WTSZpLbjhqc4ne9eGSH4Zo2ejdyiNG9pU6mf9DG8a7+Auk6MFTlNOT4Y2y/9k8GKVg==";
=======
        sha1 = "5570662046ad29e2e916e71aae260abdff4f6a78";
      };
    }
    {
      name = "enhanced_resolve___enhanced_resolve_5.8.3.tgz";
      path = fetchurl {
        name = "enhanced_resolve___enhanced_resolve_5.8.3.tgz";
        url  = "https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-5.8.3.tgz";
        sha1 = "6d552d465cce0423f5b3d718511ea53826a7b2f0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "enquirer___enquirer_2.3.6.tgz";
      path = fetchurl {
        name = "enquirer___enquirer_2.3.6.tgz";
        url  = "https://registry.yarnpkg.com/enquirer/-/enquirer-2.3.6.tgz";
<<<<<<< HEAD
        sha512 = "yjNnPr315/FjS4zIsUxYguYUPP2e1NK4d7E7ZOLiyYCcbFBiTMyID+2wvm2w6+pZ/odMA7cRkjhsPbltwBOrLg==";
=======
        sha1 = "2a7fe5dd634a1e4125a975ec994ff5456dc3734d";
      };
    }
    {
      name = "entities___entities_1.1.2.tgz";
      path = fetchurl {
        name = "entities___entities_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/entities/-/entities-1.1.2.tgz";
        sha1 = "bdfa735299664dfafd34529ed4f8522a275fea56";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "entities___entities_2.2.0.tgz";
      path = fetchurl {
        name = "entities___entities_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/entities/-/entities-2.2.0.tgz";
<<<<<<< HEAD
        sha512 = "p92if5Nz619I0w+akJrLZH0MX0Pb5DX39XOwQTtXSdQQOaYH03S1uIQp4mhOZtAXrxq4ViO67YTiLBo2638o9A==";
=======
        sha1 = "098dc90ebb83d8dffa089d55256b351d34c4da55";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "envinfo___envinfo_7.8.1.tgz";
      path = fetchurl {
        name = "envinfo___envinfo_7.8.1.tgz";
        url  = "https://registry.yarnpkg.com/envinfo/-/envinfo-7.8.1.tgz";
<<<<<<< HEAD
        sha512 = "/o+BXHmB7ocbHEAs6F2EnG0ogybVVUdkRunTT2glZU9XAaGmhqskrvKwqXuDfNjEO0LZKWdejEEpnq8aM0tOaw==";
=======
        sha1 = "06377e3e5f4d379fea7ac592d5ad8927e0c4d475";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "error_ex___error_ex_1.3.2.tgz";
      path = fetchurl {
        name = "error_ex___error_ex_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz";
<<<<<<< HEAD
        sha512 = "7dFHNmqeFSEt2ZBsCriorKnn3Z2pj+fd9kmI6QoWw4//DL+icEBfc0U7qJCisqrTsKTjw4fNFy2pW9OqStD84g==";
      };
    }
    {
      name = "es_abstract___es_abstract_1.21.2.tgz";
      path = fetchurl {
        name = "es_abstract___es_abstract_1.21.2.tgz";
        url  = "https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.21.2.tgz";
        sha512 = "y/B5POM2iBnIxCiernH1G7rC9qQoM77lLIMQLuob0zhp8C56Po81+2Nj0WFKnd0pNReDTnkYryc+zhOzpEIROg==";
      };
    }
    {
      name = "es_get_iterator___es_get_iterator_1.1.3.tgz";
      path = fetchurl {
        name = "es_get_iterator___es_get_iterator_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/es-get-iterator/-/es-get-iterator-1.1.3.tgz";
        sha512 = "sPZmqHBe6JIiTfN5q2pEi//TwxmAFHwj/XEuYjTuse78i8KxaqMTTzxPoFKuzRpDpTJ+0NAbpfenkmH2rePtuw==";
=======
        sha1 = "b4ac40648107fdcdcfae242f428bea8a14d4f1bf";
      };
    }
    {
      name = "es_abstract___es_abstract_1.19.1.tgz";
      path = fetchurl {
        name = "es_abstract___es_abstract_1.19.1.tgz";
        url  = "https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.19.1.tgz";
        sha1 = "d4885796876916959de78edaa0df456627115ec3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "es_module_lexer___es_module_lexer_0.4.1.tgz";
      path = fetchurl {
        name = "es_module_lexer___es_module_lexer_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/es-module-lexer/-/es-module-lexer-0.4.1.tgz";
<<<<<<< HEAD
        sha512 = "ooYciCUtfw6/d2w56UVeqHPcoCFAiJdz5XOkYpv/Txl1HMUozpXjz/2RIQgqwKdXNDPSF1W7mJCFse3G+HDyAA==";
      };
    }
    {
      name = "es_set_tostringtag___es_set_tostringtag_2.0.1.tgz";
      path = fetchurl {
        name = "es_set_tostringtag___es_set_tostringtag_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz";
        sha512 = "g3OMbtlwY3QewlqAiMLI47KywjWZoEytKr8pf6iTC8uJq5bIAH52Z9pnQ8pVL6whrCto53JZDuUIsifGeLorTg==";
      };
    }
    {
      name = "es_shim_unscopables___es_shim_unscopables_1.0.0.tgz";
      path = fetchurl {
        name = "es_shim_unscopables___es_shim_unscopables_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/es-shim-unscopables/-/es-shim-unscopables-1.0.0.tgz";
        sha512 = "Jm6GPcCdC30eMLbZ2x8z2WuRwAws3zTBBKuusffYVUrNj/GVSUAZ+xKMaUpfNDR5IbyNA5LJbaecoUVbmUcB1w==";
=======
        sha1 = "dda8c6a14d8f340a24e34331e0fab0cb50438e0e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "es_to_primitive___es_to_primitive_1.2.1.tgz";
      path = fetchurl {
        name = "es_to_primitive___es_to_primitive_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz";
<<<<<<< HEAD
        sha512 = "QCOllgZJtaUo9miYBcLChTUaHNjJF3PYs1VidD7AwiEj1kYxKeQTctLAezAOH5ZKRH0g2IgPn6KwB4IT8iRpvA==";
=======
        sha1 = "e55cd4c9cdc188bcefb03b366c736323fc5c898a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "escalade___escalade_3.1.1.tgz";
      path = fetchurl {
        name = "escalade___escalade_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz";
<<<<<<< HEAD
        sha512 = "k0er2gUkLf8O0zKJiAhmkTnJlTvINGv7ygDNPbeIsX/TJjGJZHuh9B2UxbsaEkmlEo9MfhrSzmhIlhRlI2GXnw==";
=======
        sha1 = "d8cfdc7000965c5a0174b4a82eaa5c0552742e40";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "escape_string_regexp___escape_string_regexp_1.0.5.tgz";
      path = fetchurl {
        name = "escape_string_regexp___escape_string_regexp_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
<<<<<<< HEAD
        sha512 = "vbRorB5FUQWvla16U8R/qgaFIya2qGzwDrNmCZuYKrbdSUMG6I1ZCGQRefkRVhuOkIGVne7BQ35DSfo1qvJqFg==";
=======
        sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "escape_string_regexp___escape_string_regexp_4.0.0.tgz";
      path = fetchurl {
        name = "escape_string_regexp___escape_string_regexp_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "TtpcNJ3XAzx3Gq8sWRzJaVajRs0uVxA2YAkdb1jm2YkPz4G6egUFAyA3n5vtEIZefPk5Wa4UXbKuS5fKkJWdgA==";
=======
        sha1 = "14ba83a5d373e3d311e5afca29cf5bfad965bf34";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "escodegen___escodegen_1.14.3.tgz";
      path = fetchurl {
        name = "escodegen___escodegen_1.14.3.tgz";
        url  = "https://registry.yarnpkg.com/escodegen/-/escodegen-1.14.3.tgz";
<<<<<<< HEAD
        sha512 = "qFcX0XJkdg+PB3xjZZG/wKSuT1PnQWx57+TVSjIMmILd2yC/6ByYElPwJnslDsuWuSAp4AwJGumarAAmJch5Kw==";
=======
        sha1 = "4e7b81fba61581dc97582ed78cab7f0e8d63f503";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "escodegen___escodegen_1.9.1.tgz";
      path = fetchurl {
        name = "escodegen___escodegen_1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/escodegen/-/escodegen-1.9.1.tgz";
<<<<<<< HEAD
        sha512 = "6hTjO1NAWkHnDk3OqQ4YrCuwwmGHL9S3nPlzBOUG/R44rda3wLNrfvQ5fkSGjyhHFKM7ALPKcKGrwvCLe0lC7Q==";
=======
        sha1 = "dbae17ef96c8e4bedb1356f4504fa4cc2f7cb7e2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "eslint_config_prettier___eslint_config_prettier_7.2.0.tgz";
      path = fetchurl {
        name = "eslint_config_prettier___eslint_config_prettier_7.2.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-config-prettier/-/eslint-config-prettier-7.2.0.tgz";
<<<<<<< HEAD
        sha512 = "rV4Qu0C3nfJKPOAhFujFxB7RMP+URFyQqqOZW9DMRD7ZDTFyjaIlETU3xzHELt++4ugC0+Jm084HQYkkJe+Ivg==";
      };
    }
    {
      name = "eslint_import_resolver_node___eslint_import_resolver_node_0.3.7.tgz";
      path = fetchurl {
        name = "eslint_import_resolver_node___eslint_import_resolver_node_0.3.7.tgz";
        url  = "https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.7.tgz";
        sha512 = "gozW2blMLJCeFpBwugLTGyvVjNoeo1knonXAcatC6bjPBZitotxdWf7Gimr25N4c0AAOo4eOUfaG82IJPDpqCA==";
      };
    }
    {
      name = "eslint_module_utils___eslint_module_utils_2.8.0.tgz";
      path = fetchurl {
        name = "eslint_module_utils___eslint_module_utils_2.8.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.8.0.tgz";
        sha512 = "aWajIYfsqCKRDgUfjEXNN/JlrzauMuSEy5sbd7WXbtW3EH6A6MpwEh42c7qD+MqQo9QMJ6fWLAeIJynx0g6OAw==";
      };
    }
    {
      name = "eslint_plugin_import___eslint_plugin_import_2.27.5.tgz";
      path = fetchurl {
        name = "eslint_plugin_import___eslint_plugin_import_2.27.5.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.27.5.tgz";
        sha512 = "LmEt3GVofgiGuiE+ORpnvP+kAm3h6MLZJ4Q5HCyHADofsb4VzXFsRiWj3c0OFiV+3DWFh0qg3v9gcPlfc3zRow==";
      };
    }
    {
      name = "eslint_plugin_jsx_a11y___eslint_plugin_jsx_a11y_6.7.1.tgz";
      path = fetchurl {
        name = "eslint_plugin_jsx_a11y___eslint_plugin_jsx_a11y_6.7.1.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-jsx-a11y/-/eslint-plugin-jsx-a11y-6.7.1.tgz";
        sha512 = "63Bog4iIethyo8smBklORknVjB0T2dwB8Mr/hIC+fBS0uyHdYYpzM/Ed+YC8VxTjlXHEWFOdmgwcDn1U2L9VCA==";
=======
        sha1 = "f4a4bd2832e810e8cc7c1411ec85b3e85c0c53f9";
      };
    }
    {
      name = "eslint_import_resolver_node___eslint_import_resolver_node_0.3.6.tgz";
      path = fetchurl {
        name = "eslint_import_resolver_node___eslint_import_resolver_node_0.3.6.tgz";
        url  = "https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.6.tgz";
        sha1 = "4048b958395da89668252001dbd9eca6b83bacbd";
      };
    }
    {
      name = "eslint_module_utils___eslint_module_utils_2.7.3.tgz";
      path = fetchurl {
        name = "eslint_module_utils___eslint_module_utils_2.7.3.tgz";
        url  = "https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.7.3.tgz";
        sha1 = "ad7e3a10552fdd0642e1e55292781bd6e34876ee";
      };
    }
    {
      name = "eslint_plugin_import___eslint_plugin_import_2.25.4.tgz";
      path = fetchurl {
        name = "eslint_plugin_import___eslint_plugin_import_2.25.4.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.25.4.tgz";
        sha1 = "322f3f916a4e9e991ac7af32032c25ce313209f1";
      };
    }
    {
      name = "eslint_plugin_jsx_a11y___eslint_plugin_jsx_a11y_6.5.1.tgz";
      path = fetchurl {
        name = "eslint_plugin_jsx_a11y___eslint_plugin_jsx_a11y_6.5.1.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-jsx-a11y/-/eslint-plugin-jsx-a11y-6.5.1.tgz";
        sha1 = "cdbf2df901040ca140b6ec14715c988889c2a6d8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "eslint_plugin_prettier___eslint_plugin_prettier_3.4.1.tgz";
      path = fetchurl {
        name = "eslint_plugin_prettier___eslint_plugin_prettier_3.4.1.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-prettier/-/eslint-plugin-prettier-3.4.1.tgz";
<<<<<<< HEAD
        sha512 = "htg25EUYUeIhKHXjOinK4BgCcDwtLHjqaxCDsMy5nbnUMkKFvIhMVCp+5GFUXQ4Nr8lBsPqtGAqBenbpFqAA2g==";
      };
    }
    {
      name = "eslint_plugin_react_hooks___eslint_plugin_react_hooks_4.6.0.tgz";
      path = fetchurl {
        name = "eslint_plugin_react_hooks___eslint_plugin_react_hooks_4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-react-hooks/-/eslint-plugin-react-hooks-4.6.0.tgz";
        sha512 = "oFc7Itz9Qxh2x4gNHStv3BqJq54ExXmfC+a1NjAta66IAN87Wu0R/QArgIS9qKzX3dXKPI9H5crl9QchNMY9+g==";
      };
    }
    {
      name = "eslint_plugin_react___eslint_plugin_react_7.32.2.tgz";
      path = fetchurl {
        name = "eslint_plugin_react___eslint_plugin_react_7.32.2.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-react/-/eslint-plugin-react-7.32.2.tgz";
        sha512 = "t2fBMa+XzonrrNkyVirzKlvn5RXzzPwRHtMvLAtVZrt8oxgnTQaYbU6SXTOO1mwQgp1y5+toMSKInnzGr0Knqg==";
=======
        sha1 = "e9ddb200efb6f3d05ffe83b1665a716af4a387e5";
      };
    }
    {
      name = "eslint_plugin_react_hooks___eslint_plugin_react_hooks_4.3.0.tgz";
      path = fetchurl {
        name = "eslint_plugin_react_hooks___eslint_plugin_react_hooks_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-react-hooks/-/eslint-plugin-react-hooks-4.3.0.tgz";
        sha1 = "318dbf312e06fab1c835a4abef00121751ac1172";
      };
    }
    {
      name = "eslint_plugin_react___eslint_plugin_react_7.28.0.tgz";
      path = fetchurl {
        name = "eslint_plugin_react___eslint_plugin_react_7.28.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-plugin-react/-/eslint-plugin-react-7.28.0.tgz";
        sha1 = "8f3ff450677571a659ce76efc6d80b6a525adbdf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "eslint_scope___eslint_scope_5.1.1.tgz";
      path = fetchurl {
        name = "eslint_scope___eslint_scope_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz";
<<<<<<< HEAD
        sha512 = "2NxwbF/hZ0KpepYN0cNbo+FN6XoK7GaHlQhgx/hIZl6Va0bF45RQOOwhLIy8lQDbuCiadSLCBnH2CFYquit5bw==";
=======
        sha1 = "e786e59a66cb92b3f6c1fb0d508aab174848f48c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "eslint_utils___eslint_utils_2.1.0.tgz";
      path = fetchurl {
        name = "eslint_utils___eslint_utils_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-2.1.0.tgz";
<<<<<<< HEAD
        sha512 = "w94dQYoauyvlDc43XnGB8lU3Zt713vNChgt4EWwhXAP2XkBvndfxF0AgIqKOOasjPIPzj9JqgwkwbCYD0/V3Zg==";
=======
        sha1 = "d2de5e03424e707dc10c74068ddedae708741b27";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "eslint_visitor_keys___eslint_visitor_keys_1.3.0.tgz";
      path = fetchurl {
        name = "eslint_visitor_keys___eslint_visitor_keys_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz";
<<<<<<< HEAD
        sha512 = "6J72N8UNa462wa/KFODt/PJ3IU60SDpC3QXC1Hjc1BXXpfL2C9R5+AU7jhe0F6GREqVMh4Juu+NY7xn+6dipUQ==";
=======
        sha1 = "30ebd1ef7c2fdff01c3a4f151044af25fab0523e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "eslint_visitor_keys___eslint_visitor_keys_2.1.0.tgz";
      path = fetchurl {
        name = "eslint_visitor_keys___eslint_visitor_keys_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-2.1.0.tgz";
<<<<<<< HEAD
        sha512 = "0rSmRBzXgDzIsD6mGdJgevzgezI534Cer5L/vyMX0kHzT/jiB43jRhd9YUlMGYLQy2zprNmoT8qasCGtY+QaKw==";
=======
        sha1 = "f65328259305927392c938ed44eb0a5c9b2bd303";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "eslint___eslint_7.32.0.tgz";
      path = fetchurl {
        name = "eslint___eslint_7.32.0.tgz";
        url  = "https://registry.yarnpkg.com/eslint/-/eslint-7.32.0.tgz";
<<<<<<< HEAD
        sha512 = "VHZ8gX+EDfz+97jGcgyGCyRia/dPOd6Xh9yPv8Bl1+SoaIwD+a/vlrOmGRUyOYu7MwUhc7CxqeaDZU13S4+EpA==";
=======
        sha1 = "c6d328a14be3fb08c8d1d21e12c02fdb7a2a812d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "espree___espree_7.3.1.tgz";
      path = fetchurl {
        name = "espree___espree_7.3.1.tgz";
        url  = "https://registry.yarnpkg.com/espree/-/espree-7.3.1.tgz";
<<<<<<< HEAD
        sha512 = "v3JCNCE64umkFpmkFGqzVKsOT0tN1Zr+ueqLZfpV1Ob8e+CEgPWa+OxCoGH3tnhimMKIaBm4m/vaRpJ/krRz2g==";
=======
        sha1 = "f2df330b752c6f55019f8bd89b7660039c1bbbb6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "esprima___esprima_3.1.3.tgz";
      path = fetchurl {
        name = "esprima___esprima_3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-3.1.3.tgz";
<<<<<<< HEAD
        sha512 = "AWwVMNxwhN8+NIPQzAQZCm7RkLC4RbM3B1OobMuyp3i+w73X57KCKaVIxaRZb+DYCojq7rspo+fmuQfAboyhFg==";
=======
        sha1 = "fdca51cee6133895e3c88d535ce49dbff62a4633";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "esprima___esprima_4.0.1.tgz";
      path = fetchurl {
        name = "esprima___esprima_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz";
<<<<<<< HEAD
        sha512 = "eGuFFw7Upda+g4p+QHvnW0RyTX/SVeJBDM/gCtMARO0cLuT2HcEKnTPvhjV6aGeqrCB/sbNop0Kszm0jsaWU4A==";
      };
    }
    {
      name = "esquery___esquery_1.5.0.tgz";
      path = fetchurl {
        name = "esquery___esquery_1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/esquery/-/esquery-1.5.0.tgz";
        sha512 = "YQLXUplAwJgCydQ78IMJywZCceoqk1oH01OERdSAJc/7U2AylwjhSCLDEtqwg811idIS/9fIU5GjG73IgjKMVg==";
=======
        sha1 = "13b04cdb3e6c5d19df91ab6987a8695619b0aa71";
      };
    }
    {
      name = "esquery___esquery_1.4.0.tgz";
      path = fetchurl {
        name = "esquery___esquery_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/esquery/-/esquery-1.4.0.tgz";
        sha1 = "2148ffc38b82e8c7057dfed48425b3e61f0f24a5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "esrecurse___esrecurse_4.3.0.tgz";
      path = fetchurl {
        name = "esrecurse___esrecurse_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz";
<<<<<<< HEAD
        sha512 = "KmfKL3b6G+RXvP8N1vr3Tq1kL/oCFgn2NYXEtqP8/L3pKapUA4G8cFVaoF3SU323CD4XypR/ffioHmkti6/Tag==";
=======
        sha1 = "7ad7964d679abb28bee72cec63758b1c5d2c9921";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "estraverse___estraverse_4.3.0.tgz";
      path = fetchurl {
        name = "estraverse___estraverse_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz";
<<<<<<< HEAD
        sha512 = "39nnKffWz8xN1BU/2c79n9nB9HDzo0niYUqx6xyqUnyoAnQyyWpOTdZEeiCch8BBu515t4wp9ZmgVfVhn9EBpw==";
=======
        sha1 = "398ad3f3c5a24948be7725e83d11a7de28cdbd1d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "estraverse___estraverse_5.3.0.tgz";
      path = fetchurl {
        name = "estraverse___estraverse_5.3.0.tgz";
        url  = "https://registry.yarnpkg.com/estraverse/-/estraverse-5.3.0.tgz";
<<<<<<< HEAD
        sha512 = "MMdARuVEQziNTeJD8DgMqmhwR11BRQ/cBP+pLtYdSTnf3MIO8fFeiINEbX36ZdNlfU/7A9f3gUw49B3oQsvwBA==";
=======
        sha1 = "2eea5290702f26ab8fe5370370ff86c965d21123";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "esutils___esutils_2.0.3.tgz";
      path = fetchurl {
        name = "esutils___esutils_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz";
<<<<<<< HEAD
        sha512 = "kVscqXk4OCp68SZ0dkgEKVi6/8ij300KBWTJq32P/dYeWTSwK41WyTxalN1eRmA5Z9UU/LX9D7FWSmV9SAYx6g==";
=======
        sha1 = "74d2eb4de0b8da1293711910d50775b9b710ef64";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "events___events_3.3.0.tgz";
      path = fetchurl {
        name = "events___events_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/events/-/events-3.3.0.tgz";
<<<<<<< HEAD
        sha512 = "mQw+2fkQbALzQ7V0MY0IqdnXNOeTtP4r0lN9z7AAawCXgqea7bDii20AYrIBrFd/Hx0M2Ocz6S111CaFkUcb0Q==";
      };
    }
    {
      name = "falafel___falafel_2.2.5.tgz";
      path = fetchurl {
        name = "falafel___falafel_2.2.5.tgz";
        url  = "https://registry.yarnpkg.com/falafel/-/falafel-2.2.5.tgz";
        sha512 = "HuC1qF9iTnHDnML9YZAdCDQwT0yKl/U55K4XSUXqGAA2GLoafFgWRqdAbhWJxXaYD4pyoVxAJ8wH670jMpI9DQ==";
=======
        sha1 = "31a95ad0a924e2d2c419a813aeb2c4e878ea7400";
      };
    }
    {
      name = "execa___execa_5.1.1.tgz";
      path = fetchurl {
        name = "execa___execa_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-5.1.1.tgz";
        sha1 = "f80ad9cbf4298f7bd1d4c9555c21e93741c411dd";
      };
    }
    {
      name = "execall___execall_2.0.0.tgz";
      path = fetchurl {
        name = "execall___execall_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/execall/-/execall-2.0.0.tgz";
        sha1 = "16a06b5fe5099df7d00be5d9c06eecded1663b45";
      };
    }
    {
      name = "extend___extend_3.0.2.tgz";
      path = fetchurl {
        name = "extend___extend_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz";
        sha1 = "f8b1136b4071fbd8eb140aff858b1019ec2915fa";
      };
    }
    {
      name = "falafel___falafel_2.2.4.tgz";
      path = fetchurl {
        name = "falafel___falafel_2.2.4.tgz";
        url  = "https://registry.yarnpkg.com/falafel/-/falafel-2.2.4.tgz";
        sha1 = "b5d86c060c2412a43166243cb1bce44d1abd2819";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "fast_deep_equal___fast_deep_equal_3.1.3.tgz";
      path = fetchurl {
        name = "fast_deep_equal___fast_deep_equal_3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz";
<<<<<<< HEAD
        sha512 = "f3qQ9oQy9j2AhBe/H9VC91wLmKBCCU/gDOnKNAYG5hswO7BLKj09Hc5HYNz9cGI++xlpDCIgDaitVs03ATR84Q==";
=======
        sha1 = "3a7d56b559d6cbc3eb512325244e619a65c6c525";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "fast_diff___fast_diff_1.2.0.tgz";
      path = fetchurl {
        name = "fast_diff___fast_diff_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-diff/-/fast-diff-1.2.0.tgz";
<<<<<<< HEAD
        sha512 = "xJuoT5+L99XlZ8twedaRf6Ax2TgQVxvgZOYoPKqZufmJib0tL2tegPBOZb1pVNgIhlqDlA0eO0c3wBvQcmzx4w==";
      };
    }
    {
      name = "fast_glob___fast_glob_3.2.12.tgz";
      path = fetchurl {
        name = "fast_glob___fast_glob_3.2.12.tgz";
        url  = "https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.2.12.tgz";
        sha512 = "DVj4CQIYYow0BlaelwK1pHl5n5cRSJfM60UA0zK891sVInoPri2Ekj7+e1CT3/3qxXenpI+nBBmQAcJPJgaj4w==";
=======
        sha1 = "73ee11982d86caaf7959828d519cfe927fac5f03";
      };
    }
    {
      name = "fast_glob___fast_glob_3.2.11.tgz";
      path = fetchurl {
        name = "fast_glob___fast_glob_3.2.11.tgz";
        url  = "https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.2.11.tgz";
        sha1 = "a1172ad95ceb8a16e20caa5c5e56480e5129c1d9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "fast_json_stable_stringify___fast_json_stable_stringify_2.1.0.tgz";
      path = fetchurl {
        name = "fast_json_stable_stringify___fast_json_stable_stringify_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz";
<<<<<<< HEAD
        sha512 = "lhd/wF+Lk98HZoTCtlVraHtfh5XYijIjalXck7saUtuanSDyLMxnHhSXEDJqHxD7msR8D0uCmqlkwjCV8xvwHw==";
=======
        sha1 = "874bf69c6f404c2b5d99c481341399fd55892633";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "fast_levenshtein___fast_levenshtein_2.0.6.tgz";
      path = fetchurl {
        name = "fast_levenshtein___fast_levenshtein_2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz";
<<<<<<< HEAD
        sha512 = "DCXu6Ifhqcks7TZKY3Hxp3y6qphY5SJZmrWMDrKcERSOXWQdMhU9Ig/PYrzyw/ul9jOIyh0N4M0tbC5hodg8dw==";
      };
    }
    {
      name = "fastest_levenshtein___fastest_levenshtein_1.0.16.tgz";
      path = fetchurl {
        name = "fastest_levenshtein___fastest_levenshtein_1.0.16.tgz";
        url  = "https://registry.yarnpkg.com/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz";
        sha512 = "eRnCtTTtGZFpQCwhJiUOuxPQWRXVKYDn0b2PeHfXL6/Zi53SLAzAHfVhVWK2AryC/WH05kGfxhFIPvTF0SXQzg==";
      };
    }
    {
      name = "fastq___fastq_1.15.0.tgz";
      path = fetchurl {
        name = "fastq___fastq_1.15.0.tgz";
        url  = "https://registry.yarnpkg.com/fastq/-/fastq-1.15.0.tgz";
        sha512 = "wBrocU2LCXXa+lWBt8RoIRD89Fi8OdABODa/kEnyeyjS5aZO5/GNvI5sEINADqP/h8M29UHTHUb53sUu5Ihqdw==";
=======
        sha1 = "3d8a5c66883a16a30ca8643e851f19baa7797917";
      };
    }
    {
      name = "fastest_levenshtein___fastest_levenshtein_1.0.12.tgz";
      path = fetchurl {
        name = "fastest_levenshtein___fastest_levenshtein_1.0.12.tgz";
        url  = "https://registry.yarnpkg.com/fastest-levenshtein/-/fastest-levenshtein-1.0.12.tgz";
        sha1 = "9990f7d3a88cc5a9ffd1f1745745251700d497e2";
      };
    }
    {
      name = "fastq___fastq_1.13.0.tgz";
      path = fetchurl {
        name = "fastq___fastq_1.13.0.tgz";
        url  = "https://registry.yarnpkg.com/fastq/-/fastq-1.13.0.tgz";
        sha1 = "616760f88a7526bdfc596b7cab8c18938c36b98c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "file_entry_cache___file_entry_cache_6.0.1.tgz";
      path = fetchurl {
        name = "file_entry_cache___file_entry_cache_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.1.tgz";
<<<<<<< HEAD
        sha512 = "7Gps/XWymbLk2QLYK4NzpMOrYjMhdIxXuIvy2QBsLE6ljuodKvdkWs/cpyJJ3CVIVpH0Oi1Hvg1ovbMzLdFBBg==";
=======
        sha1 = "211b2dd9659cb0394b073e7323ac3c933d522027";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "fill_range___fill_range_7.0.1.tgz";
      path = fetchurl {
        name = "fill_range___fill_range_7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz";
<<<<<<< HEAD
        sha512 = "qOo9F+dMUmC2Lcb4BbVvnKJxTPjCm+RRpe4gDuGrzkL7mEVl/djYSu2OdQ2Pa302N4oqkSg9ir6jaLWJ2USVpQ==";
=======
        sha1 = "1919a6a7c75fe38b2c7c77e5198535da9acdda40";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "find_cache_dir___find_cache_dir_3.3.2.tgz";
      path = fetchurl {
        name = "find_cache_dir___find_cache_dir_3.3.2.tgz";
        url  = "https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-3.3.2.tgz";
<<<<<<< HEAD
        sha512 = "wXZV5emFEjrridIgED11OoUKLxiYjAcqot/NJdAkOhlJ+vGzwhOAfcG5OX1jP+S0PcjEn8bdMJv+g2jwQ3Onig==";
=======
        sha1 = "b30c5b6eff0730731aea9bbd9dbecbd80256d64b";
      };
    }
    {
      name = "find_up___find_up_2.1.0.tgz";
      path = fetchurl {
        name = "find_up___find_up_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz";
        sha1 = "45d1b7e506c717ddd482775a2b77920a3c0c57a7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "find_up___find_up_4.1.0.tgz";
      path = fetchurl {
        name = "find_up___find_up_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz";
<<<<<<< HEAD
        sha512 = "PpOwAdQ/YlXQ2vj8a3h8IipDuYRi3wceVQQGYWxNINccq40Anw7BlsEXCMbt1Zt+OLA6Fq9suIpIWD0OsnISlw==";
=======
        sha1 = "97afe7d6cdc0bc5928584b7c8d7b16e8a9aa5d19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "flat_cache___flat_cache_3.0.4.tgz";
      path = fetchurl {
        name = "flat_cache___flat_cache_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/flat-cache/-/flat-cache-3.0.4.tgz";
<<<<<<< HEAD
        sha512 = "dm9s5Pw7Jc0GvMYbshN6zchCA9RgQlzzEZX3vylR9IqFfS8XciblUXOKfW6SiuJ0e13eDYZoZV5wdrev7P3Nwg==";
      };
    }
    {
      name = "flatpickr___flatpickr_4.6.13.tgz";
      path = fetchurl {
        name = "flatpickr___flatpickr_4.6.13.tgz";
        url  = "https://registry.yarnpkg.com/flatpickr/-/flatpickr-4.6.13.tgz";
        sha512 = "97PMG/aywoYpB4IvbvUJi0RQi8vearvU0oov1WW3k0WZPBMrTQVqekSX5CjSG/M4Q3i6A/0FKXC7RyAoAUUSPw==";
      };
    }
    {
      name = "flatted___flatted_3.2.7.tgz";
      path = fetchurl {
        name = "flatted___flatted_3.2.7.tgz";
        url  = "https://registry.yarnpkg.com/flatted/-/flatted-3.2.7.tgz";
        sha512 = "5nqDSxl8nn5BSNxyR3n4I6eDmbolI6WT+QqR547RwxQapgjQBmtktdP+HTBb/a/zLsbzERTONyUB5pefh5TtjQ==";
      };
    }
    {
      name = "follow_redirects___follow_redirects_1.15.2.tgz";
      path = fetchurl {
        name = "follow_redirects___follow_redirects_1.15.2.tgz";
        url  = "https://registry.yarnpkg.com/follow-redirects/-/follow-redirects-1.15.2.tgz";
        sha512 = "VQLG33o04KaQ8uYi2tVNbdrWp1QWxNNea+nmIB4EVM28v0hmP17z7aG1+wAkNzVq4KeXTq3221ye5qTJP91JwA==";
      };
    }
    {
      name = "for_each___for_each_0.3.3.tgz";
      path = fetchurl {
        name = "for_each___for_each_0.3.3.tgz";
        url  = "https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz";
        sha512 = "jqYfLp7mo9vIyQf8ykW2v7A+2N4QjeCeI5+Dz9XraiO1ign81wjiH7Fb9vSOWvQfNtmSa4H2RoQTrrXivdUZmw==";
      };
    }
    {
      name = "fraction.js___fraction.js_4.2.0.tgz";
      path = fetchurl {
        name = "fraction.js___fraction.js_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/fraction.js/-/fraction.js-4.2.0.tgz";
        sha512 = "MhLuK+2gUcnZe8ZHlaaINnQLl0xRIGRfcGk2yl8xoQAfHrSsL3rYu6FCmBdkdbhc9EPlwyGHewaRsvwRMJtAlA==";
      };
    }
    {
      name = "fs_extra___fs_extra_10.1.0.tgz";
      path = fetchurl {
        name = "fs_extra___fs_extra_10.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.1.0.tgz";
        sha512 = "oRXApq54ETRj4eMiFzGnHWGy+zo5raudjuxN0b8H7s/RU2oW0Wvsx9O0ACRN/kRq9E8Vu/ReskGB5o3ji+FzHQ==";
=======
        sha1 = "61b0338302b2fe9f957dcc32fc2a87f1c3048b11";
      };
    }
    {
      name = "flatpickr___flatpickr_4.6.9.tgz";
      path = fetchurl {
        name = "flatpickr___flatpickr_4.6.9.tgz";
        url  = "https://registry.yarnpkg.com/flatpickr/-/flatpickr-4.6.9.tgz";
        sha1 = "9a13383e8a6814bda5d232eae3fcdccb97dc1499";
      };
    }
    {
      name = "flatted___flatted_3.2.5.tgz";
      path = fetchurl {
        name = "flatted___flatted_3.2.5.tgz";
        url  = "https://registry.yarnpkg.com/flatted/-/flatted-3.2.5.tgz";
        sha1 = "76c8584f4fc843db64702a6bd04ab7a8bd666da3";
      };
    }
    {
      name = "foreach___foreach_2.0.5.tgz";
      path = fetchurl {
        name = "foreach___foreach_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/foreach/-/foreach-2.0.5.tgz";
        sha1 = "0bee005018aeb260d0a3af3ae658dd0136ec1b99";
      };
    }
    {
      name = "fraction.js___fraction.js_4.1.2.tgz";
      path = fetchurl {
        name = "fraction.js___fraction.js_4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/fraction.js/-/fraction.js-4.1.2.tgz";
        sha1 = "13e420a92422b6cf244dff8690ed89401029fbe8";
      };
    }
    {
      name = "fs_extra___fs_extra_10.0.0.tgz";
      path = fetchurl {
        name = "fs_extra___fs_extra_10.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.0.0.tgz";
        sha1 = "9ff61b655dde53fb34a82df84bb214ce802e17c1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "fs.realpath___fs.realpath_1.0.0.tgz";
      path = fetchurl {
        name = "fs.realpath___fs.realpath_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "OO0pH2lK6a0hZnAdau5ItzHPI6pUlvI7jMVnxUQRtw4owF2wk8lOSabtGDCTP4Ggrg2MbGnWO9X8K1t4+fGMDw==";
=======
        sha1 = "1504ad2523158caa40db4a2787cb01411994ea4f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "fsevents___fsevents_2.3.2.tgz";
      path = fetchurl {
        name = "fsevents___fsevents_2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz";
<<<<<<< HEAD
        sha512 = "xiqMQR4xAeHTuB9uWm+fFRcIOgKBMiOBP+eXiyT7jsgVCq1bkVygt00oASowB7EdtpOHaaPgKt812P9ab+DDKA==";
=======
        sha1 = "8a526f78b8fdf4623b709e0b975c52c24c02fd1a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "function_bind___function_bind_1.1.1.tgz";
      path = fetchurl {
        name = "function_bind___function_bind_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz";
<<<<<<< HEAD
        sha512 = "yIovAzMX49sF8Yl58fSCWJ5svSLuaibPxXQJFLmBObTuCr0Mf1KiPopGM9NiFjiYBCbfaa2Fh6breQ6ANVTI0A==";
      };
    }
    {
      name = "function.prototype.name___function.prototype.name_1.1.5.tgz";
      path = fetchurl {
        name = "function.prototype.name___function.prototype.name_1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.5.tgz";
        sha512 = "uN7m/BzVKQnCUF/iW8jYea67v++2u7m5UgENbHRtdDVclOUP+FMPlCNdmk0h/ysGyo2tavMJEDqJAkJdRa1vMA==";
=======
        sha1 = "a56899d3ea3c9bab874bb9773b7c5ede92f4895d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "functional_red_black_tree___functional_red_black_tree_1.0.1.tgz";
      path = fetchurl {
        name = "functional_red_black_tree___functional_red_black_tree_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz";
<<<<<<< HEAD
        sha512 = "dsKNQNdj6xA3T+QlADDA7mOSlX0qiMINjn0cgr+eGHGsbSHzTabcIogz2+p/iqP1Xs6EP/sS2SbqH+brGTbq0g==";
      };
    }
    {
      name = "functions_have_names___functions_have_names_1.2.3.tgz";
      path = fetchurl {
        name = "functions_have_names___functions_have_names_1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/functions-have-names/-/functions-have-names-1.2.3.tgz";
        sha512 = "xckBUXyTIqT97tq2x2AMb+g163b5JFysYk0x4qxNFwbfQkmNZoiRHb6sPzI9/QV33WeuvVYBUIiD4NzNIyqaRQ==";
=======
        sha1 = "1b0ab3bd553b2a0d6399d29c0e3ea0b252078327";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "gensync___gensync_1.0.0_beta.2.tgz";
      path = fetchurl {
        name = "gensync___gensync_1.0.0_beta.2.tgz";
        url  = "https://registry.yarnpkg.com/gensync/-/gensync-1.0.0-beta.2.tgz";
<<<<<<< HEAD
        sha512 = "3hN7NaskYvMDLQY55gnW3NQ+mesEAepTqlg+VEbj7zzqEMBVNhzcGYYeqFo/TlYz6eQiFcp1HcsCZO+nGgS8zg==";
      };
    }
    {
      name = "get_intrinsic___get_intrinsic_1.2.0.tgz";
      path = fetchurl {
        name = "get_intrinsic___get_intrinsic_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.0.tgz";
        sha512 = "L049y6nFOuom5wGyRc3/gdTLO94dySVKRACj1RmJZBQXlbTMhtNIgkWkUHq+jYmZvKf14EW1EoJnnjbmoHij0Q==";
=======
        sha1 = "32a6ee76c3d7f52d46b2b1ae5d93fea8580a25e0";
      };
    }
    {
      name = "get_intrinsic___get_intrinsic_1.1.1.tgz";
      path = fetchurl {
        name = "get_intrinsic___get_intrinsic_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.1.1.tgz";
        sha1 = "15f59f376f855c446963948f0d24cd3637b4abc6";
      };
    }
    {
      name = "get_stdin___get_stdin_8.0.0.tgz";
      path = fetchurl {
        name = "get_stdin___get_stdin_8.0.0.tgz";
        url  = "https://registry.yarnpkg.com/get-stdin/-/get-stdin-8.0.0.tgz";
        sha1 = "cbad6a73feb75f6eeb22ba9e01f89aa28aa97a53";
      };
    }
    {
      name = "get_stream___get_stream_6.0.1.tgz";
      path = fetchurl {
        name = "get_stream___get_stream_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-6.0.1.tgz";
        sha1 = "a262d8eef67aced57c2852ad6167526a43cbf7b7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "get_symbol_description___get_symbol_description_1.0.0.tgz";
      path = fetchurl {
        name = "get_symbol_description___get_symbol_description_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "2EmdH1YvIQiZpltCNgkuiUnyukzxM/R6NDJX31Ke3BG1Nq5b0S2PhX59UKi9vZpPDQVdqn+1IcaAwnzTT5vCjw==";
=======
        sha1 = "7fdb81c900101fbd564dd5f1a30af5aadc1e58d6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "glob_parent___glob_parent_5.1.2.tgz";
      path = fetchurl {
        name = "glob_parent___glob_parent_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz";
<<<<<<< HEAD
        sha512 = "AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==";
=======
        sha1 = "869832c58034fe68a4093c17dc15e8340d8401c4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "glob_parent___glob_parent_6.0.2.tgz";
      path = fetchurl {
        name = "glob_parent___glob_parent_6.0.2.tgz";
        url  = "https://registry.yarnpkg.com/glob-parent/-/glob-parent-6.0.2.tgz";
<<<<<<< HEAD
        sha512 = "XxwI8EOhVQgWp6iDL+3b0r86f4d6AX6zSU55HfB4ydCEuXLXc5FcYeOu+nnGftS4TEju/11rt4KJPTMgbfmv4A==";
=======
        sha1 = "6d237d99083950c79290f24c7642a3de9a28f9e3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "glob_to_regexp___glob_to_regexp_0.4.1.tgz";
      path = fetchurl {
        name = "glob_to_regexp___glob_to_regexp_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz";
<<<<<<< HEAD
        sha512 = "lkX1HJXwyMcprw/5YUZc2s7DrpAiHB21/V+E1rHUrVNokkvB6bqMzT0VfV6/86ZNabt1k14YOIaT7nDvOX3Iiw==";
      };
    }
    {
      name = "glob___glob_7.2.3.tgz";
      path = fetchurl {
        name = "glob___glob_7.2.3.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz";
        sha512 = "nFR0zLpU2YCaRxwoCJvL6UvCH2JFyFVIvwTLsIf21AuHlMskA1hhTdk+LlYJtOlYt9v6dvszD2BGRqBL+iQK9Q==";
=======
        sha1 = "c75297087c851b9a578bd217dd59a92f59fe546e";
      };
    }
    {
      name = "glob___glob_7.2.0.tgz";
      path = fetchurl {
        name = "glob___glob_7.2.0.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.2.0.tgz";
        sha1 = "d15535af7732e02e948f4c41628bd910293f6023";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "global_modules___global_modules_2.0.0.tgz";
      path = fetchurl {
        name = "global_modules___global_modules_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/global-modules/-/global-modules-2.0.0.tgz";
<<<<<<< HEAD
        sha512 = "NGbfmJBp9x8IxyJSd1P+otYK8vonoJactOogrVfFRIAEY1ukil8RSKDz2Yo7wh1oihl51l/r6W4epkeKJHqL8A==";
=======
        sha1 = "997605ad2345f27f51539bea26574421215c7780";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "global_prefix___global_prefix_3.0.0.tgz";
      path = fetchurl {
        name = "global_prefix___global_prefix_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/global-prefix/-/global-prefix-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "awConJSVCHVGND6x3tmMaKcQvwXLhjdkmomy2W+Goaui8YPgYgXJZewhg3fWC+DlfqqQuWg8AwqjGTD2nAPVWg==";
=======
        sha1 = "fc85f73064df69f50421f47f883fe5b913ba9b97";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "globals___globals_11.12.0.tgz";
      path = fetchurl {
        name = "globals___globals_11.12.0.tgz";
        url  = "https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz";
<<<<<<< HEAD
        sha512 = "WOBp/EEGUiIsJSp7wcv/y6MO+lV9UoncWqxuFfm8eBwzWNgyfBd6Gz+IeKQ9jCmyhoH99g15M3T+QaVHFjizVA==";
      };
    }
    {
      name = "globals___globals_13.20.0.tgz";
      path = fetchurl {
        name = "globals___globals_13.20.0.tgz";
        url  = "https://registry.yarnpkg.com/globals/-/globals-13.20.0.tgz";
        sha512 = "Qg5QtVkCy/kv3FUSlu4ukeZDVf9ee0iXLAUYX13gbR17bnejFTzr4iS9bY7kwCf1NztRNm1t91fjOiyx4CSwPQ==";
      };
    }
    {
      name = "globalthis___globalthis_1.0.3.tgz";
      path = fetchurl {
        name = "globalthis___globalthis_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz";
        sha512 = "sFdI5LyBiNTHjRd7cGPWapiHWMOXKyuBNX/cWJ3NfzrZQVa8GI/8cofCl74AOVqq9W5kNmguTIzJ/1s2gyI9wA==";
=======
        sha1 = "ab8795338868a0babd8525758018c2a7eb95c42e";
      };
    }
    {
      name = "globals___globals_13.12.0.tgz";
      path = fetchurl {
        name = "globals___globals_13.12.0.tgz";
        url  = "https://registry.yarnpkg.com/globals/-/globals-13.12.0.tgz";
        sha1 = "4d733760304230a0082ed96e21e5c565f898089e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "globby___globby_11.1.0.tgz";
      path = fetchurl {
        name = "globby___globby_11.1.0.tgz";
        url  = "https://registry.yarnpkg.com/globby/-/globby-11.1.0.tgz";
<<<<<<< HEAD
        sha512 = "jhIXaOzy1sb8IyocaruWSn1TjmnBVs8Ayhcy83rmxNJ8q2uWKCAj3CnJY+KpGSXCueAPc0i05kVvVKtP1t9S3g==";
=======
        sha1 = "bd4be98bb042f83d796f7e3811991fbe82a0d34b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "globjoin___globjoin_0.1.4.tgz";
      path = fetchurl {
        name = "globjoin___globjoin_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/globjoin/-/globjoin-0.1.4.tgz";
<<<<<<< HEAD
        sha512 = "xYfnw62CKG8nLkZBfWbhWwDw02CHty86jfPcc2cr3ZfeuK9ysoVPPEUxf21bAD/rWAgk52SuBrLJlefNy8mvFg==";
      };
    }
    {
      name = "gopd___gopd_1.0.1.tgz";
      path = fetchurl {
        name = "gopd___gopd_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/gopd/-/gopd-1.0.1.tgz";
        sha512 = "d65bNlIadxvpb/A2abVdlqKqV563juRnZ1Wtk6s1sIR8uNsXR70xqIzVqxVf1eTqDunwT2MkczEeaezCKTZhwA==";
      };
    }
    {
      name = "graceful_fs___graceful_fs_4.2.11.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_4.2.11.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz";
        sha512 = "RbJ5/jmFcNNCcDV5o9eTnBLJ/HszWV0P73bc+Ff4nS/rJj+YaS6IGyiOL0VoBYX+l1Wrl3k63h/KrH+nhJ0XvQ==";
=======
        sha1 = "2f4494ac8919e3767c5cbb691e9f463324285d43";
      };
    }
    {
      name = "gonzales_pe___gonzales_pe_4.3.0.tgz";
      path = fetchurl {
        name = "gonzales_pe___gonzales_pe_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/gonzales-pe/-/gonzales-pe-4.3.0.tgz";
        sha1 = "fe9dec5f3c557eead09ff868c65826be54d067b3";
      };
    }
    {
      name = "graceful_fs___graceful_fs_4.2.9.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_4.2.9.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.9.tgz";
        sha1 = "041b05df45755e587a24942279b9d113146e1c96";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "gzip_size___gzip_size_6.0.0.tgz";
      path = fetchurl {
        name = "gzip_size___gzip_size_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/gzip-size/-/gzip-size-6.0.0.tgz";
<<<<<<< HEAD
        sha512 = "ax7ZYomf6jqPTQ4+XCpUGyXKHk5WweS+e05MBO4/y3WJ5RkmPXNKvX+bx1behVILVwr6JSQvZAku021CHPXG3Q==";
=======
        sha1 = "065367fd50c239c0671cbcbad5be3e2eeb10e462";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "hard_rejection___hard_rejection_2.1.0.tgz";
      path = fetchurl {
        name = "hard_rejection___hard_rejection_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/hard-rejection/-/hard-rejection-2.1.0.tgz";
<<<<<<< HEAD
        sha512 = "VIZB+ibDhx7ObhAe7OVtoEbuP4h/MuOTHJ+J8h/eBXotJYl0fBgR72xDFCKgIh22OJZIOVNxBMWuhAr10r8HdA==";
      };
    }
    {
      name = "has_bigints___has_bigints_1.0.2.tgz";
      path = fetchurl {
        name = "has_bigints___has_bigints_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.2.tgz";
        sha512 = "tSvCKtBr9lkF0Ex0aQiP9N+OpV4zi2r/Nee5VkRDbaqv35RLYMzbwQfFSZZH0kR+Rd6302UJZ2p/bJCEoR3VoQ==";
=======
        sha1 = "1c6eda5c1685c63942766d79bb40ae773cecd883";
      };
    }
    {
      name = "has_bigints___has_bigints_1.0.1.tgz";
      path = fetchurl {
        name = "has_bigints___has_bigints_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.1.tgz";
        sha1 = "64fe6acb020673e3b78db035a5af69aa9d07b113";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "has_flag___has_flag_3.0.0.tgz";
      path = fetchurl {
        name = "has_flag___has_flag_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "sKJf1+ceQBr4SMkvQnBDNDtf4TXpVhVGateu0t918bl30FnbE2m4vNLX+VWe/dpjlb+HugGYzW7uQXH98HPEYw==";
=======
        sha1 = "b5d454dc2199ae225699f3467e5a07f3b955bafd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "has_flag___has_flag_4.0.0.tgz";
      path = fetchurl {
        name = "has_flag___has_flag_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "EykJT/Q1KjTWctppgIAgfSO0tKVuZUjhgMr17kqTumMl6Afv3EISleU7qZUzoXDFTAHTDC4NOoG/ZxU3EvlMPQ==";
      };
    }
    {
      name = "has_property_descriptors___has_property_descriptors_1.0.0.tgz";
      path = fetchurl {
        name = "has_property_descriptors___has_property_descriptors_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz";
        sha512 = "62DVLZGoiEBDHQyqG4w9xCuZ7eJEwNmJRWw2VY84Oedb7WFcA27fiEVe8oUQx9hAUJ4ekurquucTGwsyO1XGdQ==";
      };
    }
    {
      name = "has_proto___has_proto_1.0.1.tgz";
      path = fetchurl {
        name = "has_proto___has_proto_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/has-proto/-/has-proto-1.0.1.tgz";
        sha512 = "7qE+iP+O+bgF9clE5+UoBFzE65mlBiVj3tKCrlNQ0Ogwm0BjpT/gK4SlLYDMybDh5I3TCTKnPPa0oMG7JDYrhg==";
      };
    }
    {
      name = "has_symbols___has_symbols_1.0.3.tgz";
      path = fetchurl {
        name = "has_symbols___has_symbols_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz";
        sha512 = "l3LCuF6MgDNwTDKkdYGEihYjt5pRPbEg46rtlmnSPlUbgmB8LOIrKJbYYFBSbnPaJexMKtiPO8hmeRjRz2Td+A==";
=======
        sha1 = "944771fd9c81c81265c4d6941860da06bb59479b";
      };
    }
    {
      name = "has_symbols___has_symbols_1.0.2.tgz";
      path = fetchurl {
        name = "has_symbols___has_symbols_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.2.tgz";
        sha1 = "165d3070c00309752a1236a479331e3ac56f1423";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "has_tostringtag___has_tostringtag_1.0.0.tgz";
      path = fetchurl {
        name = "has_tostringtag___has_tostringtag_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "kFjcSNhnlGV1kyoGk7OXKSawH5JOb/LzUc5w9B02hOTO0dfFRjbHQKvg1d6cf3HbeUmtU9VbbV3qzZ2Teh97WQ==";
=======
        sha1 = "7e133818a7d394734f941e73c3d3f9291e658b25";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "has___has_1.0.3.tgz";
      path = fetchurl {
        name = "has___has_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/has/-/has-1.0.3.tgz";
<<<<<<< HEAD
        sha512 = "f2dvO0VU6Oej7RkWJGrehjbzMAjFp5/VKPp5tTpWIV4JHHZK1/BxbFRtf/siA2SWTe09caDmVtYYzWEIbBS4zw==";
=======
        sha1 = "722d7cbfc1f6aa8241f16dd814e011e1f41e8796";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "hex_color_regex___hex_color_regex_1.1.0.tgz";
      path = fetchurl {
        name = "hex_color_regex___hex_color_regex_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/hex-color-regex/-/hex-color-regex-1.1.0.tgz";
<<<<<<< HEAD
        sha512 = "l9sfDFsuqtOqKDsQdqrMRk0U85RZc0RtOR9yPI7mRVOa4FsR/BVnZ0shmQRM96Ji99kYZP/7hn1cedc1+ApsTQ==";
=======
        sha1 = "4c06fccb4602fe2602b3c93df82d7e7dbf1a8a8e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "history___history_4.10.1.tgz";
      path = fetchurl {
        name = "history___history_4.10.1.tgz";
        url  = "https://registry.yarnpkg.com/history/-/history-4.10.1.tgz";
<<<<<<< HEAD
        sha512 = "36nwAD620w12kuzPAsyINPWJqlNbij+hpK1k9XRloDtym8mxzGYl2c17LnV6IAGB2Dmg4tEa7G7DlawS0+qjew==";
=======
        sha1 = "33371a65e3a83b267434e2b3f3b1b4c58aad4cf3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "hoist_non_react_statics___hoist_non_react_statics_3.3.2.tgz";
      path = fetchurl {
        name = "hoist_non_react_statics___hoist_non_react_statics_3.3.2.tgz";
        url  = "https://registry.yarnpkg.com/hoist-non-react-statics/-/hoist-non-react-statics-3.3.2.tgz";
<<<<<<< HEAD
        sha512 = "/gGivxi8JPKWNm/W0jSmzcMPpfpPLc3dY/6GxhX2hQ9iGj3aDfklV4ET7NjKpSinLpJ5vafa9iiGIEZg10SfBw==";
=======
        sha1 = "ece0acaf71d62c2969c2ec59feff42a4b1a85b45";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "hosted_git_info___hosted_git_info_2.8.9.tgz";
      path = fetchurl {
        name = "hosted_git_info___hosted_git_info_2.8.9.tgz";
        url  = "https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.9.tgz";
<<<<<<< HEAD
        sha512 = "mxIDAb9Lsm6DoOJ7xH+5+X4y1LU/4Hi50L9C5sIswK3JzULS4bwk1FvjdBgvYR4bzT4tuUQiC15FE2f5HbLvYw==";
=======
        sha1 = "dffc0bf9a21c02209090f2aa69429e1414daf3f9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "hosted_git_info___hosted_git_info_4.1.0.tgz";
      path = fetchurl {
        name = "hosted_git_info___hosted_git_info_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-4.1.0.tgz";
<<<<<<< HEAD
        sha512 = "kyCuEOWjJqZuDbRHzL8V93NzQhwIB71oFWSyzVo+KPZI+pnQPPxucdkrOZvkLRnrf5URsQM+IJ09Dw29cRALIA==";
=======
        sha1 = "827b82867e9ff1c8d0c4d9d53880397d2c86d224";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "hsl_regex___hsl_regex_1.0.0.tgz";
      path = fetchurl {
        name = "hsl_regex___hsl_regex_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/hsl-regex/-/hsl-regex-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "M5ezZw4LzXbBKMruP+BNANf0k+19hDQMgpzBIYnya//Al+fjNct9Wf3b1WedLqdEs2hKBvxq/jh+DsHJLj0F9A==";
=======
        sha1 = "d49330c789ed819e276a4c0d272dffa30b18fe6e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "hsla_regex___hsla_regex_1.0.0.tgz";
      path = fetchurl {
        name = "hsla_regex___hsla_regex_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/hsla-regex/-/hsla-regex-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "7Wn5GMLuHBjZCb2bTmnDOycho0p/7UVaAeqXZGbHrBCl6Yd/xDhQJAXe6Ga9AXJH2I5zY1dEdYw2u1UptnSBJA==";
      };
    }
    {
      name = "html_tags___html_tags_3.3.1.tgz";
      path = fetchurl {
        name = "html_tags___html_tags_3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/html-tags/-/html-tags-3.3.1.tgz";
        sha512 = "ztqyC3kLto0e9WbNp0aeP+M3kTt+nbaIveGmUxAtZa+8iFgKLUOD4YKM5j+f3QD89bra7UeumolZHKuOXnTmeQ==";
=======
        sha1 = "c1ce7a3168c8c6614033a4b5f7877f3b225f9c38";
      };
    }
    {
      name = "html_tags___html_tags_3.1.0.tgz";
      path = fetchurl {
        name = "html_tags___html_tags_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/html-tags/-/html-tags-3.1.0.tgz";
        sha1 = "7b5e6f7e665e9fb41f30007ed9e0d41e97fb2140";
      };
    }
    {
      name = "htmlparser2___htmlparser2_3.10.1.tgz";
      path = fetchurl {
        name = "htmlparser2___htmlparser2_3.10.1.tgz";
        url  = "https://registry.yarnpkg.com/htmlparser2/-/htmlparser2-3.10.1.tgz";
        sha1 = "bd679dc3f59897b6a34bb10749c855bb53a9392f";
      };
    }
    {
      name = "human_signals___human_signals_2.1.0.tgz";
      path = fetchurl {
        name = "human_signals___human_signals_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/human-signals/-/human-signals-2.1.0.tgz";
        sha1 = "dc91fcba42e4d06e4abaed33b3e7a3c02f514ea0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "iconv_lite___iconv_lite_0.2.11.tgz";
      path = fetchurl {
        name = "iconv_lite___iconv_lite_0.2.11.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.2.11.tgz";
<<<<<<< HEAD
        sha512 = "KhmFWgaQZY83Cbhi+ADInoUQ8Etn6BG5fikM9syeOjQltvR45h7cRKJ/9uvQEuD61I3Uju77yYce0/LhKVClQw==";
=======
        sha1 = "1ce60a3a57864a292d1321ff4609ca4bb965adc8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "icss_utils___icss_utils_5.1.0.tgz";
      path = fetchurl {
        name = "icss_utils___icss_utils_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/icss-utils/-/icss-utils-5.1.0.tgz";
<<<<<<< HEAD
        sha512 = "soFhflCVWLfRNOPU3iv5Z9VUdT44xFRbzjLsEzSr5AQmgqPMTHdU3PMT1Cf1ssx8fLNJDA1juftYl+PUcv3MqA==";
      };
    }
    {
      name = "iframe_resizer___iframe_resizer_4.3.6.tgz";
      path = fetchurl {
        name = "iframe_resizer___iframe_resizer_4.3.6.tgz";
        url  = "https://registry.yarnpkg.com/iframe-resizer/-/iframe-resizer-4.3.6.tgz";
        sha512 = "wz0WodRIF6eP0oGQa5NIP1yrITAZ59ZJvVaVJqJRjaeCtfm461vy2C3us6CKx0e7pooqpIGLpVMSTzrfAjX9Sg==";
=======
        sha1 = "c6be6858abd013d768e98366ae47e25d5887b1ae";
      };
    }
    {
      name = "iframe_resizer___iframe_resizer_4.3.2.tgz";
      path = fetchurl {
        name = "iframe_resizer___iframe_resizer_4.3.2.tgz";
        url  = "https://registry.yarnpkg.com/iframe-resizer/-/iframe-resizer-4.3.2.tgz";
        sha1 = "42dd88345d18b9e377b6044dddb98c664ab0ce6b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ignore___ignore_4.0.6.tgz";
      path = fetchurl {
        name = "ignore___ignore_4.0.6.tgz";
        url  = "https://registry.yarnpkg.com/ignore/-/ignore-4.0.6.tgz";
<<<<<<< HEAD
        sha512 = "cyFDKrqc/YdcWFniJhzI42+AzS+gNwmUzOSFcRCQYwySuBBBy/KjuxWLZ/FHEH6Moq1NizMOBWyTcv8O4OZIMg==";
      };
    }
    {
      name = "ignore___ignore_5.2.4.tgz";
      path = fetchurl {
        name = "ignore___ignore_5.2.4.tgz";
        url  = "https://registry.yarnpkg.com/ignore/-/ignore-5.2.4.tgz";
        sha512 = "MAb38BcSbH0eHNBxn7ql2NH/kX33OkB3lZ1BNdh7ENeRChHTYsTvWrMubiIAMNS2llXEEgZ1MUOBtXChP3kaFQ==";
=======
        sha1 = "750e3db5862087b4737ebac8207ffd1ef27b25fc";
      };
    }
    {
      name = "ignore___ignore_5.2.0.tgz";
      path = fetchurl {
        name = "ignore___ignore_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ignore/-/ignore-5.2.0.tgz";
        sha1 = "6d3bac8fa7fe0d45d9f9be7bac2fc279577e345a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "import_fresh___import_fresh_3.3.0.tgz";
      path = fetchurl {
        name = "import_fresh___import_fresh_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz";
<<<<<<< HEAD
        sha512 = "veYYhQa+D1QBKznvhUHxb8faxlrwUnxseDAbAp457E0wLNio2bOSKnjYDhMj+YiAq61xrMGhQk9iXVk5FzgQMw==";
=======
        sha1 = "37162c25fcb9ebaa2e6e53d5b4d88ce17d9e0c2b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "import_lazy___import_lazy_4.0.0.tgz";
      path = fetchurl {
        name = "import_lazy___import_lazy_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/import-lazy/-/import-lazy-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "rKtvo6a868b5Hu3heneU+L4yEQ4jYKLtjpnPeUdK7h0yzXGmyBTypknlkCvHFBqfX9YlorEiMM6Dnq/5atfHkw==";
=======
        sha1 = "e8eb627483a0a43da3c03f3e35548be5cb0cc153";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "import_local___import_local_3.1.0.tgz";
      path = fetchurl {
        name = "import_local___import_local_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/import-local/-/import-local-3.1.0.tgz";
<<<<<<< HEAD
        sha512 = "ASB07uLtnDs1o6EHjKpX34BKYDSqnFerfTOJL2HvMqF70LnxpjkzDB8J44oT9pu4AMPkQwf8jl6szgvNd2tRIg==";
=======
        sha1 = "b4479df8a5fd44f6cdce24070675676063c95cb4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "imurmurhash___imurmurhash_0.1.4.tgz";
      path = fetchurl {
        name = "imurmurhash___imurmurhash_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz";
<<<<<<< HEAD
        sha512 = "JmXMZ6wuvDmLiHEml9ykzqO6lwFbof0GG4IkcGaENdCRDDmMVnny7s5HsIgHCbaq0w2MyPhDqkhTUgS2LU2PHA==";
=======
        sha1 = "9218b9b2b928a238b13dc4fb6b6d576f231453ea";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "indent_string___indent_string_4.0.0.tgz";
      path = fetchurl {
        name = "indent_string___indent_string_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "EdDDZu4A2OyIK7Lr/2zG+w5jmbuk1DVBnEwREQvBzspBJkCEbRa8GxU1lghYcaGJCnRWibjDXlq779X1/y5xwg==";
=======
        sha1 = "624f8f4497d619b2d9768531d58f4122854d7251";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "inflight___inflight_1.0.6.tgz";
      path = fetchurl {
        name = "inflight___inflight_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz";
<<<<<<< HEAD
        sha512 = "k92I/b08q4wvFscXCLvqfsHCrjrF7yiXsQuIVvVE7N82W3+aqpzuUdBbfhWcy/FZR3/4IgflMgKLOsvPDrGCJA==";
=======
        sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "inherits___inherits_2.0.4.tgz";
      path = fetchurl {
        name = "inherits___inherits_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz";
<<<<<<< HEAD
        sha512 = "k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==";
=======
        sha1 = "0fa2c64f932917c3433a0ded55363aae37416b7c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ini___ini_1.3.8.tgz";
      path = fetchurl {
        name = "ini___ini_1.3.8.tgz";
        url  = "https://registry.yarnpkg.com/ini/-/ini-1.3.8.tgz";
<<<<<<< HEAD
        sha512 = "JV/yugV2uzW5iMRSiZAyDtQd+nxtUnjeLt0acNdw98kKLrvuRVyB80tsREOE7yvGVgalhZ6RNXCmEHkUKBKxew==";
      };
    }
    {
      name = "internal_slot___internal_slot_1.0.5.tgz";
      path = fetchurl {
        name = "internal_slot___internal_slot_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.5.tgz";
        sha512 = "Y+R5hJrzs52QCG2laLn4udYVnxsfny9CpOhNhUvk/SSSVyF6T27FzRbF0sroPidSu3X8oEAkOn2K804mjpt6UQ==";
=======
        sha1 = "a29da425b48806f34767a4efce397269af28432c";
      };
    }
    {
      name = "internal_slot___internal_slot_1.0.3.tgz";
      path = fetchurl {
        name = "internal_slot___internal_slot_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.3.tgz";
        sha1 = "7347e307deeea2faac2ac6205d4bc7d34967f59c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "interpret___interpret_2.2.0.tgz";
      path = fetchurl {
        name = "interpret___interpret_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/interpret/-/interpret-2.2.0.tgz";
<<<<<<< HEAD
        sha512 = "Ju0Bz/cEia55xDwUWEa8+olFpCiQoypjnQySseKtmjNrnps3P+xfpUmGr90T7yjlVJmOtybRvPXhKMbHr+fWnw==";
      };
    }
    {
      name = "is_arguments___is_arguments_1.1.1.tgz";
      path = fetchurl {
        name = "is_arguments___is_arguments_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-arguments/-/is-arguments-1.1.1.tgz";
        sha512 = "8Q7EARjzEnKpt/PCD7e1cgUS0a6X8u5tdSiMqXhojOdoV9TsMsiO+9VLC5vAmO8N7/GmXn7yjR8qnA6bVAEzfA==";
      };
    }
    {
      name = "is_array_buffer___is_array_buffer_3.0.2.tgz";
      path = fetchurl {
        name = "is_array_buffer___is_array_buffer_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.2.tgz";
        sha512 = "y+FyyR/w8vfIRq4eQcM1EYgSTnmHXPqaF+IgzgraytCFq5Xh8lllDVmAZolPJiZttZLeFSINPYMaEJ7/vWUa1w==";
=======
        sha1 = "1a78a0b5965c40a5416d007ad6f50ad27c417df9";
      };
    }
    {
      name = "is_alphabetical___is_alphabetical_1.0.4.tgz";
      path = fetchurl {
        name = "is_alphabetical___is_alphabetical_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-alphabetical/-/is-alphabetical-1.0.4.tgz";
        sha1 = "9e7d6b94916be22153745d184c298cbf986a686d";
      };
    }
    {
      name = "is_alphanumerical___is_alphanumerical_1.0.4.tgz";
      path = fetchurl {
        name = "is_alphanumerical___is_alphanumerical_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-alphanumerical/-/is-alphanumerical-1.0.4.tgz";
        sha1 = "7eb9a2431f855f6b1ef1a78e326df515696c4dbf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_arrayish___is_arrayish_0.2.1.tgz";
      path = fetchurl {
        name = "is_arrayish___is_arrayish_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz";
<<<<<<< HEAD
        sha512 = "zz06S8t0ozoDXMG+ube26zeCTNXcKIPJZJi8hBrF4idCLms4CG9QtK7qBl1boi5ODzFpjswb5JPmHCbMpjaYzg==";
=======
        sha1 = "77c99840527aa8ecb1a8ba697b80645a7a926a9d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_arrayish___is_arrayish_0.3.2.tgz";
      path = fetchurl {
        name = "is_arrayish___is_arrayish_0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.3.2.tgz";
<<<<<<< HEAD
        sha512 = "eVRqCvVlZbuw3GrM63ovNSNAeA1K16kaR/LRY/92w0zxQ5/1YzwblUX652i4Xs9RwAGjW9d9y6X88t8OaAJfWQ==";
=======
        sha1 = "4574a2ae56f7ab206896fb431eaeed066fdf8f03";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_bigint___is_bigint_1.0.4.tgz";
      path = fetchurl {
        name = "is_bigint___is_bigint_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.4.tgz";
<<<<<<< HEAD
        sha512 = "zB9CruMamjym81i2JZ3UMn54PKGsQzsJeo6xvN3HJJ4CAsQNB6iRutp2To77OfCNuoxspsIhzaPoO1zyCEhFOg==";
=======
        sha1 = "08147a1875bc2b32005d41ccd8291dffc6691df3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_binary_path___is_binary_path_2.1.0.tgz";
      path = fetchurl {
        name = "is_binary_path___is_binary_path_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz";
<<<<<<< HEAD
        sha512 = "ZMERYes6pDydyuGidse7OsHxtbI7WVeUEozgR/g7rd0xUimYNlvZRE/K2MgZTjWy725IfelLeVcEM97mmtRGXw==";
=======
        sha1 = "ea1f7f3b80f064236e83470f86c09c254fb45b09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_boolean_object___is_boolean_object_1.1.2.tgz";
      path = fetchurl {
        name = "is_boolean_object___is_boolean_object_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.2.tgz";
<<<<<<< HEAD
        sha512 = "gDYaKHJmnj4aWxyj6YHyXVpdQawtVLHU5cb+eztPGczf6cjuTdwve5ZIEfgXqH4e57An1D1AKf8CZ3kYrQRqYA==";
      };
    }
    {
      name = "is_callable___is_callable_1.2.7.tgz";
      path = fetchurl {
        name = "is_callable___is_callable_1.2.7.tgz";
        url  = "https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.7.tgz";
        sha512 = "1BC0BVFhS/p0qtw6enp8e+8OD0UrK0oFLztSjNzhcKA3WDuJxxAPXzPuPtKkjEY9UUoEWlX/8fgKeu2S8i9JTA==";
=======
        sha1 = "5c6dc200246dd9321ae4b885a114bb1f75f63719";
      };
    }
    {
      name = "is_buffer___is_buffer_2.0.5.tgz";
      path = fetchurl {
        name = "is_buffer___is_buffer_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/is-buffer/-/is-buffer-2.0.5.tgz";
        sha1 = "ebc252e400d22ff8d77fa09888821a24a658c191";
      };
    }
    {
      name = "is_callable___is_callable_1.2.4.tgz";
      path = fetchurl {
        name = "is_callable___is_callable_1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.4.tgz";
        sha1 = "47301d58dd0259407865547853df6d61fe471945";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_color_stop___is_color_stop_1.1.0.tgz";
      path = fetchurl {
        name = "is_color_stop___is_color_stop_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-color-stop/-/is-color-stop-1.1.0.tgz";
<<<<<<< HEAD
        sha512 = "H1U8Vz0cfXNujrJzEcvvwMDW9Ra+biSYA3ThdQvAnMLJkEHQXn6bWzLkxHtVYJ+Sdbx0b6finn3jZiaVe7MAHA==";
      };
    }
    {
      name = "is_core_module___is_core_module_2.12.0.tgz";
      path = fetchurl {
        name = "is_core_module___is_core_module_2.12.0.tgz";
        url  = "https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.12.0.tgz";
        sha512 = "RECHCBCd/viahWmwj6enj19sKbHfJrddi/6cBDsNTKbNq0f7VeaUkBo60BqzvPqo/W54ChS62Z5qyun7cfOMqQ==";
=======
        sha1 = "cfff471aee4dd5c9e158598fbe12967b5cdad345";
      };
    }
    {
      name = "is_core_module___is_core_module_2.8.1.tgz";
      path = fetchurl {
        name = "is_core_module___is_core_module_2.8.1.tgz";
        url  = "https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.8.1.tgz";
        sha1 = "f59fdfca701d5879d0a6b100a40aa1560ce27211";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_date_object___is_date_object_1.0.5.tgz";
      path = fetchurl {
        name = "is_date_object___is_date_object_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.5.tgz";
<<<<<<< HEAD
        sha512 = "9YQaSxsAiSwcvS33MBk3wTCVnWK+HhF8VZR2jRxehM16QcVOdHqPn4VPHmRK4lSr38n9JriurInLcP90xsYNfQ==";
=======
        sha1 = "0841d5536e724c25597bf6ea62e1bd38298df31f";
      };
    }
    {
      name = "is_decimal___is_decimal_1.0.4.tgz";
      path = fetchurl {
        name = "is_decimal___is_decimal_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-decimal/-/is-decimal-1.0.4.tgz";
        sha1 = "65a3a5958a1c5b63a706e1b333d7cd9f630d3fa5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_extglob___is_extglob_2.1.1.tgz";
      path = fetchurl {
        name = "is_extglob___is_extglob_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz";
<<<<<<< HEAD
        sha512 = "SbKbANkN603Vi4jEZv49LeVJMn4yGwsbzZworEoyEiutsN3nJYdbO36zfhGJ6QEDpOZIFkDtnq5JRxmvl3jsoQ==";
=======
        sha1 = "a88c02535791f02ed37c76a1b9ea9773c833f8c2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_fullwidth_code_point___is_fullwidth_code_point_3.0.0.tgz";
      path = fetchurl {
        name = "is_fullwidth_code_point___is_fullwidth_code_point_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "zymm5+u+sCsSWyD9qNaejV3DFvhCKclKdizYaJUuHA83RLjb7nSuGnddCHGv0hk+KY7BMAlsWeK4Ueg6EV6XQg==";
=======
        sha1 = "f116f8064fe90b3f7844a38997c0b75051269f1d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_glob___is_glob_4.0.3.tgz";
      path = fetchurl {
        name = "is_glob___is_glob_4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz";
<<<<<<< HEAD
        sha512 = "xelSayHH36ZgE7ZWhli7pW34hNbNl8Ojv5KVmkJD4hBdD3th8Tfk9vYasLM+mXWOZhFkgZfxhLSnrwRr4elSSg==";
      };
    }
    {
      name = "is_map___is_map_2.0.2.tgz";
      path = fetchurl {
        name = "is_map___is_map_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-map/-/is-map-2.0.2.tgz";
        sha512 = "cOZFQQozTha1f4MxLFzlgKYPTyj26picdZTx82hbc/Xf4K/tZOOXSCkMvU4pKioRXGDLJRn0GM7Upe7kR721yg==";
=======
        sha1 = "64f61e42cbbb2eec2071a9dac0b28ba1e65d5084";
      };
    }
    {
      name = "is_hexadecimal___is_hexadecimal_1.0.4.tgz";
      path = fetchurl {
        name = "is_hexadecimal___is_hexadecimal_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-hexadecimal/-/is-hexadecimal-1.0.4.tgz";
        sha1 = "cc35c97588da4bd49a8eedd6bc4082d44dcb23a7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_negative_zero___is_negative_zero_2.0.2.tgz";
      path = fetchurl {
        name = "is_negative_zero___is_negative_zero_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.2.tgz";
<<<<<<< HEAD
        sha512 = "dqJvarLawXsFbNDeJW7zAz8ItJ9cd28YufuuFzh0G8pNHjJMnY08Dv7sYX2uF5UpQOwieAeOExEYAWWfu7ZZUA==";
      };
    }
    {
      name = "is_number_object___is_number_object_1.0.7.tgz";
      path = fetchurl {
        name = "is_number_object___is_number_object_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.7.tgz";
        sha512 = "k1U0IRzLMo7ZlYIfzRu23Oh6MiIFasgpb9X76eqfFZAqwH44UI4KTBvBYIZ1dSL9ZzChTB9ShHfLkR4pdW5krQ==";
=======
        sha1 = "7bf6f03a28003b8b3965de3ac26f664d765f3150";
      };
    }
    {
      name = "is_number_object___is_number_object_1.0.6.tgz";
      path = fetchurl {
        name = "is_number_object___is_number_object_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.6.tgz";
        sha1 = "6a7aaf838c7f0686a50b4553f7e54a96494e89f0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_number___is_number_7.0.0.tgz";
      path = fetchurl {
        name = "is_number___is_number_7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz";
<<<<<<< HEAD
        sha512 = "41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==";
=======
        sha1 = "7535345b896734d5f80c4d06c50955527a14f12b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_plain_obj___is_plain_obj_1.1.0.tgz";
      path = fetchurl {
        name = "is_plain_obj___is_plain_obj_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-1.1.0.tgz";
<<<<<<< HEAD
        sha512 = "yvkRyxmFKEOQ4pNXCmJG5AEQNlXJS5LaONXo5/cLdTZdWvsZ1ioJEonLGAosKlMWE8lwUy/bJzMjcw8az73+Fg==";
=======
        sha1 = "71a50c8429dfca773c92a390a4a03b39fcd51d3e";
      };
    }
    {
      name = "is_plain_obj___is_plain_obj_2.1.0.tgz";
      path = fetchurl {
        name = "is_plain_obj___is_plain_obj_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-2.1.0.tgz";
        sha1 = "45e42e37fccf1f40da8e5f76ee21515840c09287";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_plain_object___is_plain_object_2.0.4.tgz";
      path = fetchurl {
        name = "is_plain_object___is_plain_object_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz";
<<<<<<< HEAD
        sha512 = "h5PpgXkWitc38BBMYawTYMWJHFZJVnBquFE57xFpjB8pJFiF6gZ+bU+WyI/yqXiFR5mdLsgYNaPe8uao6Uv9Og==";
      };
    }
    {
      name = "is_plain_object___is_plain_object_5.0.0.tgz";
      path = fetchurl {
        name = "is_plain_object___is_plain_object_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-5.0.0.tgz";
        sha512 = "VRSzKkbMm5jMDoKLbltAkFQ5Qr7VDiTFGXxYFXXowVj387GeGNOCsOH6Msy00SGZ3Fp84b1Naa1psqgcCIEP5Q==";
=======
        sha1 = "2c163b3fafb1b606d9d17928f05c2a1c38e07677";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_regex___is_regex_1.1.4.tgz";
      path = fetchurl {
        name = "is_regex___is_regex_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz";
<<<<<<< HEAD
        sha512 = "kvRdxDsxZjhzUX07ZnLydzS1TU/TJlTUHHY4YLL87e37oUA49DfkLqgy+VjFocowy29cKvcSiu+kIv728jTTVg==";
      };
    }
    {
      name = "is_set___is_set_2.0.2.tgz";
      path = fetchurl {
        name = "is_set___is_set_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-set/-/is-set-2.0.2.tgz";
        sha512 = "+2cnTEZeY5z/iXGbLhPrOAaK/Mau5k5eXq9j14CpRTftq0pAJu2MwVRSZhyZWBzx3o6X795Lz6Bpb6R0GKf37g==";
      };
    }
    {
      name = "is_shared_array_buffer___is_shared_array_buffer_1.0.2.tgz";
      path = fetchurl {
        name = "is_shared_array_buffer___is_shared_array_buffer_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz";
        sha512 = "sqN2UDu1/0y6uvXyStCOzyhAjCSlHceFoMKJW8W9EU9cvic/QdsZ0kEU93HEy3IUEFZIiH/3w+AH/UQbPHNdhA==";
=======
        sha1 = "eef5663cd59fa4c0ae339505323df6854bb15958";
      };
    }
    {
      name = "is_regexp___is_regexp_2.1.0.tgz";
      path = fetchurl {
        name = "is_regexp___is_regexp_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-regexp/-/is-regexp-2.1.0.tgz";
        sha1 = "cd734a56864e23b956bf4e7c66c396a4c0b22c2d";
      };
    }
    {
      name = "is_shared_array_buffer___is_shared_array_buffer_1.0.1.tgz";
      path = fetchurl {
        name = "is_shared_array_buffer___is_shared_array_buffer_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.1.tgz";
        sha1 = "97b0c85fbdacb59c9c446fe653b82cf2b5b7cfe6";
      };
    }
    {
      name = "is_stream___is_stream_2.0.1.tgz";
      path = fetchurl {
        name = "is_stream___is_stream_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.1.tgz";
        sha1 = "fac1e3d53b97ad5a9d0ae9cef2389f5810a5c077";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_string___is_string_1.0.7.tgz";
      path = fetchurl {
        name = "is_string___is_string_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/is-string/-/is-string-1.0.7.tgz";
<<<<<<< HEAD
        sha512 = "tE2UXzivje6ofPW7l23cjDOMa09gb7xlAqG6jG5ej6uPV32TlWP3NKPigtaGeHNu9fohccRYvIiZMfOOnOYUtg==";
=======
        sha1 = "0dd12bf2006f255bb58f695110eff7491eebc0fd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_symbol___is_symbol_1.0.4.tgz";
      path = fetchurl {
        name = "is_symbol___is_symbol_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.4.tgz";
<<<<<<< HEAD
        sha512 = "C/CPBqKWnvdcxqIARxyOh4v1UUEOCHpgDa0WYgpKDFMszcrPcffg5uhwSgPCLD2WWxmq6isisz87tzT01tuGhg==";
      };
    }
    {
      name = "is_typed_array___is_typed_array_1.1.10.tgz";
      path = fetchurl {
        name = "is_typed_array___is_typed_array_1.1.10.tgz";
        url  = "https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.10.tgz";
        sha512 = "PJqgEHiWZvMpaFZ3uTc8kHPM4+4ADTlDniuQL7cU/UDA0Ql7F70yGfHph3cLNe+c9toaigv+DFzTJKhc2CtO6A==";
      };
    }
    {
      name = "is_weakmap___is_weakmap_2.0.1.tgz";
      path = fetchurl {
        name = "is_weakmap___is_weakmap_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-weakmap/-/is-weakmap-2.0.1.tgz";
        sha512 = "NSBR4kH5oVj1Uwvv970ruUkCV7O1mzgVFO4/rev2cLRda9Tm9HrL70ZPut4rOHgY0FNrUu9BCbXA2sdQ+x0chA==";
=======
        sha1 = "a6dac93b635b063ca6872236de88910a57af139c";
      };
    }
    {
      name = "is_typedarray___is_typedarray_1.0.0.tgz";
      path = fetchurl {
        name = "is_typedarray___is_typedarray_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-typedarray/-/is-typedarray-1.0.0.tgz";
        sha1 = "e479c80858df0c1b11ddda6940f96011fcda4a9a";
      };
    }
    {
      name = "is_unicode_supported___is_unicode_supported_0.1.0.tgz";
      path = fetchurl {
        name = "is_unicode_supported___is_unicode_supported_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz";
        sha1 = "3f26c76a809593b52bfa2ecb5710ed2779b522a7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "is_weakref___is_weakref_1.0.2.tgz";
      path = fetchurl {
        name = "is_weakref___is_weakref_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.0.2.tgz";
<<<<<<< HEAD
        sha512 = "qctsuLZmIQ0+vSSMfoVvyFe2+GSEvnmZ2ezTup1SBse9+twCCeial6EEi3Nc2KFcf6+qz2FBPnjXsk8xhKSaPQ==";
      };
    }
    {
      name = "is_weakset___is_weakset_2.0.2.tgz";
      path = fetchurl {
        name = "is_weakset___is_weakset_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-weakset/-/is-weakset-2.0.2.tgz";
        sha512 = "t2yVvttHkQktwnNNmBQ98AhENLdPUTDTE21uPqAQ0ARwQfGeQKRVS0NNurH7bTf7RrvcVn1OOge45CnBeHCSmg==";
=======
        sha1 = "9529f383a9338205e89765e0392efc2f100f06f2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "isarray___isarray_0.0.1.tgz";
      path = fetchurl {
        name = "isarray___isarray_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz";
<<<<<<< HEAD
        sha512 = "D2S+3GLxWH+uhrNEcoh/fnmYeP8E8/zHl644d/jdA0g2uyXvy3sb0qxotE+ne0LtccHknQzWwZEzhak7oJ0COQ==";
=======
        sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "isarray___isarray_2.0.5.tgz";
      path = fetchurl {
        name = "isarray___isarray_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-2.0.5.tgz";
<<<<<<< HEAD
        sha512 = "xHjhDr3cNBK0BzdUJSPXZntQUx/mwMS5Rw4A7lPJ90XGAO6ISP/ePDNuo0vhqOZU+UD5JoodwCAAoZQd3FeAKw==";
=======
        sha1 = "8af1e4c1221244cc62459faf38940d4e644a5723";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "isarray___isarray_1.0.0.tgz";
      path = fetchurl {
        name = "isarray___isarray_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "VLghIWNM6ELQzo7zwmcg0NmTVyWKYjvIeM83yjp0wRDTmUnrM678fQbcKBo6n2CJEF0szoG//ytg+TKla89ALQ==";
=======
        sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "isexe___isexe_2.0.0.tgz";
      path = fetchurl {
        name = "isexe___isexe_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz";
<<<<<<< HEAD
        sha512 = "RHxMLp9lnKHGHRng9QFhRCMbYAcVpn69smSGcq3f36xjgVVWThj4qqLbTLlq7Ssj8B+fIQ1EuCEGI2lKsyQeIw==";
=======
        sha1 = "e8fbf374dc556ff8947a10dcb0572d633f2cfa10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "isobject___isobject_3.0.1.tgz";
      path = fetchurl {
        name = "isobject___isobject_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz";
<<<<<<< HEAD
        sha512 = "WhB9zCku7EGTj/HQQRz5aUQEUeoQZH2bWcltRErOpymJ4boYE6wL9Tbr23krRPSZ+C5zqNSrSw+Cc7sZZ4b7vg==";
      };
    }
    {
      name = "jest_worker___jest_worker_27.5.1.tgz";
      path = fetchurl {
        name = "jest_worker___jest_worker_27.5.1.tgz";
        url  = "https://registry.yarnpkg.com/jest-worker/-/jest-worker-27.5.1.tgz";
        sha512 = "7vuh85V5cdDofPyxn58nrPjBktZo0u9x1g8WtjQol+jZDaE+fhN+cIvTj11GndBnMnyfrUOG1sZQxCdjKh+DKg==";
=======
        sha1 = "4e431e92b11a9731636aa1f9c8d1ccbcfdab78df";
      };
    }
    {
      name = "jest_worker___jest_worker_27.4.6.tgz";
      path = fetchurl {
        name = "jest_worker___jest_worker_27.4.6.tgz";
        url  = "https://registry.yarnpkg.com/jest-worker/-/jest-worker-27.4.6.tgz";
        sha1 = "5d2d93db419566cb680752ca0792780e71b3273e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "js_tokens___js_tokens_4.0.0.tgz";
      path = fetchurl {
        name = "js_tokens___js_tokens_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "RdJUflcE3cUzKiMqQgsCu06FPu9UdIJO0beYbPhHN4k6apgJtifcoCtT9bcxOpYBtpD2kCM6Sbzg4CausW/PKQ==";
=======
        sha1 = "19203fb59991df98e3a287050d4647cdeaf32499";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "js_yaml___js_yaml_3.14.1.tgz";
      path = fetchurl {
        name = "js_yaml___js_yaml_3.14.1.tgz";
        url  = "https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.14.1.tgz";
<<<<<<< HEAD
        sha512 = "okMH7OXXJ7YrN9Ok3/SXrnu4iX9yOk+25nqX4imS2npuvTYDmo/QEZoqwZkYaIDk3jVvBOTOIEgEhaLOynBS9g==";
=======
        sha1 = "dae812fdb3825fa306609a8717383c50c36a0537";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "jsesc___jsesc_2.5.2.tgz";
      path = fetchurl {
        name = "jsesc___jsesc_2.5.2.tgz";
        url  = "https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.2.tgz";
<<<<<<< HEAD
        sha512 = "OYu7XEzjkCQ3C5Ps3QIZsQfNpqoJyZZA99wd9aWd05NCtC5pWOkShK2mkL6HXQR6/Cy2lbNdPlZBpuQHXE63gA==";
=======
        sha1 = "80564d2e483dacf6e8ef209650a67df3f0c283a4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "jsesc___jsesc_0.5.0.tgz";
      path = fetchurl {
        name = "jsesc___jsesc_0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/jsesc/-/jsesc-0.5.0.tgz";
<<<<<<< HEAD
        sha512 = "uZz5UnB7u4T9LvwmFqXii7pZSouaRPorGs5who1Ip7VO0wxanFvBL7GkM6dTHlgX+jhBApRetaWpnDabOeTcnA==";
=======
        sha1 = "e7dee66e35d6fc16f710fe91d5cf69f70f08911d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "json_parse_better_errors___json_parse_better_errors_1.0.2.tgz";
      path = fetchurl {
        name = "json_parse_better_errors___json_parse_better_errors_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz";
<<<<<<< HEAD
        sha512 = "mrqyZKfX5EhL7hvqcV6WG1yYjnjeuYDzDhhcAAUrq8Po85NBQBJP+ZDUT75qZQ98IkUoBqdkExkukOU7Ts2wrw==";
=======
        sha1 = "bb867cfb3450e69107c131d1c514bab3dc8bcaa9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "json_parse_even_better_errors___json_parse_even_better_errors_2.3.1.tgz";
      path = fetchurl {
        name = "json_parse_even_better_errors___json_parse_even_better_errors_2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz";
<<<<<<< HEAD
        sha512 = "xyFwyhro/JEof6Ghe2iz2NcXoj2sloNsWr/XsERDK/oiPCfaNhl5ONfp+jQdAZRQQ0IJWNzH9zIZF7li91kh2w==";
=======
        sha1 = "7c47805a94319928e05777405dc12e1f7a4ee02d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "json_schema_traverse___json_schema_traverse_0.4.1.tgz";
      path = fetchurl {
        name = "json_schema_traverse___json_schema_traverse_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz";
<<<<<<< HEAD
        sha512 = "xbbCH5dCYU5T8LcEhhuh7HJ88HXuW3qsI3Y0zOZFKfZEHcpWiHU/Jxzk629Brsab/mMiHQti9wMP+845RPe3Vg==";
=======
        sha1 = "69f6a87d9513ab8bb8fe63bdb0979c448e684660";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "json_schema_traverse___json_schema_traverse_1.0.0.tgz";
      path = fetchurl {
        name = "json_schema_traverse___json_schema_traverse_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "NM8/P9n3XjXhIZn1lLhkFaACTOURQXjWhV4BA/RnOv8xvgqtqpAX9IO4mRQxSx1Rlo4tqzeqb0sOlruaOy3dug==";
=======
        sha1 = "ae7bcb3656ab77a73ba5c49bf654f38e6b6860e2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "json_stable_stringify_without_jsonify___json_stable_stringify_without_jsonify_1.0.1.tgz";
      path = fetchurl {
        name = "json_stable_stringify_without_jsonify___json_stable_stringify_without_jsonify_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz";
<<<<<<< HEAD
        sha512 = "Bdboy+l7tA3OGW6FjyFHWkP5LuByj1Tk33Ljyq0axyzdk9//JSi2u3fP1QSmd1KNwq6VOKYGlAu87CisVir6Pw==";
      };
    }
    {
      name = "json5___json5_1.0.2.tgz";
      path = fetchurl {
        name = "json5___json5_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/json5/-/json5-1.0.2.tgz";
        sha512 = "g1MWMLBiz8FKi1e4w0UyVL3w+iJceWAFBAaBnnGKOpNa5f8TLktkbre1+s6oICydWAm+HRUGTmI+//xv2hvXYA==";
      };
    }
    {
      name = "json5___json5_2.2.3.tgz";
      path = fetchurl {
        name = "json5___json5_2.2.3.tgz";
        url  = "https://registry.yarnpkg.com/json5/-/json5-2.2.3.tgz";
        sha512 = "XmOWe7eyHYH14cLdVPoyg+GOH3rYX++KpzrylJwSW98t3Nk+U8XOl8FWKOgwtzdb8lXGf6zYwDUzeHMWfxasyg==";
=======
        sha1 = "9db7b59496ad3f3cfef30a75142d2d930ad72651";
      };
    }
    {
      name = "json5___json5_1.0.1.tgz";
      path = fetchurl {
        name = "json5___json5_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json5/-/json5-1.0.1.tgz";
        sha1 = "779fb0018604fa854eacbf6252180d83543e3dbe";
      };
    }
    {
      name = "json5___json5_2.2.0.tgz";
      path = fetchurl {
        name = "json5___json5_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/json5/-/json5-2.2.0.tgz";
        sha1 = "2dfefe720c6ba525d9ebd909950f0515316c89a3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "jsonfile___jsonfile_6.1.0.tgz";
      path = fetchurl {
        name = "jsonfile___jsonfile_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz";
<<<<<<< HEAD
        sha512 = "5dgndWOriYSm5cnYaJNhalLNDKOqFwyDB/rr1E9ZsGciGvKPs8R2xYGCacuf3z6K1YKDz182fd+fY3cn3pMqXQ==";
      };
    }
    {
      name = "jsx_ast_utils___jsx_ast_utils_3.3.3.tgz";
      path = fetchurl {
        name = "jsx_ast_utils___jsx_ast_utils_3.3.3.tgz";
        url  = "https://registry.yarnpkg.com/jsx-ast-utils/-/jsx-ast-utils-3.3.3.tgz";
        sha512 = "fYQHZTZ8jSfmWZ0iyzfwiU4WDX4HpHbMCZ3gPlWYiCl3BoeOTsqKBqnTVfH2rYT7eP5c3sVbeSPHnnJOaTrWiw==";
=======
        sha1 = "bc55b2634793c679ec6403094eb13698a6ec0aae";
      };
    }
    {
      name = "jsx_ast_utils___jsx_ast_utils_3.2.1.tgz";
      path = fetchurl {
        name = "jsx_ast_utils___jsx_ast_utils_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/jsx-ast-utils/-/jsx-ast-utils-3.2.1.tgz";
        sha1 = "720b97bfe7d901b927d87c3773637ae8ea48781b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "kind_of___kind_of_6.0.3.tgz";
      path = fetchurl {
        name = "kind_of___kind_of_6.0.3.tgz";
        url  = "https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz";
<<<<<<< HEAD
        sha512 = "dcS1ul+9tmeD95T+x28/ehLgd9mENa3LsvDTtzm3vyBEO7RPptvAD+t44WVXaUjTBRcrpFeFlC8WCruUR456hw==";
      };
    }
    {
      name = "klona___klona_2.0.6.tgz";
      path = fetchurl {
        name = "klona___klona_2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/klona/-/klona-2.0.6.tgz";
        sha512 = "dhG34DXATL5hSxJbIexCft8FChFXtmskoZYnoPWjXQuebWYCNkVeV3KkGegCK9CP1oswI/vQibS2GY7Em/sJJA==";
      };
    }
    {
      name = "known_css_properties___known_css_properties_0.26.0.tgz";
      path = fetchurl {
        name = "known_css_properties___known_css_properties_0.26.0.tgz";
        url  = "https://registry.yarnpkg.com/known-css-properties/-/known-css-properties-0.26.0.tgz";
        sha512 = "5FZRzrZzNTBruuurWpvZnvP9pum+fe0HcK8z/ooo+U+Hmp4vtbyp1/QDsqmufirXy4egGzbaH/y2uCZf+6W5Kg==";
      };
    }
    {
      name = "language_subtag_registry___language_subtag_registry_0.3.22.tgz";
      path = fetchurl {
        name = "language_subtag_registry___language_subtag_registry_0.3.22.tgz";
        url  = "https://registry.yarnpkg.com/language-subtag-registry/-/language-subtag-registry-0.3.22.tgz";
        sha512 = "tN0MCzyWnoz/4nHS6uxdlFWoUZT7ABptwKPQ52Ea7URk6vll88bWBVhodtnlfEuCcKWNGoc+uGbw1cwa9IKh/w==";
=======
        sha1 = "07c05034a6c349fa06e24fa35aa76db4580ce4dd";
      };
    }
    {
      name = "klona___klona_2.0.5.tgz";
      path = fetchurl {
        name = "klona___klona_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/klona/-/klona-2.0.5.tgz";
        sha1 = "d166574d90076395d9963aa7a928fabb8d76afbc";
      };
    }
    {
      name = "known_css_properties___known_css_properties_0.21.0.tgz";
      path = fetchurl {
        name = "known_css_properties___known_css_properties_0.21.0.tgz";
        url  = "https://registry.yarnpkg.com/known-css-properties/-/known-css-properties-0.21.0.tgz";
        sha1 = "15fbd0bbb83447f3ce09d8af247ed47c68ede80d";
      };
    }
    {
      name = "language_subtag_registry___language_subtag_registry_0.3.21.tgz";
      path = fetchurl {
        name = "language_subtag_registry___language_subtag_registry_0.3.21.tgz";
        url  = "https://registry.yarnpkg.com/language-subtag-registry/-/language-subtag-registry-0.3.21.tgz";
        sha1 = "04ac218bea46f04cb039084602c6da9e788dd45a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "language_tags___language_tags_1.0.5.tgz";
      path = fetchurl {
        name = "language_tags___language_tags_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/language-tags/-/language-tags-1.0.5.tgz";
<<<<<<< HEAD
        sha512 = "qJhlO9cGXi6hBGKoxEG/sKZDAHD5Hnu9Hs4WbOY3pCWXDhw0N8x1NenNzm2EnNLkLkk7J2SdxAkDSbb6ftT+UQ==";
=======
        sha1 = "d321dbc4da30ba8bf3024e040fa5c14661f9193a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "levn___levn_0.4.1.tgz";
      path = fetchurl {
        name = "levn___levn_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/levn/-/levn-0.4.1.tgz";
<<<<<<< HEAD
        sha512 = "+bT2uH4E5LGE7h/n3evcS/sQlJXCpIp6ym8OWJ5eV6+67Dsql/LaaT7qJBAt2rzfoa/5QBGBhxDix1dMt2kQKQ==";
=======
        sha1 = "ae4562c007473b932a6200d403268dd2fffc6ade";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "levn___levn_0.3.0.tgz";
      path = fetchurl {
        name = "levn___levn_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/levn/-/levn-0.3.0.tgz";
<<<<<<< HEAD
        sha512 = "0OO4y2iOHix2W6ujICbKIaEQXvFQHue65vUG3pb5EUomzPI90z9hsA1VsO/dbIIpC53J8gxM9Q4Oho0jrCM/yA==";
      };
    }
    {
      name = "lilconfig___lilconfig_2.1.0.tgz";
      path = fetchurl {
        name = "lilconfig___lilconfig_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/lilconfig/-/lilconfig-2.1.0.tgz";
        sha512 = "utWOt/GHzuUxnLKxB6dk81RoOeoNeHgbrXiuGk4yyF5qlRz+iIVWu56E2fqGHFrXz0QNUhLB/8nKqvRH66JKGQ==";
=======
        sha1 = "3b09924edf9f083c0490fdd4c0bc4421e04764ee";
      };
    }
    {
      name = "lilconfig___lilconfig_2.0.4.tgz";
      path = fetchurl {
        name = "lilconfig___lilconfig_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/lilconfig/-/lilconfig-2.0.4.tgz";
        sha1 = "f4507d043d7058b380b6a8f5cb7bcd4b34cee082";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lines_and_columns___lines_and_columns_1.2.4.tgz";
      path = fetchurl {
        name = "lines_and_columns___lines_and_columns_1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-1.2.4.tgz";
<<<<<<< HEAD
        sha512 = "7ylylesZQ/PV29jhEDl3Ufjo6ZX7gCqJr5F7PKrqc93v7fzSymt1BpwEU8nAUXs8qzzvqhbjhK5QZg6Mt/HkBg==";
      };
    }
    {
      name = "loader_runner___loader_runner_4.3.0.tgz";
      path = fetchurl {
        name = "loader_runner___loader_runner_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/loader-runner/-/loader-runner-4.3.0.tgz";
        sha512 = "3R/1M+yS3j5ou80Me59j7F9IMs4PXs3VqRrm0TU3AbKPxlmpoY1TNscJV/oGJXo8qCatFGTfDbY6W6ipGOYXfg==";
      };
    }
    {
      name = "loader_utils___loader_utils_2.0.4.tgz";
      path = fetchurl {
        name = "loader_utils___loader_utils_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/loader-utils/-/loader-utils-2.0.4.tgz";
        sha512 = "xXqpXoINfFhgua9xiqD8fPFHgkoq1mmmpE92WlDbm9rNRd/EbRb+Gqf908T2DMfuHjjJlksiK2RbHVOdD/MqSw==";
=======
        sha1 = "eca284f75d2965079309dc0ad9255abb2ebc1632";
      };
    }
    {
      name = "loader_runner___loader_runner_4.2.0.tgz";
      path = fetchurl {
        name = "loader_runner___loader_runner_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/loader-runner/-/loader-runner-4.2.0.tgz";
        sha1 = "d7022380d66d14c5fb1d496b89864ebcfd478384";
      };
    }
    {
      name = "loader_utils___loader_utils_1.4.0.tgz";
      path = fetchurl {
        name = "loader_utils___loader_utils_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/loader-utils/-/loader-utils-1.4.0.tgz";
        sha1 = "c579b5e34cb34b1a74edc6c1fb36bfa371d5a613";
      };
    }
    {
      name = "loader_utils___loader_utils_2.0.2.tgz";
      path = fetchurl {
        name = "loader_utils___loader_utils_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/loader-utils/-/loader-utils-2.0.2.tgz";
        sha1 = "d6e3b4fb81870721ae4e0868ab11dd638368c129";
      };
    }
    {
      name = "locate_path___locate_path_2.0.0.tgz";
      path = fetchurl {
        name = "locate_path___locate_path_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz";
        sha1 = "2b568b265eec944c6d9c0de9c3dbbbca0354cd8e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "locate_path___locate_path_5.0.0.tgz";
      path = fetchurl {
        name = "locate_path___locate_path_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz";
<<<<<<< HEAD
        sha512 = "t7hw9pI+WvuwNJXwk5zVHpyhIqzg2qTlklJOf0mVxGSbe3Fp2VieZcduNYjaLDoy6p9uGpQEGWG87WpMKlNq8g==";
      };
    }
    {
      name = "lodash_es___lodash_es_4.17.21.tgz";
      path = fetchurl {
        name = "lodash_es___lodash_es_4.17.21.tgz";
        url  = "https://registry.yarnpkg.com/lodash-es/-/lodash-es-4.17.21.tgz";
        sha512 = "mKnC+QJ9pWVzv+C4/U3rRsHapFfHvQFoFB92e52xeyGMcX6/OlIl78je1u8vePzYZSkkogMPJ2yjxxsb89cxyw==";
=======
        sha1 = "1afba396afd676a6d42504d0a67a3a7eb9f62aa0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lodash.castarray___lodash.castarray_4.4.0.tgz";
      path = fetchurl {
        name = "lodash.castarray___lodash.castarray_4.4.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.castarray/-/lodash.castarray-4.4.0.tgz";
<<<<<<< HEAD
        sha512 = "aVx8ztPv7/2ULbArGJ2Y42bG1mEQ5mGjpdvrbJcJFU3TbYybe+QlLS4pst9zV52ymy2in1KpFPiZnAOATxD4+Q==";
=======
        sha1 = "c02513515e309daddd4c24c60cfddcf5976d9115";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lodash.debounce___lodash.debounce_4.0.8.tgz";
      path = fetchurl {
        name = "lodash.debounce___lodash.debounce_4.0.8.tgz";
        url  = "https://registry.yarnpkg.com/lodash.debounce/-/lodash.debounce-4.0.8.tgz";
<<<<<<< HEAD
        sha512 = "FT1yDzDYEoYWhnSGnpE/4Kj1fLZkDFyqRb7fNt6FdYOSxlUWAtp42Eh6Wb0rGIv/m9Bgo7x4GhQbm5Ys4SG5ow==";
=======
        sha1 = "82d79bff30a67c4005ffd5e2515300ad9ca4d7af";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lodash.isplainobject___lodash.isplainobject_4.0.6.tgz";
      path = fetchurl {
        name = "lodash.isplainobject___lodash.isplainobject_4.0.6.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz";
<<<<<<< HEAD
        sha512 = "oSXzaWypCMHkPC3NvBEaPHf0KsA5mvPrOPgQWDsbg8n7orZ290M0BmC/jgRZ4vcJ6DTAhjrsSYgdsW/F+MFOBA==";
=======
        sha1 = "7c526a52d89b45c45cc690b88163be0497f550cb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lodash.memoize___lodash.memoize_4.1.2.tgz";
      path = fetchurl {
        name = "lodash.memoize___lodash.memoize_4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.memoize/-/lodash.memoize-4.1.2.tgz";
<<<<<<< HEAD
        sha512 = "t7j+NzmgnQzTAYXcsHYLgimltOV1MXHtlOWf6GjL9Kj8GK5FInw5JotxvbOs+IvV1/Dzo04/fCGfLVs7aXb4Ag==";
=======
        sha1 = "bcc6c49a42a2840ed997f323eada5ecd182e0bfe";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lodash.merge___lodash.merge_4.6.2.tgz";
      path = fetchurl {
        name = "lodash.merge___lodash.merge_4.6.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz";
<<<<<<< HEAD
        sha512 = "0KpjqXRVvrYyCsX1swR/XTK0va6VQkQM6MNo7PqW77ByjAhoARA8EfrP1N4+KlKj8YS0ZUCtRT/YUuhyYDujIQ==";
=======
        sha1 = "558aa53b43b661e1925a0afdfa36a9a1085fe57a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lodash.topath___lodash.topath_4.5.2.tgz";
      path = fetchurl {
        name = "lodash.topath___lodash.topath_4.5.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.topath/-/lodash.topath-4.5.2.tgz";
<<<<<<< HEAD
        sha512 = "1/W4dM+35DwvE/iEd1M9ekewOSTlpFekhw9mhAtrwjVqUr83/ilQiyAvmg4tVX7Unkcfl1KC+i9WdaT4B6aQcg==";
=======
        sha1 = "3616351f3bba61994a0931989660bd03254fd009";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lodash.truncate___lodash.truncate_4.4.2.tgz";
      path = fetchurl {
        name = "lodash.truncate___lodash.truncate_4.4.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.truncate/-/lodash.truncate-4.4.2.tgz";
<<<<<<< HEAD
        sha512 = "jttmRe7bRse52OsWIMDLaXxWqRAmtIUccAQ3garviCqJjafXOfNMO0yMfNpdD6zbGaTU0P5Nz7e7gAT6cKmJRw==";
=======
        sha1 = "5a350da0b1113b837ecfffd5812cbe58d6eae193";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lodash.uniq___lodash.uniq_4.5.0.tgz";
      path = fetchurl {
        name = "lodash.uniq___lodash.uniq_4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.uniq/-/lodash.uniq-4.5.0.tgz";
<<<<<<< HEAD
        sha512 = "xfBaXQd9ryd9dlSDvnvI0lvxfLJlYAZzXomUYzLKtUeOQvOP5piqAWuGtrhWeqaXK9hhoM/iyJc5AV+XfsX3HQ==";
=======
        sha1 = "d0225373aeb652adc1bc82e4945339a842754773";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lodash___lodash_4.17.21.tgz";
      path = fetchurl {
        name = "lodash___lodash_4.17.21.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz";
<<<<<<< HEAD
        sha512 = "v2kDEe57lecTulaDIuNTPy3Ry4gLGJ6Z1O3vE1krgXZNrsQ+LFTGHVxVjcXPs17LhbZVGedAJv8XZ1tvj5FvSg==";
=======
        sha1 = "679591c564c3bffaae8454cf0b3df370c3d6911c";
      };
    }
    {
      name = "log_symbols___log_symbols_4.1.0.tgz";
      path = fetchurl {
        name = "log_symbols___log_symbols_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/log-symbols/-/log-symbols-4.1.0.tgz";
        sha1 = "3fbdbb95b4683ac9fc785111e792e558d4abd503";
      };
    }
    {
      name = "longest_streak___longest_streak_2.0.4.tgz";
      path = fetchurl {
        name = "longest_streak___longest_streak_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/longest-streak/-/longest-streak-2.0.4.tgz";
        sha1 = "b8599957da5b5dab64dee3fe316fa774597d90e4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "loose_envify___loose_envify_1.4.0.tgz";
      path = fetchurl {
        name = "loose_envify___loose_envify_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/loose-envify/-/loose-envify-1.4.0.tgz";
<<<<<<< HEAD
        sha512 = "lyuxPGr/Wfhrlem2CL/UcnUc1zcqKAImBDzukY7Y5F/yQiNdko6+fRLevlw1HgMySw7f611UIY408EtxRSoK3Q==";
      };
    }
    {
      name = "lru_cache___lru_cache_5.1.1.tgz";
      path = fetchurl {
        name = "lru_cache___lru_cache_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-5.1.1.tgz";
        sha512 = "KpNARQA3Iwv+jTA0utUVVbrh+Jlrr1Fv0e56GGzAFOXN7dk/FviaDW8LHmK52DlcH4WP2n6gI8vN1aesBFgo9w==";
=======
        sha1 = "71ee51fa7be4caec1a63839f7e682d8132d30caf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "lru_cache___lru_cache_6.0.0.tgz";
      path = fetchurl {
        name = "lru_cache___lru_cache_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz";
<<<<<<< HEAD
        sha512 = "Jo6dJ04CmSjuznwJSS3pUeWmd/H0ffTlkXXgwZi+eq1UCmqQwCh+eLsYOYCwY991i2Fah4h1BEMCx4qThGbsiA==";
=======
        sha1 = "6d6fe6570ebd96aaf90fcad1dafa3b2566db3a94";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "magic_string___magic_string_0.22.5.tgz";
      path = fetchurl {
        name = "magic_string___magic_string_0.22.5.tgz";
        url  = "https://registry.yarnpkg.com/magic-string/-/magic-string-0.22.5.tgz";
<<<<<<< HEAD
        sha512 = "oreip9rJZkzvA8Qzk9HFs8fZGF/u7H/gtrE8EN6RjKJ9kh2HlC+yQ2QezifqTZfGyiuAV0dRv5a+y/8gBb1m9w==";
=======
        sha1 = "8e9cf5afddf44385c1da5bc2a6a0dbd10b03657e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "make_dir___make_dir_3.1.0.tgz";
      path = fetchurl {
        name = "make_dir___make_dir_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz";
<<<<<<< HEAD
        sha512 = "g3FeP20LNwhALb/6Cz6Dd4F2ngze0jz7tbzrD2wAV+o9FeNHe4rL+yK2md0J/fiSf1sa1ADhXqi5+oVwOM/eGw==";
=======
        sha1 = "415e967046b3a7f1d185277d84aa58203726a13f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "map_obj___map_obj_1.0.1.tgz";
      path = fetchurl {
        name = "map_obj___map_obj_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/map-obj/-/map-obj-1.0.1.tgz";
<<<<<<< HEAD
        sha512 = "7N/q3lyZ+LVCp7PzuxrJr4KMbBE2hW7BT7YNia330OFxIf4d3r5zVpicP2650l7CPN6RM9zOJRl3NGpqSiw3Eg==";
=======
        sha1 = "d933ceb9205d82bdcf4886f6742bdc2b4dea146d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "map_obj___map_obj_4.3.0.tgz";
      path = fetchurl {
        name = "map_obj___map_obj_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/map-obj/-/map-obj-4.3.0.tgz";
<<<<<<< HEAD
        sha512 = "hdN1wVrZbb29eBGiGjJbeP8JbKjq1urkHJ/LIP/NY48MZ1QVXUsQBV1G1zvYFHn1XE06cwjBsOI2K3Ulnj1YXQ==";
=======
        sha1 = "9304f906e93faae70880da102a9f1df0ea8bb05a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "mathml_tag_names___mathml_tag_names_2.1.3.tgz";
      path = fetchurl {
        name = "mathml_tag_names___mathml_tag_names_2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/mathml-tag-names/-/mathml-tag-names-2.1.3.tgz";
<<<<<<< HEAD
        sha512 = "APMBEanjybaPzUrfqU0IMU5I0AswKMH7k8OTLs0vvV4KZpExkTkY87nR/zpbuTPj+gARop7aGUbl11pnDfW6xg==";
=======
        sha1 = "4ddadd67308e780cf16a47685878ee27b736a0a3";
      };
    }
    {
      name = "mdast_util_from_markdown___mdast_util_from_markdown_0.8.5.tgz";
      path = fetchurl {
        name = "mdast_util_from_markdown___mdast_util_from_markdown_0.8.5.tgz";
        url  = "https://registry.yarnpkg.com/mdast-util-from-markdown/-/mdast-util-from-markdown-0.8.5.tgz";
        sha1 = "d1ef2ca42bc377ecb0463a987910dae89bd9a28c";
      };
    }
    {
      name = "mdast_util_to_markdown___mdast_util_to_markdown_0.6.5.tgz";
      path = fetchurl {
        name = "mdast_util_to_markdown___mdast_util_to_markdown_0.6.5.tgz";
        url  = "https://registry.yarnpkg.com/mdast-util-to-markdown/-/mdast-util-to-markdown-0.6.5.tgz";
        sha1 = "b33f67ca820d69e6cc527a93d4039249b504bebe";
      };
    }
    {
      name = "mdast_util_to_string___mdast_util_to_string_2.0.0.tgz";
      path = fetchurl {
        name = "mdast_util_to_string___mdast_util_to_string_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/mdast-util-to-string/-/mdast-util-to-string-2.0.0.tgz";
        sha1 = "b8cfe6a713e1091cb5b728fc48885a4767f8b97b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "mdn_data___mdn_data_2.0.14.tgz";
      path = fetchurl {
        name = "mdn_data___mdn_data_2.0.14.tgz";
        url  = "https://registry.yarnpkg.com/mdn-data/-/mdn-data-2.0.14.tgz";
<<<<<<< HEAD
        sha512 = "dn6wd0uw5GsdswPFfsgMp5NSB0/aDe6fK94YJV/AJDYXL6HVLWBsxeq7js7Ad+mU2K9LAlwpk6kN2D5mwCPVow==";
=======
        sha1 = "7113fc4281917d63ce29b43446f701e68c25ba50";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "meow___meow_9.0.0.tgz";
      path = fetchurl {
        name = "meow___meow_9.0.0.tgz";
        url  = "https://registry.yarnpkg.com/meow/-/meow-9.0.0.tgz";
<<<<<<< HEAD
        sha512 = "+obSblOQmRhcyBt62furQqRAQpNyWXo8BuQ5bN7dG8wmwQ+vwHKp/rCFD4CrTP8CsDQD1sjoZ94K417XEUk8IQ==";
=======
        sha1 = "cd9510bc5cac9dee7d03c73ee1f9ad959f4ea364";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "merge_source_map___merge_source_map_1.0.4.tgz";
      path = fetchurl {
        name = "merge_source_map___merge_source_map_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/merge-source-map/-/merge-source-map-1.0.4.tgz";
<<<<<<< HEAD
        sha512 = "PGSmS0kfnTnMJCzJ16BLLCEe6oeYCamKFFdQKshi4BmM6FUwipjVOcBFGxqtQtirtAG4iZvHlqST9CpZKqlRjA==";
=======
        sha1 = "a5de46538dae84d4114cc5ea02b4772a6346701f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "merge_stream___merge_stream_2.0.0.tgz";
      path = fetchurl {
        name = "merge_stream___merge_stream_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz";
<<<<<<< HEAD
        sha512 = "abv/qOcuPfk3URPfDzmZU1LKmuw8kT+0nIHvKrKgFrwifol/doWcdA4ZqsWQ8ENrFKkd67Mfpo/LovbIUsbt3w==";
=======
        sha1 = "52823629a14dd00c9770fb6ad47dc6310f2c1f60";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "merge2___merge2_1.4.1.tgz";
      path = fetchurl {
        name = "merge2___merge2_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz";
<<<<<<< HEAD
        sha512 = "8q7VEgMJW4J8tcfVPy8g09NcQwZdbwFEqhe/WZkoIzjn/3TGDwtOCYtXGxA3O8tPzpczCCDgv+P2P5y00ZJOOg==";
      };
    }
    {
      name = "micromatch___micromatch_4.0.5.tgz";
      path = fetchurl {
        name = "micromatch___micromatch_4.0.5.tgz";
        url  = "https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.5.tgz";
        sha512 = "DMy+ERcEW2q8Z2Po+WNXuw3c5YaUSFjAO5GsJqfEl7UjvtIuFKO6ZrKvcItdy98dwFI2N1tg3zNIdKaQT+aNdA==";
      };
    }
    {
      name = "mime_db___mime_db_1.52.0.tgz";
      path = fetchurl {
        name = "mime_db___mime_db_1.52.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.52.0.tgz";
        sha512 = "sPU4uV7dYlvtWJxwwxHD0PuihVNiE7TyAbQ5SWxDCB9mUYvOgroQOwYQQOKPJ8CIbE+1ETVlOoK1UC2nU3gYvg==";
      };
    }
    {
      name = "mime_types___mime_types_2.1.35.tgz";
      path = fetchurl {
        name = "mime_types___mime_types_2.1.35.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.35.tgz";
        sha512 = "ZDY+bPm5zTTF+YpCrAU9nK0UgICYPT0QtT1NZWFv4s++TNkcgVaT0g6+4R2uI4MjQjzysHB1zxuWL50hzaeXiw==";
=======
        sha1 = "4368892f885e907455a6fd7dc55c0c9d404990ae";
      };
    }
    {
      name = "micromark___micromark_2.11.4.tgz";
      path = fetchurl {
        name = "micromark___micromark_2.11.4.tgz";
        url  = "https://registry.yarnpkg.com/micromark/-/micromark-2.11.4.tgz";
        sha1 = "d13436138eea826383e822449c9a5c50ee44665a";
      };
    }
    {
      name = "micromatch___micromatch_4.0.4.tgz";
      path = fetchurl {
        name = "micromatch___micromatch_4.0.4.tgz";
        url  = "https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.4.tgz";
        sha1 = "896d519dfe9db25fce94ceb7a500919bf881ebf9";
      };
    }
    {
      name = "mime_db___mime_db_1.51.0.tgz";
      path = fetchurl {
        name = "mime_db___mime_db_1.51.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.51.0.tgz";
        sha1 = "d9ff62451859b18342d960850dc3cfb77e63fb0c";
      };
    }
    {
      name = "mime_types___mime_types_2.1.34.tgz";
      path = fetchurl {
        name = "mime_types___mime_types_2.1.34.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.34.tgz";
        sha1 = "5a712f9ec1503511a945803640fafe09d3793c24";
      };
    }
    {
      name = "mimic_fn___mimic_fn_2.1.0.tgz";
      path = fetchurl {
        name = "mimic_fn___mimic_fn_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz";
        sha1 = "7ed2c2ccccaf84d3ffcb7a69b57711fc2083401b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "min_indent___min_indent_1.0.1.tgz";
      path = fetchurl {
        name = "min_indent___min_indent_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/min-indent/-/min-indent-1.0.1.tgz";
<<<<<<< HEAD
        sha512 = "I9jwMn07Sy/IwOj3zVkVik2JTvgpaykDZEigL6Rx6N9LbMywwUSMtxET+7lVoDLLd3O3IXwJwvuuns8UB/HeAg==";
=======
        sha1 = "a63f681673b30571fbe8bc25686ae746eefa9869";
      };
    }
    {
      name = "mini_create_react_context___mini_create_react_context_0.4.1.tgz";
      path = fetchurl {
        name = "mini_create_react_context___mini_create_react_context_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/mini-create-react-context/-/mini-create-react-context-0.4.1.tgz";
        sha1 = "072171561bfdc922da08a60c2197a497cc2d1d5e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "mini_css_extract_plugin___mini_css_extract_plugin_1.6.2.tgz";
      path = fetchurl {
        name = "mini_css_extract_plugin___mini_css_extract_plugin_1.6.2.tgz";
        url  = "https://registry.yarnpkg.com/mini-css-extract-plugin/-/mini-css-extract-plugin-1.6.2.tgz";
<<<<<<< HEAD
        sha512 = "WhDvO3SjGm40oV5y26GjMJYjd2UMqrLAGKy5YS2/3QKJy2F7jgynuHTir/tgUUOiNQu5saXHdc8reo7YuhhT4Q==";
      };
    }
    {
      name = "mini_svg_data_uri___mini_svg_data_uri_1.4.4.tgz";
      path = fetchurl {
        name = "mini_svg_data_uri___mini_svg_data_uri_1.4.4.tgz";
        url  = "https://registry.yarnpkg.com/mini-svg-data-uri/-/mini-svg-data-uri-1.4.4.tgz";
        sha512 = "r9deDe9p5FJUPZAk3A59wGH7Ii9YrjjWw0jmw/liSbHl2CHiyXj6FcDXDu2K3TjVAXqiJdaw3xxwlZZr9E6nHg==";
      };
    }
    {
      name = "minimatch___minimatch_3.1.2.tgz";
      path = fetchurl {
        name = "minimatch___minimatch_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz";
        sha512 = "J7p63hRiAjw1NDEww1W7i37+ByIrOWO5XQQAzZ3VOcL0PNybwpfmV/N05zFAzwQ9USyEcX6t3UO+K5aqBQOIHw==";
=======
        sha1 = "83172b4fd812f8fc4a09d6f6d16f924f53990ca8";
      };
    }
    {
      name = "mini_svg_data_uri___mini_svg_data_uri_1.4.3.tgz";
      path = fetchurl {
        name = "mini_svg_data_uri___mini_svg_data_uri_1.4.3.tgz";
        url  = "https://registry.yarnpkg.com/mini-svg-data-uri/-/mini-svg-data-uri-1.4.3.tgz";
        sha1 = "43177b2e93766ba338931a3e2a84a3dfd3a222b8";
      };
    }
    {
      name = "minimatch___minimatch_3.0.4.tgz";
      path = fetchurl {
        name = "minimatch___minimatch_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz";
        sha1 = "5166e286457f03306064be5497e8dbb0c3d32083";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "minimist_options___minimist_options_4.1.0.tgz";
      path = fetchurl {
        name = "minimist_options___minimist_options_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/minimist-options/-/minimist-options-4.1.0.tgz";
<<<<<<< HEAD
        sha512 = "Q4r8ghd80yhO/0j1O3B2BjweX3fiHg9cdOwjJd2J76Q135c+NDxGCqdYKQ1SKBuFfgWbAUzBfvYjPUEeNgqN1A==";
      };
    }
    {
      name = "minimist___minimist_1.2.8.tgz";
      path = fetchurl {
        name = "minimist___minimist_1.2.8.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz";
        sha512 = "2yyAR8qBkN3YuheJanUpWC5U3bb5osDywNB8RzDVlDwDHbocAJveqqj1u8+SVD7jkWT4yvsHCpWqqWqAxb0zCA==";
=======
        sha1 = "c0655713c53a8a2ebd77ffa247d342c40f010619";
      };
    }
    {
      name = "minimist___minimist_1.2.5.tgz";
      path = fetchurl {
        name = "minimist___minimist_1.2.5.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-1.2.5.tgz";
        sha1 = "67d66014b66a6a8aaa0c083c5fd58df4e4e97602";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "modern_normalize___modern_normalize_1.1.0.tgz";
      path = fetchurl {
        name = "modern_normalize___modern_normalize_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/modern-normalize/-/modern-normalize-1.1.0.tgz";
<<<<<<< HEAD
        sha512 = "2lMlY1Yc1+CUy0gw4H95uNN7vjbpoED7NNRSBHE25nWfLBdmMzFCsPshlzbxHz+gYMcBEUN8V4pU16prcdPSgA==";
      };
    }
    {
      name = "mrmime___mrmime_1.0.1.tgz";
      path = fetchurl {
        name = "mrmime___mrmime_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/mrmime/-/mrmime-1.0.1.tgz";
        sha512 = "hzzEagAgDyoU1Q6yg5uI+AorQgdvMCur3FcKf7NhMKWsaYg+RnbTyHRa/9IlLF9rf455MOCtcqqrQQ83pPP7Uw==";
=======
        sha1 = "da8e80140d9221426bd4f725c6e11283d34f90b7";
      };
    }
    {
      name = "mrmime___mrmime_1.0.0.tgz";
      path = fetchurl {
        name = "mrmime___mrmime_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/mrmime/-/mrmime-1.0.0.tgz";
        sha1 = "14d387f0585a5233d291baba339b063752a2398b";
      };
    }
    {
      name = "ms___ms_2.0.0.tgz";
      path = fetchurl {
        name = "ms___ms_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz";
        sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ms___ms_2.1.2.tgz";
      path = fetchurl {
        name = "ms___ms_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz";
<<<<<<< HEAD
        sha512 = "sGkPx+VjMtmA6MX27oA4FBFELFCZZ4S4XqeGOXCv68tT+jb3vk/RyaKWP0PTKyWtmLSM0b+adUTEvbs1PEaH2w==";
=======
        sha1 = "d09d1f357b443f493382a8eb3ccd183872ae6009";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "ms___ms_2.1.3.tgz";
      path = fetchurl {
        name = "ms___ms_2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz";
<<<<<<< HEAD
        sha512 = "6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA==";
      };
    }
    {
      name = "nanoclone___nanoclone_0.2.1.tgz";
      path = fetchurl {
        name = "nanoclone___nanoclone_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/nanoclone/-/nanoclone-0.2.1.tgz";
        sha512 = "wynEP02LmIbLpcYw8uBKpcfF6dmg2vcpKqxeH5UcoKEYdExslsdUA4ugFauuaeYdTB76ez6gJW8XAZ6CgkXYxA==";
      };
    }
    {
      name = "nanoid___nanoid_3.3.6.tgz";
      path = fetchurl {
        name = "nanoid___nanoid_3.3.6.tgz";
        url  = "https://registry.yarnpkg.com/nanoid/-/nanoid-3.3.6.tgz";
        sha512 = "BGcqMMJuToF7i1rt+2PWSNVnWIkGCU78jBG3RxO/bZlnZPK2Cmi2QaffxGO/2RvWi9sL+FAiRiXMgsyxQ1DIDA==";
=======
        sha1 = "574c8138ce1d2b5861f0b44579dbadd60c6615b2";
      };
    }
    {
      name = "nanoid___nanoid_3.2.0.tgz";
      path = fetchurl {
        name = "nanoid___nanoid_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/nanoid/-/nanoid-3.2.0.tgz";
        sha1 = "62667522da6673971cca916a6d3eff3f415ff80c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "natural_compare___natural_compare_1.4.0.tgz";
      path = fetchurl {
        name = "natural_compare___natural_compare_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz";
<<<<<<< HEAD
        sha512 = "OWND8ei3VtNC9h7V60qff3SVobHr996CTwgxubgyQYEpg290h9J0buyECNNJexkFm5sOajh5G116RYA1c8ZMSw==";
=======
        sha1 = "4abebfeed7541f2c27acfb29bdbbd15c8d5ba4f7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "neo_async___neo_async_2.6.2.tgz";
      path = fetchurl {
        name = "neo_async___neo_async_2.6.2.tgz";
        url  = "https://registry.yarnpkg.com/neo-async/-/neo-async-2.6.2.tgz";
<<<<<<< HEAD
        sha512 = "Yd3UES5mWCSqR+qNT93S3UoYUkqAZ9lLg8a7g9rimsWmYGK8cVToA4/sF3RrshdyV3sAGMXVUmpMYOw+dLpOuw==";
=======
        sha1 = "b4aafb93e3aeb2d8174ca53cf163ab7d7308305f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "node_emoji___node_emoji_1.11.0.tgz";
      path = fetchurl {
        name = "node_emoji___node_emoji_1.11.0.tgz";
        url  = "https://registry.yarnpkg.com/node-emoji/-/node-emoji-1.11.0.tgz";
<<<<<<< HEAD
        sha512 = "wo2DpQkQp7Sjm2A0cq+sN7EHKO6Sl0ctXeBdFZrL9T9+UywORbufTcTZxom8YqpLQt/FqNMUkOpkZrJVYSKD3A==";
      };
    }
    {
      name = "node_releases___node_releases_2.0.10.tgz";
      path = fetchurl {
        name = "node_releases___node_releases_2.0.10.tgz";
        url  = "https://registry.yarnpkg.com/node-releases/-/node-releases-2.0.10.tgz";
        sha512 = "5GFldHPXVG/YZmFzJvKK2zDSzPKhEp0+ZR5SVaoSag9fsL5YgHbUHDfnG5494ISANDcK4KwPXAx2xqVEydmd7w==";
=======
        sha1 = "69a0150e6946e2f115e9d7ea4df7971e2628301c";
      };
    }
    {
      name = "node_releases___node_releases_2.0.1.tgz";
      path = fetchurl {
        name = "node_releases___node_releases_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/node-releases/-/node-releases-2.0.1.tgz";
        sha1 = "3d1d395f204f1f2f29a54358b9fb678765ad2fc5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "normalize_package_data___normalize_package_data_2.5.0.tgz";
      path = fetchurl {
        name = "normalize_package_data___normalize_package_data_2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz";
<<<<<<< HEAD
        sha512 = "/5CMN3T0R4XTj4DcGaexo+roZSdSFW/0AOOTROrjxzCG1wrWXEsGbRKevjlIL+ZDE4sZlJr5ED4YW0yqmkK+eA==";
=======
        sha1 = "e66db1838b200c1dfc233225d12cb36520e234a8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "normalize_package_data___normalize_package_data_3.0.3.tgz";
      path = fetchurl {
        name = "normalize_package_data___normalize_package_data_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-3.0.3.tgz";
<<<<<<< HEAD
        sha512 = "p2W1sgqij3zMMyRC067Dg16bfzVH+w7hyegmpIvZ4JNjqtGOVAIvLmjBx3yP7YTe9vKJgkoNOPjwQGogDoMXFA==";
=======
        sha1 = "dbcc3e2da59509a0983422884cd172eefdfa525e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "normalize_path___normalize_path_3.0.0.tgz";
      path = fetchurl {
        name = "normalize_path___normalize_path_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "6eZs5Ls3WtCisHWp9S2GUy8dqkpGi4BVSz3GaqiE6ezub0512ESztXUwUB6C6IKbQkY2Pnb/mD4WYojCRwcwLA==";
=======
        sha1 = "0dcd69ff23a1c9b11fd0978316644a0388216a65";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "normalize_range___normalize_range_0.1.2.tgz";
      path = fetchurl {
        name = "normalize_range___normalize_range_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/normalize-range/-/normalize-range-0.1.2.tgz";
<<<<<<< HEAD
        sha512 = "bdok/XvKII3nUpklnV6P2hxtMNrCboOjAcyBuQnWEhO665FwrSNRxU+AqpsyvO6LgGYPspN+lu5CLtw4jPRKNA==";
=======
        sha1 = "2d10c06bdfd312ea9777695a4d28439456b75942";
      };
    }
    {
      name = "normalize_selector___normalize_selector_0.2.0.tgz";
      path = fetchurl {
        name = "normalize_selector___normalize_selector_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-selector/-/normalize-selector-0.2.0.tgz";
        sha1 = "d0b145eb691189c63a78d201dc4fdb1293ef0c03";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "normalize_url___normalize_url_6.1.0.tgz";
      path = fetchurl {
        name = "normalize_url___normalize_url_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-url/-/normalize-url-6.1.0.tgz";
<<<<<<< HEAD
        sha512 = "DlL+XwOy3NxAQ8xuC0okPgK46iuVNAK01YN7RueYBqqFeGsBjV9XmCAzAdgt+667bCl5kPh9EqKKDwnaPG1I7A==";
      };
    }
    {
      name = "nth_check___nth_check_2.1.1.tgz";
      path = fetchurl {
        name = "nth_check___nth_check_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/nth-check/-/nth-check-2.1.1.tgz";
        sha512 = "lqjrjmaOoAnWfMmBPL+XNnynZh2+swxiX3WUE0s4yEHI6m+AwrK2UZOimIRl3X/4QctVqS8AiZjFqyOGrMXb/w==";
=======
        sha1 = "40d0885b535deffe3f3147bec877d05fe4c5668a";
      };
    }
    {
      name = "npm_run_path___npm_run_path_4.0.1.tgz";
      path = fetchurl {
        name = "npm_run_path___npm_run_path_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-4.0.1.tgz";
        sha1 = "b7ecd1e5ed53da8e37a55e1c2269e0b97ed748ea";
      };
    }
    {
      name = "nth_check___nth_check_2.0.1.tgz";
      path = fetchurl {
        name = "nth_check___nth_check_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/nth-check/-/nth-check-2.0.1.tgz";
        sha1 = "2efe162f5c3da06a28959fbd3db75dbeea9f0fc2";
      };
    }
    {
      name = "num2fraction___num2fraction_1.2.2.tgz";
      path = fetchurl {
        name = "num2fraction___num2fraction_1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/num2fraction/-/num2fraction-1.2.2.tgz";
        sha1 = "6f682b6a027a4e9ddfa4564cd2589d1d4e669ede";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "object_assign___object_assign_4.1.1.tgz";
      path = fetchurl {
        name = "object_assign___object_assign_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz";
<<<<<<< HEAD
        sha512 = "rJgTQnkUnH1sFw8yT6VSU3zD3sWmu6sZhIseY8VX+GRu3P6F7Fu+JNDoXfklElbLJSnc3FUQHVe4cU5hj+BcUg==";
=======
        sha1 = "2109adc7965887cfc05cbbd442cac8bfbb360863";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "object_hash___object_hash_2.2.0.tgz";
      path = fetchurl {
        name = "object_hash___object_hash_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/object-hash/-/object-hash-2.2.0.tgz";
<<<<<<< HEAD
        sha512 = "gScRMn0bS5fH+IuwyIFgnh9zBdo4DV+6GhygmWM9HyNJSgS0hScp1f5vjtm7oIIOiT9trXrShAkLFSc2IqKNgw==";
      };
    }
    {
      name = "object_inspect___object_inspect_1.12.3.tgz";
      path = fetchurl {
        name = "object_inspect___object_inspect_1.12.3.tgz";
        url  = "https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.3.tgz";
        sha512 = "geUvdk7c+eizMNUDkRpW1wJwgfOiOeHbxBR/hLXK1aT6zmVSO0jsQcs7fj6MGw89jC/cjGfLcNOrtMYtGqm81g==";
=======
        sha1 = "5ad518581eefc443bd763472b8ff2e9c2c0d54a5";
      };
    }
    {
      name = "object_inspect___object_inspect_1.12.0.tgz";
      path = fetchurl {
        name = "object_inspect___object_inspect_1.12.0.tgz";
        url  = "https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.0.tgz";
        sha1 = "6e2c120e868fd1fd18cb4f18c31741d0d6e776f0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "object_inspect___object_inspect_1.4.1.tgz";
      path = fetchurl {
        name = "object_inspect___object_inspect_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.4.1.tgz";
<<<<<<< HEAD
        sha512 = "wqdhLpfCUbEsoEwl3FXwGyv8ief1k/1aUdIPCqVnupM6e8l63BEJdiF/0swtn04/8p05tG/T0FrpTlfwvljOdw==";
      };
    }
    {
      name = "object_is___object_is_1.1.5.tgz";
      path = fetchurl {
        name = "object_is___object_is_1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/object-is/-/object-is-1.1.5.tgz";
        sha512 = "3cyDsyHgtmi7I7DfSSI2LDp6SK2lwvtbg0p0R1e0RvTqF5ceGx+K2dfSjm1bKDMVCFEDAQvy+o8c6a7VujOddw==";
=======
        sha1 = "37ffb10e71adaf3748d05f713b4c9452f402cbc4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "object_keys___object_keys_1.1.1.tgz";
      path = fetchurl {
        name = "object_keys___object_keys_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz";
<<<<<<< HEAD
        sha512 = "NuAESUOUMrlIXOfHKzD6bpPu3tYt3xvjNdRIQ+FeT0lNb4K8WR70CaDxhuNguS2XG+GjkyMwOzsN5ZktImfhLA==";
      };
    }
    {
      name = "object.assign___object.assign_4.1.4.tgz";
      path = fetchurl {
        name = "object.assign___object.assign_4.1.4.tgz";
        url  = "https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.4.tgz";
        sha512 = "1mxKf0e58bvyjSCtKYY4sRe9itRk3PJpquJOjeIkz885CczcI4IvJJDLPS72oowuSh+pBxUFROpX+TU++hxhZQ==";
      };
    }
    {
      name = "object.entries___object.entries_1.1.6.tgz";
      path = fetchurl {
        name = "object.entries___object.entries_1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/object.entries/-/object.entries-1.1.6.tgz";
        sha512 = "leTPzo4Zvg3pmbQ3rDK69Rl8GQvIqMWubrkxONG9/ojtFE2rD9fjMKfSI5BxW3osRH1m6VdzmqK8oAY9aT4x5w==";
      };
    }
    {
      name = "object.fromentries___object.fromentries_2.0.6.tgz";
      path = fetchurl {
        name = "object.fromentries___object.fromentries_2.0.6.tgz";
        url  = "https://registry.yarnpkg.com/object.fromentries/-/object.fromentries-2.0.6.tgz";
        sha512 = "VciD13dswC4j1Xt5394WR4MzmAQmlgN72phd/riNp9vtD7tp4QQWJ0R4wvclXcafgcYK8veHRed2W6XeGBvcfg==";
      };
    }
    {
      name = "object.hasown___object.hasown_1.1.2.tgz";
      path = fetchurl {
        name = "object.hasown___object.hasown_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/object.hasown/-/object.hasown-1.1.2.tgz";
        sha512 = "B5UIT3J1W+WuWIU55h0mjlwaqxiE5vYENJXIXZ4VFe05pNYrkKuK0U/6aFcb0pKywYJh7IhfoqUfKVmrJJHZHw==";
      };
    }
    {
      name = "object.values___object.values_1.1.6.tgz";
      path = fetchurl {
        name = "object.values___object.values_1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/object.values/-/object.values-1.1.6.tgz";
        sha512 = "FVVTkD1vENCsAcwNs9k6jea2uHC/X0+JcjG8YA60FN5CMaJmG95wT9jek/xX9nornqGRrBkKtzuAu2wuHpKqvw==";
=======
        sha1 = "1c47f272df277f3b1daf061677d9c82e2322c60e";
      };
    }
    {
      name = "object.assign___object.assign_4.1.2.tgz";
      path = fetchurl {
        name = "object.assign___object.assign_4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.2.tgz";
        sha1 = "0ed54a342eceb37b38ff76eb831a0e788cb63940";
      };
    }
    {
      name = "object.entries___object.entries_1.1.5.tgz";
      path = fetchurl {
        name = "object.entries___object.entries_1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/object.entries/-/object.entries-1.1.5.tgz";
        sha1 = "e1acdd17c4de2cd96d5a08487cfb9db84d881861";
      };
    }
    {
      name = "object.fromentries___object.fromentries_2.0.5.tgz";
      path = fetchurl {
        name = "object.fromentries___object.fromentries_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/object.fromentries/-/object.fromentries-2.0.5.tgz";
        sha1 = "7b37b205109c21e741e605727fe8b0ad5fa08251";
      };
    }
    {
      name = "object.hasown___object.hasown_1.1.0.tgz";
      path = fetchurl {
        name = "object.hasown___object.hasown_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/object.hasown/-/object.hasown-1.1.0.tgz";
        sha1 = "7232ed266f34d197d15cac5880232f7a4790afe5";
      };
    }
    {
      name = "object.values___object.values_1.1.5.tgz";
      path = fetchurl {
        name = "object.values___object.values_1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/object.values/-/object.values-1.1.5.tgz";
        sha1 = "959f63e3ce9ef108720333082131e4a459b716ac";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "once___once_1.4.0.tgz";
      path = fetchurl {
        name = "once___once_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/once/-/once-1.4.0.tgz";
<<<<<<< HEAD
        sha512 = "lNaJgI+2Q5URQBkccEKHTQOPaXdUxnZZElQTZY0MFUAuaEqe1E+Nyvgdz/aIyNi6Z9MzO5dv1H8n58/GELp3+w==";
=======
        sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
      };
    }
    {
      name = "onetime___onetime_5.1.2.tgz";
      path = fetchurl {
        name = "onetime___onetime_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/onetime/-/onetime-5.1.2.tgz";
        sha1 = "d0e96ebb56b07476df1dd9c4806e5237985ca45e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "opener___opener_1.5.2.tgz";
      path = fetchurl {
        name = "opener___opener_1.5.2.tgz";
        url  = "https://registry.yarnpkg.com/opener/-/opener-1.5.2.tgz";
<<<<<<< HEAD
        sha512 = "ur5UIdyw5Y7yEj9wLzhqXiy6GZ3Mwx0yGI+5sMn2r0N0v3cKJvUmFH5yPP+WXh9e0xfyzyJX95D8l088DNFj7A==";
=======
        sha1 = "5d37e1f35077b9dcac4301372271afdeb2a13598";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "optimist___optimist_0.3.7.tgz";
      path = fetchurl {
        name = "optimist___optimist_0.3.7.tgz";
        url  = "https://registry.yarnpkg.com/optimist/-/optimist-0.3.7.tgz";
<<<<<<< HEAD
        sha512 = "TCx0dXQzVtSCg2OgY/bO9hjM9cV4XYx09TVK+s3+FhkjT6LovsLe+pPMzpWf+6yXK/hUizs2gUoTw3jHM0VaTQ==";
=======
        sha1 = "c90941ad59e4273328923074d2cf2e7cbc6ec0d9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "optionator___optionator_0.8.3.tgz";
      path = fetchurl {
        name = "optionator___optionator_0.8.3.tgz";
        url  = "https://registry.yarnpkg.com/optionator/-/optionator-0.8.3.tgz";
<<<<<<< HEAD
        sha512 = "+IW9pACdk3XWmmTXG8m3upGUJst5XRGzxMRjXzAuJ1XnIFNvfhjjIuYkDvysnPQ7qzqVzLt78BCruntqRhWQbA==";
=======
        sha1 = "84fa1d036fe9d3c7e21d99884b601167ec8fb495";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "optionator___optionator_0.9.1.tgz";
      path = fetchurl {
        name = "optionator___optionator_0.9.1.tgz";
        url  = "https://registry.yarnpkg.com/optionator/-/optionator-0.9.1.tgz";
<<<<<<< HEAD
        sha512 = "74RlY5FCnhq4jRxVUPKDaRwrVNXMqsGsiW6AJw4XK8hmtm10wC0ypZBLw5IIp85NZMr91+qd1RvvENwg7jjRFw==";
=======
        sha1 = "4f236a6373dae0566a6d43e1326674f50c291499";
      };
    }
    {
      name = "p_limit___p_limit_1.3.0.tgz";
      path = fetchurl {
        name = "p_limit___p_limit_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/p-limit/-/p-limit-1.3.0.tgz";
        sha1 = "b86bd5f0c25690911c7590fcbfc2010d54b3ccb8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "p_limit___p_limit_2.3.0.tgz";
      path = fetchurl {
        name = "p_limit___p_limit_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz";
<<<<<<< HEAD
        sha512 = "//88mFWSJx8lxCzwdAABTJL2MyWB12+eIY7MDL2SqLmAkeKU9qxRvWuSyTjm3FUmpBEMuFfckAIqEaVGUDxb6w==";
=======
        sha1 = "3dd33c647a214fdfffd835933eb086da0dc21db1";
      };
    }
    {
      name = "p_locate___p_locate_2.0.0.tgz";
      path = fetchurl {
        name = "p_locate___p_locate_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz";
        sha1 = "20a0103b222a70c8fd39cc2e580680f3dde5ec43";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "p_locate___p_locate_4.1.0.tgz";
      path = fetchurl {
        name = "p_locate___p_locate_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz";
<<<<<<< HEAD
        sha512 = "R79ZZ/0wAxKGu3oYMlz8jy/kbhsNrS7SKZ7PxEHBgJ5+F2mtFW2fK2cOtBh1cHYkQsbzFV7I+EoRKe6Yt0oK7A==";
=======
        sha1 = "a3428bb7088b3a60292f66919278b7c297ad4f07";
      };
    }
    {
      name = "p_try___p_try_1.0.0.tgz";
      path = fetchurl {
        name = "p_try___p_try_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-try/-/p-try-1.0.0.tgz";
        sha1 = "cbc79cdbaf8fd4228e13f621f2b1a237c1b207b3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "p_try___p_try_2.2.0.tgz";
      path = fetchurl {
        name = "p_try___p_try_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz";
<<<<<<< HEAD
        sha512 = "R4nPAVTAU0B9D35/Gk3uJf/7XYbQcyohSKdvAxIRSNghFl4e71hVoGnBNQz9cWaXxO2I10KTC+3jMdvvoKw6dQ==";
=======
        sha1 = "cb2868540e313d61de58fafbe35ce9004d5540e6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "parent_module___parent_module_1.0.1.tgz";
      path = fetchurl {
        name = "parent_module___parent_module_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz";
<<<<<<< HEAD
        sha512 = "GQ2EWRpQV8/o+Aw8YqtfZZPfNRWZYkbidE9k5rpl/hC3vtHHBfGm2Ifi6qWV+coDGkrUKZAxE3Lot5kcsRlh+g==";
=======
        sha1 = "691d2709e78c79fae3a156622452d00762caaaa2";
      };
    }
    {
      name = "parse_entities___parse_entities_2.0.0.tgz";
      path = fetchurl {
        name = "parse_entities___parse_entities_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/parse-entities/-/parse-entities-2.0.0.tgz";
        sha1 = "53c6eb5b9314a1f4ec99fa0fdf7ce01ecda0cbe8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "parse_json___parse_json_5.2.0.tgz";
      path = fetchurl {
        name = "parse_json___parse_json_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/parse-json/-/parse-json-5.2.0.tgz";
<<<<<<< HEAD
        sha512 = "ayCKvm/phCGxOkYRSCM82iDwct8/EonSEgCSxWxD7ve6jHggsFl4fZVQBPRNgQoKiuV/odhFrGzQXZwbifC8Rg==";
=======
        sha1 = "c76fc66dee54231c962b22bcc8a72cf2f99753cd";
      };
    }
    {
      name = "path_exists___path_exists_3.0.0.tgz";
      path = fetchurl {
        name = "path_exists___path_exists_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz";
        sha1 = "ce0ebeaa5f78cb18925ea7d810d7b59b010fd515";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "path_exists___path_exists_4.0.0.tgz";
      path = fetchurl {
        name = "path_exists___path_exists_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "ak9Qy5Q7jYb2Wwcey5Fpvg2KoAc/ZIhLSLOSBmRmygPsGwkVVt0fZa0qrtMz+m6tJTAHfZQ8FnmB4MG4LWy7/w==";
=======
        sha1 = "513bdbe2d3b95d7762e8c1137efa195c6c61b5b3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
      path = fetchurl {
        name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
<<<<<<< HEAD
        sha512 = "AVbw3UJ2e9bq64vSaS9Am0fje1Pa8pbGqTTsmXfaIiMpnr5DlDhfJOuLj9Sf95ZPVDAUerDfEk88MPmPe7UCQg==";
=======
        sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "path_key___path_key_3.1.1.tgz";
      path = fetchurl {
        name = "path_key___path_key_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz";
<<<<<<< HEAD
        sha512 = "ojmeN0qd+y0jszEtoY48r0Peq5dwMEkIlCOu6Q5f41lfkswXuKtYrhgoTpLnyIcHm24Uhqx+5Tqm2InSwLhE6Q==";
=======
        sha1 = "581f6ade658cbba65a0d3380de7753295054f375";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "path_parse___path_parse_1.0.7.tgz";
      path = fetchurl {
        name = "path_parse___path_parse_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz";
<<<<<<< HEAD
        sha512 = "LDJzPVEEEPR+y48z93A0Ed0yXb8pAByGWo/k5YYdYgpY2/2EsOsksJrq7lOHxryrVOn1ejG6oAp8ahvOIQD8sw==";
=======
        sha1 = "fbc114b60ca42b30d9daf5858e4bd68bbedb6735";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "path_to_regexp___path_to_regexp_1.8.0.tgz";
      path = fetchurl {
        name = "path_to_regexp___path_to_regexp_1.8.0.tgz";
        url  = "https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-1.8.0.tgz";
<<<<<<< HEAD
        sha512 = "n43JRhlUKUAlibEJhPeir1ncUID16QnEjNpwzNdO3Lm4ywrBpBZ5oLD0I6br9evr1Y9JTqwRtAh7JLoOzAQdVA==";
=======
        sha1 = "887b3ba9d84393e87a0a0b9f4cb756198b53548a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "path_type___path_type_4.0.0.tgz";
      path = fetchurl {
        name = "path_type___path_type_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "gDKb8aZMDeD/tZWs9P6+q0J9Mwkdl6xMV8TjnGP3qJVJ06bdMgkbBlLU8IdfOsIsFz2BW1rNVT3XuNEl8zPAvw==";
      };
    }
    {
      name = "phoenix___phoenix_1.5.0.tgz";
      path = fetchurl {
        name = "phoenix___phoenix_1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/phoenix/-/phoenix-1.5.0.tgz";
        sha512 = "Vzz6eb64BEufIXTVkTcT5HiNdRyLY2DF/l2eN1LaeedRbBhGCsdRWdDISFjBSjxODjqY+w2NmSzBeHM8MieLRw==";
      };
    }
    {
      name = "phoenix_html___phoenix_html_2.12.0.tgz";
      path = fetchurl {
        name = "phoenix_html___phoenix_html_2.12.0.tgz";
        url  = "https://registry.yarnpkg.com/phoenix_html/-/phoenix_html-2.12.0.tgz";
        sha512 = "UulYUsew5h2qeCSIMs1VWINkkpCauEn8uEq0zt2Ky9FpfEW6LsasMJ+Vgi01tUBbBFEy73E+sUvucQ+okL69Aw==";
=======
        sha1 = "84ed01c0a7ba380afe09d90a8c180dcd9d03043b";
      };
    }

    {
      name = "picocolors___picocolors_0.2.1.tgz";
      path = fetchurl {
        name = "picocolors___picocolors_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/picocolors/-/picocolors-0.2.1.tgz";
        sha1 = "570670f793646851d1ba135996962abad587859f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "picocolors___picocolors_1.0.0.tgz";
      path = fetchurl {
        name = "picocolors___picocolors_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/picocolors/-/picocolors-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "1fygroTLlHu66zi26VoTDv8yRgm0Fccecssto+MhsZ0D/DGW2sm8E8AjW7NU5VVTRt5GxbeZ5qBuJr+HyLYkjQ==";
=======
        sha1 = "cb5bdc74ff3f51892236eaf79d68bc44564ab81c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "picomatch___picomatch_2.3.1.tgz";
      path = fetchurl {
        name = "picomatch___picomatch_2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz";
<<<<<<< HEAD
        sha512 = "JU3teHTNjmE2VCGFzuY8EXzCDVwEqB2a8fsIvwaStHhAWJEeVd1o1QD80CU6+ZdEXXSLbSsuLwJjkCBWqRQUVA==";
=======
        sha1 = "3ba3833733646d9d3e4995946c1365a67fb07a42";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "pkg_dir___pkg_dir_4.2.0.tgz";
      path = fetchurl {
        name = "pkg_dir___pkg_dir_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-4.2.0.tgz";
<<<<<<< HEAD
        sha512 = "HRDzbaKjC+AOWVXxAU/x54COGeIv9eb+6CkDSQoNTt4XyWoIJvuPsXizxu/Fr23EiekbtZwmh1IcIG/l/a10GQ==";
      };
    }
    {
      name = "postcss_calc___postcss_calc_8.2.4.tgz";
      path = fetchurl {
        name = "postcss_calc___postcss_calc_8.2.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-calc/-/postcss-calc-8.2.4.tgz";
        sha512 = "SmWMSJmB8MRnnULldx0lQIyhSNvuDl9HfrZkaqqE/WHAhToYsAvDq+yAsA/kIyINDszOp3Rh0GFoNuH5Ypsm3Q==";
      };
    }
    {
      name = "postcss_colormin___postcss_colormin_5.3.1.tgz";
      path = fetchurl {
        name = "postcss_colormin___postcss_colormin_5.3.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-colormin/-/postcss-colormin-5.3.1.tgz";
        sha512 = "UsWQG0AqTFQmpBegeLLc1+c3jIqBNB0zlDGRWR+dQ3pRKJL1oeMzyqmH3o2PIfn9MBdNrVPWhDbT769LxCTLJQ==";
      };
    }
    {
      name = "postcss_convert_values___postcss_convert_values_5.1.3.tgz";
      path = fetchurl {
        name = "postcss_convert_values___postcss_convert_values_5.1.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-convert-values/-/postcss-convert-values-5.1.3.tgz";
        sha512 = "82pC1xkJZtcJEfiLw6UXnXVXScgtBrjlO5CBmuDQc+dlb88ZYheFsjTn40+zBVi3DkfF7iezO0nJUPLcJK3pvA==";
      };
    }
    {
      name = "postcss_discard_comments___postcss_discard_comments_5.1.2.tgz";
      path = fetchurl {
        name = "postcss_discard_comments___postcss_discard_comments_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-comments/-/postcss-discard-comments-5.1.2.tgz";
        sha512 = "+L8208OVbHVF2UQf1iDmRcbdjJkuBF6IS29yBDSiWUIzpYaAhtNl6JYnYm12FnkeCwQqF5LeklOu6rAqgfBZqQ==";
      };
    }
    {
      name = "postcss_discard_duplicates___postcss_discard_duplicates_5.1.0.tgz";
      path = fetchurl {
        name = "postcss_discard_duplicates___postcss_discard_duplicates_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-duplicates/-/postcss-discard-duplicates-5.1.0.tgz";
        sha512 = "zmX3IoSI2aoenxHV6C7plngHWWhUOV3sP1T8y2ifzxzbtnuhk1EdPwm0S1bIUNaJ2eNbWeGLEwzw8huPD67aQw==";
      };
    }
    {
      name = "postcss_discard_empty___postcss_discard_empty_5.1.1.tgz";
      path = fetchurl {
        name = "postcss_discard_empty___postcss_discard_empty_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-empty/-/postcss-discard-empty-5.1.1.tgz";
        sha512 = "zPz4WljiSuLWsI0ir4Mcnr4qQQ5e1Ukc3i7UfE2XcrwKK2LIPIqE5jxMRxO6GbI3cv//ztXDsXwEWT3BHOGh3A==";
      };
    }
    {
      name = "postcss_discard_overridden___postcss_discard_overridden_5.1.0.tgz";
      path = fetchurl {
        name = "postcss_discard_overridden___postcss_discard_overridden_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-overridden/-/postcss-discard-overridden-5.1.0.tgz";
        sha512 = "21nOL7RqWR1kasIVdKs8HNqQJhFxLsyRfAnUDm4Fe4t4mCWL9OJiHvlHPjcd8zc5Myu89b/7wZDnOSjFgeWRtw==";
=======
        sha1 = "f099133df7ede422e81d1d8448270eeb3e4261f3";
      };
    }
    {
      name = "postcss_calc___postcss_calc_8.2.3.tgz";
      path = fetchurl {
        name = "postcss_calc___postcss_calc_8.2.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-calc/-/postcss-calc-8.2.3.tgz";
        sha1 = "53b95ce93de19213c2a5fdd71277a81690ef41d0";
      };
    }
    {
      name = "postcss_colormin___postcss_colormin_5.2.4.tgz";
      path = fetchurl {
        name = "postcss_colormin___postcss_colormin_5.2.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-colormin/-/postcss-colormin-5.2.4.tgz";
        sha1 = "7726d3f3d24f111d39faff50a6500688225d5324";
      };
    }
    {
      name = "postcss_convert_values___postcss_convert_values_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_convert_values___postcss_convert_values_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-convert-values/-/postcss-convert-values-5.0.3.tgz";
        sha1 = "492db08a28af84d57651f10edc8f6c8fb2f6df40";
      };
    }
    {
      name = "postcss_discard_comments___postcss_discard_comments_5.0.2.tgz";
      path = fetchurl {
        name = "postcss_discard_comments___postcss_discard_comments_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-comments/-/postcss-discard-comments-5.0.2.tgz";
        sha1 = "811ed34e2b6c40713daab0beb4d7a04125927dcd";
      };
    }
    {
      name = "postcss_discard_duplicates___postcss_discard_duplicates_5.0.2.tgz";
      path = fetchurl {
        name = "postcss_discard_duplicates___postcss_discard_duplicates_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-duplicates/-/postcss-discard-duplicates-5.0.2.tgz";
        sha1 = "61076f3d256351bdaac8e20aade730fef0609f44";
      };
    }
    {
      name = "postcss_discard_empty___postcss_discard_empty_5.0.2.tgz";
      path = fetchurl {
        name = "postcss_discard_empty___postcss_discard_empty_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-empty/-/postcss-discard-empty-5.0.2.tgz";
        sha1 = "0676a9bcfc44bb00d338352a45ab80845a31d8f0";
      };
    }
    {
      name = "postcss_discard_overridden___postcss_discard_overridden_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_discard_overridden___postcss_discard_overridden_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-discard-overridden/-/postcss-discard-overridden-5.0.3.tgz";
        sha1 = "004b9818cabb407e60616509267567150b327a3f";
      };
    }
    {
      name = "postcss_html___postcss_html_0.36.0.tgz";
      path = fetchurl {
        name = "postcss_html___postcss_html_0.36.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-html/-/postcss-html-0.36.0.tgz";
        sha1 = "b40913f94eaacc2453fd30a1327ad6ee1f88b204";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_js___postcss_js_3.0.3.tgz";
      path = fetchurl {
        name = "postcss_js___postcss_js_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-js/-/postcss-js-3.0.3.tgz";
<<<<<<< HEAD
        sha512 = "gWnoWQXKFw65Hk/mi2+WTQTHdPD5UJdDXZmX073EY/B3BWnYjO4F4t0VneTCnCGQ5E5GsCdMkzPaTXwl3r5dJw==";
      };
    }
    {
      name = "postcss_load_config___postcss_load_config_3.1.4.tgz";
      path = fetchurl {
        name = "postcss_load_config___postcss_load_config_3.1.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-load-config/-/postcss-load-config-3.1.4.tgz";
        sha512 = "6DiM4E7v4coTE4uzA8U//WhtPwyhiim3eyjEMFCnUpzbrkK9wJHgKDT2mR+HbtSrd/NubVaYTOpSpjUl8NQeRg==";
=======
        sha1 = "2f0bd370a2e8599d45439f6970403b5873abda33";
      };
    }
    {
      name = "postcss_less___postcss_less_3.1.4.tgz";
      path = fetchurl {
        name = "postcss_less___postcss_less_3.1.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-less/-/postcss-less-3.1.4.tgz";
        sha1 = "369f58642b5928ef898ffbc1a6e93c958304c5ad";
      };
    }
    {
      name = "postcss_load_config___postcss_load_config_3.1.1.tgz";
      path = fetchurl {
        name = "postcss_load_config___postcss_load_config_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-load-config/-/postcss-load-config-3.1.1.tgz";
        sha1 = "2f53a17f2f543d9e63864460af42efdac0d41f87";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_loader___postcss_loader_6.2.1.tgz";
      path = fetchurl {
        name = "postcss_loader___postcss_loader_6.2.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-loader/-/postcss-loader-6.2.1.tgz";
<<<<<<< HEAD
        sha512 = "WbbYpmAaKcux/P66bZ40bpWsBucjx/TTgVVzRZ9yUO8yQfVBlameJ0ZGVaPfH64hNSBh63a+ICP5nqOpBA0w+Q==";
=======
        sha1 = "0895f7346b1702103d30fdc66e4d494a93c008ef";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_media_query_parser___postcss_media_query_parser_0.2.3.tgz";
      path = fetchurl {
        name = "postcss_media_query_parser___postcss_media_query_parser_0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-media-query-parser/-/postcss-media-query-parser-0.2.3.tgz";
<<<<<<< HEAD
        sha512 = "3sOlxmbKcSHMjlUXQZKQ06jOswE7oVkXPxmZdoB1r5l0q6gTFTQSHxNxOrCccElbW7dxNytifNEo8qidX2Vsig==";
      };
    }
    {
      name = "postcss_merge_longhand___postcss_merge_longhand_5.1.7.tgz";
      path = fetchurl {
        name = "postcss_merge_longhand___postcss_merge_longhand_5.1.7.tgz";
        url  = "https://registry.yarnpkg.com/postcss-merge-longhand/-/postcss-merge-longhand-5.1.7.tgz";
        sha512 = "YCI9gZB+PLNskrK0BB3/2OzPnGhPkBEwmwhfYk1ilBHYVAZB7/tkTHFBAnCrvBBOmeYyMYw3DMjT55SyxMBzjQ==";
      };
    }
    {
      name = "postcss_merge_rules___postcss_merge_rules_5.1.4.tgz";
      path = fetchurl {
        name = "postcss_merge_rules___postcss_merge_rules_5.1.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-merge-rules/-/postcss-merge-rules-5.1.4.tgz";
        sha512 = "0R2IuYpgU93y9lhVbO/OylTtKMVcHb67zjWIfCiKR9rWL3GUk1677LAqD/BcHizukdZEjT8Ru3oHRoAYoJy44g==";
      };
    }
    {
      name = "postcss_minify_font_values___postcss_minify_font_values_5.1.0.tgz";
      path = fetchurl {
        name = "postcss_minify_font_values___postcss_minify_font_values_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-font-values/-/postcss-minify-font-values-5.1.0.tgz";
        sha512 = "el3mYTgx13ZAPPirSVsHqFzl+BBBDrXvbySvPGFnQcTI4iNslrPaFq4muTkLZmKlGk4gyFAYUBMH30+HurREyA==";
      };
    }
    {
      name = "postcss_minify_gradients___postcss_minify_gradients_5.1.1.tgz";
      path = fetchurl {
        name = "postcss_minify_gradients___postcss_minify_gradients_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-gradients/-/postcss-minify-gradients-5.1.1.tgz";
        sha512 = "VGvXMTpCEo4qHTNSa9A0a3D+dxGFZCYwR6Jokk+/3oB6flu2/PnPXAh2x7x52EkY5xlIHLm+Le8tJxe/7TNhzw==";
      };
    }
    {
      name = "postcss_minify_params___postcss_minify_params_5.1.4.tgz";
      path = fetchurl {
        name = "postcss_minify_params___postcss_minify_params_5.1.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-params/-/postcss-minify-params-5.1.4.tgz";
        sha512 = "+mePA3MgdmVmv6g+30rn57USjOGSAyuxUmkfiWpzalZ8aiBkdPYjXWtHuwJGm1v5Ojy0Z0LaSYhHaLJQB0P8Jw==";
      };
    }
    {
      name = "postcss_minify_selectors___postcss_minify_selectors_5.2.1.tgz";
      path = fetchurl {
        name = "postcss_minify_selectors___postcss_minify_selectors_5.2.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-selectors/-/postcss-minify-selectors-5.2.1.tgz";
        sha512 = "nPJu7OjZJTsVUmPdm2TcaiohIwxP+v8ha9NehQ2ye9szv4orirRU3SDdtUmKH+10nzn0bAyOXZ0UEr7OpvLehg==";
=======
        sha1 = "27b39c6f4d94f81b1a73b8f76351c609e5cef244";
      };
    }
    {
      name = "postcss_merge_longhand___postcss_merge_longhand_5.0.5.tgz";
      path = fetchurl {
        name = "postcss_merge_longhand___postcss_merge_longhand_5.0.5.tgz";
        url  = "https://registry.yarnpkg.com/postcss-merge-longhand/-/postcss-merge-longhand-5.0.5.tgz";
        sha1 = "cbc217ca22fb5a3e6ee22a6a1aa6920ec1f3c628";
      };
    }
    {
      name = "postcss_merge_rules___postcss_merge_rules_5.0.5.tgz";
      path = fetchurl {
        name = "postcss_merge_rules___postcss_merge_rules_5.0.5.tgz";
        url  = "https://registry.yarnpkg.com/postcss-merge-rules/-/postcss-merge-rules-5.0.5.tgz";
        sha1 = "2a18669ec214019884a60f0a0d356803a8138366";
      };
    }
    {
      name = "postcss_minify_font_values___postcss_minify_font_values_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_minify_font_values___postcss_minify_font_values_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-font-values/-/postcss-minify-font-values-5.0.3.tgz";
        sha1 = "48c455c4cd980ecd07ac9bf3fc58e9d8a2ae4168";
      };
    }
    {
      name = "postcss_minify_gradients___postcss_minify_gradients_5.0.5.tgz";
      path = fetchurl {
        name = "postcss_minify_gradients___postcss_minify_gradients_5.0.5.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-gradients/-/postcss-minify-gradients-5.0.5.tgz";
        sha1 = "a5572b9c98ed52cbd7414db24b873f8b9e418290";
      };
    }
    {
      name = "postcss_minify_params___postcss_minify_params_5.0.4.tgz";
      path = fetchurl {
        name = "postcss_minify_params___postcss_minify_params_5.0.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-params/-/postcss-minify-params-5.0.4.tgz";
        sha1 = "230a4d04456609e614db1d48c2eebc21f6490a45";
      };
    }
    {
      name = "postcss_minify_selectors___postcss_minify_selectors_5.1.2.tgz";
      path = fetchurl {
        name = "postcss_minify_selectors___postcss_minify_selectors_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-minify-selectors/-/postcss-minify-selectors-5.1.2.tgz";
        sha1 = "bc9698f713b9dab7f44f1ec30643fcbad9a043c0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_modules_extract_imports___postcss_modules_extract_imports_3.0.0.tgz";
      path = fetchurl {
        name = "postcss_modules_extract_imports___postcss_modules_extract_imports_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-modules-extract-imports/-/postcss-modules-extract-imports-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "bdHleFnP3kZ4NYDhuGlVK+CMrQ/pqUm8bx/oGL93K6gVwiclvX5x0n76fYMKuIGKzlABOy13zsvqjb0f92TEXw==";
=======
        sha1 = "cda1f047c0ae80c97dbe28c3e76a43b88025741d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_modules_local_by_default___postcss_modules_local_by_default_4.0.0.tgz";
      path = fetchurl {
        name = "postcss_modules_local_by_default___postcss_modules_local_by_default_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-modules-local-by-default/-/postcss-modules-local-by-default-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "sT7ihtmGSF9yhm6ggikHdV0hlziDTX7oFoXtuVWeDd3hHObNkcHRo9V3yg7vCAY7cONyxJC/XXCmmiHHcvX7bQ==";
=======
        sha1 = "ebbb54fae1598eecfdf691a02b3ff3b390a5a51c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_modules_scope___postcss_modules_scope_3.0.0.tgz";
      path = fetchurl {
        name = "postcss_modules_scope___postcss_modules_scope_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-modules-scope/-/postcss-modules-scope-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "hncihwFA2yPath8oZ15PZqvWGkWf+XUfQgUGamS4LqoP1anQLOsOJw0vr7J7IwLpoY9fatA2qiGUGmuZL0Iqlg==";
=======
        sha1 = "9ef3151456d3bbfa120ca44898dfca6f2fa01f06";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_modules_values___postcss_modules_values_4.0.0.tgz";
      path = fetchurl {
        name = "postcss_modules_values___postcss_modules_values_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-modules-values/-/postcss-modules-values-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "RDxHkAiEGI78gS2ofyvCsu7iycRv7oqw5xMWn9iMoR0N/7mf9D50ecQqUo5BZ9Zh2vH4bCUR/ktCqbB9m8vJjQ==";
=======
        sha1 = "d7c5e7e68c3bb3c9b27cbf48ca0bb3ffb4602c9c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_nested___postcss_nested_5.0.6.tgz";
      path = fetchurl {
        name = "postcss_nested___postcss_nested_5.0.6.tgz";
        url  = "https://registry.yarnpkg.com/postcss-nested/-/postcss-nested-5.0.6.tgz";
<<<<<<< HEAD
        sha512 = "rKqm2Fk0KbA8Vt3AdGN0FB9OBOMDVajMG6ZCf/GoHgdxUJ4sBFp0A/uMIRm+MJUdo33YXEtjqIz8u7DAp8B7DA==";
      };
    }
    {
      name = "postcss_normalize_charset___postcss_normalize_charset_5.1.0.tgz";
      path = fetchurl {
        name = "postcss_normalize_charset___postcss_normalize_charset_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-charset/-/postcss-normalize-charset-5.1.0.tgz";
        sha512 = "mSgUJ+pd/ldRGVx26p2wz9dNZ7ji6Pn8VWBajMXFf8jk7vUoSrZ2lt/wZR7DtlZYKesmZI680qjr2CeFF2fbUg==";
      };
    }
    {
      name = "postcss_normalize_display_values___postcss_normalize_display_values_5.1.0.tgz";
      path = fetchurl {
        name = "postcss_normalize_display_values___postcss_normalize_display_values_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-display-values/-/postcss-normalize-display-values-5.1.0.tgz";
        sha512 = "WP4KIM4o2dazQXWmFaqMmcvsKmhdINFblgSeRgn8BJ6vxaMyaJkwAzpPpuvSIoG/rmX3M+IrRZEz2H0glrQNEA==";
      };
    }
    {
      name = "postcss_normalize_positions___postcss_normalize_positions_5.1.1.tgz";
      path = fetchurl {
        name = "postcss_normalize_positions___postcss_normalize_positions_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-positions/-/postcss-normalize-positions-5.1.1.tgz";
        sha512 = "6UpCb0G4eofTCQLFVuI3EVNZzBNPiIKcA1AKVka+31fTVySphr3VUgAIULBhxZkKgwLImhzMR2Bw1ORK+37INg==";
      };
    }
    {
      name = "postcss_normalize_repeat_style___postcss_normalize_repeat_style_5.1.1.tgz";
      path = fetchurl {
        name = "postcss_normalize_repeat_style___postcss_normalize_repeat_style_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-repeat-style/-/postcss-normalize-repeat-style-5.1.1.tgz";
        sha512 = "mFpLspGWkQtBcWIRFLmewo8aC3ImN2i/J3v8YCFUwDnPu3Xz4rLohDO26lGjwNsQxB3YF0KKRwspGzE2JEuS0g==";
      };
    }
    {
      name = "postcss_normalize_string___postcss_normalize_string_5.1.0.tgz";
      path = fetchurl {
        name = "postcss_normalize_string___postcss_normalize_string_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-string/-/postcss-normalize-string-5.1.0.tgz";
        sha512 = "oYiIJOf4T9T1N4i+abeIc7Vgm/xPCGih4bZz5Nm0/ARVJ7K6xrDlLwvwqOydvyL3RHNf8qZk6vo3aatiw/go3w==";
      };
    }
    {
      name = "postcss_normalize_timing_functions___postcss_normalize_timing_functions_5.1.0.tgz";
      path = fetchurl {
        name = "postcss_normalize_timing_functions___postcss_normalize_timing_functions_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-timing-functions/-/postcss-normalize-timing-functions-5.1.0.tgz";
        sha512 = "DOEkzJ4SAXv5xkHl0Wa9cZLF3WCBhF3o1SKVxKQAa+0pYKlueTpCgvkFAHfk+Y64ezX9+nITGrDZeVGgITJXjg==";
      };
    }
    {
      name = "postcss_normalize_unicode___postcss_normalize_unicode_5.1.1.tgz";
      path = fetchurl {
        name = "postcss_normalize_unicode___postcss_normalize_unicode_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-unicode/-/postcss-normalize-unicode-5.1.1.tgz";
        sha512 = "qnCL5jzkNUmKVhZoENp1mJiGNPcsJCs1aaRmURmeJGES23Z/ajaln+EPTD+rBeNkSryI+2WTdW+lwcVdOikrpA==";
      };
    }
    {
      name = "postcss_normalize_url___postcss_normalize_url_5.1.0.tgz";
      path = fetchurl {
        name = "postcss_normalize_url___postcss_normalize_url_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-url/-/postcss-normalize-url-5.1.0.tgz";
        sha512 = "5upGeDO+PVthOxSmds43ZeMeZfKH+/DKgGRD7TElkkyS46JXAUhMzIKiCa7BabPeIy3AQcTkXwVVN7DbqsiCew==";
      };
    }
    {
      name = "postcss_normalize_whitespace___postcss_normalize_whitespace_5.1.1.tgz";
      path = fetchurl {
        name = "postcss_normalize_whitespace___postcss_normalize_whitespace_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-whitespace/-/postcss-normalize-whitespace-5.1.1.tgz";
        sha512 = "83ZJ4t3NUDETIHTa3uEg6asWjSBYL5EdkVB0sDncx9ERzOKBVJIUeDO9RyA9Zwtig8El1d79HBp0JEi8wvGQnA==";
      };
    }
    {
      name = "postcss_ordered_values___postcss_ordered_values_5.1.3.tgz";
      path = fetchurl {
        name = "postcss_ordered_values___postcss_ordered_values_5.1.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-ordered-values/-/postcss-ordered-values-5.1.3.tgz";
        sha512 = "9UO79VUhPwEkzbb3RNpqqghc6lcYej1aveQteWY+4POIwlqkYE21HKWaLDF6lWNuqCobEAyTovVhtI32Rbv2RQ==";
      };
    }
    {
      name = "postcss_reduce_initial___postcss_reduce_initial_5.1.2.tgz";
      path = fetchurl {
        name = "postcss_reduce_initial___postcss_reduce_initial_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-reduce-initial/-/postcss-reduce-initial-5.1.2.tgz";
        sha512 = "dE/y2XRaqAi6OvjzD22pjTUQ8eOfc6m/natGHgKFBK9DxFmIm69YmaRVQrGgFlEfc1HePIurY0TmDeROK05rIg==";
      };
    }
    {
      name = "postcss_reduce_transforms___postcss_reduce_transforms_5.1.0.tgz";
      path = fetchurl {
        name = "postcss_reduce_transforms___postcss_reduce_transforms_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-reduce-transforms/-/postcss-reduce-transforms-5.1.0.tgz";
        sha512 = "2fbdbmgir5AvpW9RLtdONx1QoYG2/EtqpNQbFASDlixBbAYuTcJ0dECwlqNqH7VbaUnEnh8SrxOe2sRIn24XyQ==";
=======
        sha1 = "466343f7fc8d3d46af3e7dba3fcd47d052a945bc";
      };
    }
    {
      name = "postcss_normalize_charset___postcss_normalize_charset_5.0.2.tgz";
      path = fetchurl {
        name = "postcss_normalize_charset___postcss_normalize_charset_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-charset/-/postcss-normalize-charset-5.0.2.tgz";
        sha1 = "eb6130c8a8e950ce25f9ea512de1d9d6a6f81439";
      };
    }
    {
      name = "postcss_normalize_display_values___postcss_normalize_display_values_5.0.2.tgz";
      path = fetchurl {
        name = "postcss_normalize_display_values___postcss_normalize_display_values_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-display-values/-/postcss-normalize-display-values-5.0.2.tgz";
        sha1 = "8b5273c6c7d0a445e6ef226b8a5bb3204a55fb99";
      };
    }
    {
      name = "postcss_normalize_positions___postcss_normalize_positions_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_normalize_positions___postcss_normalize_positions_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-positions/-/postcss-normalize-positions-5.0.3.tgz";
        sha1 = "b63fcc4ff5fbf65934fafaf83270b2da214711d1";
      };
    }
    {
      name = "postcss_normalize_repeat_style___postcss_normalize_repeat_style_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_normalize_repeat_style___postcss_normalize_repeat_style_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-repeat-style/-/postcss-normalize-repeat-style-5.0.3.tgz";
        sha1 = "488c0ad8aac0fa4f66ef56cc8d604b3fd9bf705f";
      };
    }
    {
      name = "postcss_normalize_string___postcss_normalize_string_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_normalize_string___postcss_normalize_string_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-string/-/postcss-normalize-string-5.0.3.tgz";
        sha1 = "49e0a1d58a119d5435ef21893ad03136a6e8f0e6";
      };
    }
    {
      name = "postcss_normalize_timing_functions___postcss_normalize_timing_functions_5.0.2.tgz";
      path = fetchurl {
        name = "postcss_normalize_timing_functions___postcss_normalize_timing_functions_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-timing-functions/-/postcss-normalize-timing-functions-5.0.2.tgz";
        sha1 = "db4f4f49721f47667afd1fdc5edb032f8d9cdb2e";
      };
    }
    {
      name = "postcss_normalize_unicode___postcss_normalize_unicode_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_normalize_unicode___postcss_normalize_unicode_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-unicode/-/postcss-normalize-unicode-5.0.3.tgz";
        sha1 = "10f0d30093598a58c48a616491cc7fa53256dd43";
      };
    }
    {
      name = "postcss_normalize_url___postcss_normalize_url_5.0.4.tgz";
      path = fetchurl {
        name = "postcss_normalize_url___postcss_normalize_url_5.0.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-url/-/postcss-normalize-url-5.0.4.tgz";
        sha1 = "3b0322c425e31dd275174d0d5db0e466f50810fb";
      };
    }
    {
      name = "postcss_normalize_whitespace___postcss_normalize_whitespace_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_normalize_whitespace___postcss_normalize_whitespace_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-normalize-whitespace/-/postcss-normalize-whitespace-5.0.3.tgz";
        sha1 = "fb6bcc9ff2f834448b802657c7acd0956f4591d1";
      };
    }
    {
      name = "postcss_ordered_values___postcss_ordered_values_5.0.4.tgz";
      path = fetchurl {
        name = "postcss_ordered_values___postcss_ordered_values_5.0.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-ordered-values/-/postcss-ordered-values-5.0.4.tgz";
        sha1 = "f799dca87a7f17526d31a20085e61768d0b00534";
      };
    }
    {
      name = "postcss_reduce_initial___postcss_reduce_initial_5.0.2.tgz";
      path = fetchurl {
        name = "postcss_reduce_initial___postcss_reduce_initial_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-reduce-initial/-/postcss-reduce-initial-5.0.2.tgz";
        sha1 = "fa424ce8aa88a89bc0b6d0f94871b24abe94c048";
      };
    }
    {
      name = "postcss_reduce_transforms___postcss_reduce_transforms_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_reduce_transforms___postcss_reduce_transforms_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-reduce-transforms/-/postcss-reduce-transforms-5.0.3.tgz";
        sha1 = "df60fab34698a43073e8b87938c71df7a3b040ac";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_resolve_nested_selector___postcss_resolve_nested_selector_0.1.1.tgz";
      path = fetchurl {
        name = "postcss_resolve_nested_selector___postcss_resolve_nested_selector_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-resolve-nested-selector/-/postcss-resolve-nested-selector-0.1.1.tgz";
<<<<<<< HEAD
        sha512 = "HvExULSwLqHLgUy1rl3ANIqCsvMS0WHss2UOsXhXnQaZ9VCc2oBvIpXrl00IUFT5ZDITME0o6oiXeiHr2SAIfw==";
      };
    }
    {
      name = "postcss_safe_parser___postcss_safe_parser_6.0.0.tgz";
      path = fetchurl {
        name = "postcss_safe_parser___postcss_safe_parser_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-safe-parser/-/postcss-safe-parser-6.0.0.tgz";
        sha512 = "FARHN8pwH+WiS2OPCxJI8FuRJpTVnn6ZNFiqAM2aeW2LwTHWWmWgIyKC6cUo0L8aeKiF/14MNvnpls6R2PBeMQ==";
      };
    }
    {
      name = "postcss_selector_parser___postcss_selector_parser_6.0.12.tgz";
      path = fetchurl {
        name = "postcss_selector_parser___postcss_selector_parser_6.0.12.tgz";
        url  = "https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-6.0.12.tgz";
        sha512 = "NdxGCAZdRrwVI1sy59+Wzrh+pMMHxapGnpfenDVlMEXoOcvt4pGE0JLK9YY2F5dLxcFYA/YbVQKhcGU+FtSYQg==";
      };
    }
    {
      name = "postcss_svgo___postcss_svgo_5.1.0.tgz";
      path = fetchurl {
        name = "postcss_svgo___postcss_svgo_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-svgo/-/postcss-svgo-5.1.0.tgz";
        sha512 = "D75KsH1zm5ZrHyxPakAxJWtkyXew5qwS70v56exwvw542d9CRtTo78K0WeFxZB4G7JXKKMbEZtZayTGdIky/eA==";
      };
    }
    {
      name = "postcss_unique_selectors___postcss_unique_selectors_5.1.1.tgz";
      path = fetchurl {
        name = "postcss_unique_selectors___postcss_unique_selectors_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-unique-selectors/-/postcss-unique-selectors-5.1.1.tgz";
        sha512 = "5JiODlELrz8L2HwxfPnhOWZYWDxVHWL83ufOv84NrcgipI7TaeRsatAhK4Tr2/ZiYldpK/wBvw5BD3qfaK96GA==";
=======
        sha1 = "29ccbc7c37dedfac304e9fff0bf1596b3f6a0e4e";
      };
    }
    {
      name = "postcss_safe_parser___postcss_safe_parser_4.0.2.tgz";
      path = fetchurl {
        name = "postcss_safe_parser___postcss_safe_parser_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-safe-parser/-/postcss-safe-parser-4.0.2.tgz";
        sha1 = "a6d4e48f0f37d9f7c11b2a581bf00f8ba4870b96";
      };
    }
    {
      name = "postcss_sass___postcss_sass_0.4.4.tgz";
      path = fetchurl {
        name = "postcss_sass___postcss_sass_0.4.4.tgz";
        url  = "https://registry.yarnpkg.com/postcss-sass/-/postcss-sass-0.4.4.tgz";
        sha1 = "91f0f3447b45ce373227a98b61f8d8f0785285a3";
      };
    }
    {
      name = "postcss_scss___postcss_scss_2.1.1.tgz";
      path = fetchurl {
        name = "postcss_scss___postcss_scss_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-scss/-/postcss-scss-2.1.1.tgz";
        sha1 = "ec3a75fa29a55e016b90bf3269026c53c1d2b383";
      };
    }
    {
      name = "postcss_selector_parser___postcss_selector_parser_6.0.9.tgz";
      path = fetchurl {
        name = "postcss_selector_parser___postcss_selector_parser_6.0.9.tgz";
        url  = "https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-6.0.9.tgz";
        sha1 = "ee71c3b9ff63d9cd130838876c13a2ec1a992b2f";
      };
    }
    {
      name = "postcss_svgo___postcss_svgo_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_svgo___postcss_svgo_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-svgo/-/postcss-svgo-5.0.3.tgz";
        sha1 = "d945185756e5dfaae07f9edb0d3cae7ff79f9b30";
      };
    }
    {
      name = "postcss_syntax___postcss_syntax_0.36.2.tgz";
      path = fetchurl {
        name = "postcss_syntax___postcss_syntax_0.36.2.tgz";
        url  = "https://registry.yarnpkg.com/postcss-syntax/-/postcss-syntax-0.36.2.tgz";
        sha1 = "f08578c7d95834574e5593a82dfbfa8afae3b51c";
      };
    }
    {
      name = "postcss_unique_selectors___postcss_unique_selectors_5.0.3.tgz";
      path = fetchurl {
        name = "postcss_unique_selectors___postcss_unique_selectors_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/postcss-unique-selectors/-/postcss-unique-selectors-5.0.3.tgz";
        sha1 = "07fd116a8fbd9202e7030f7c4952e7b52c26c63d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_value_parser___postcss_value_parser_3.3.1.tgz";
      path = fetchurl {
        name = "postcss_value_parser___postcss_value_parser_3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz";
<<<<<<< HEAD
        sha512 = "pISE66AbVkp4fDQ7VHBwRNXzAAKJjw4Vw7nWI/+Q3vuly7SNfgYXvm6i5IgFylHGK5sP/xHAbB7N49OS4gWNyQ==";
=======
        sha1 = "9ff822547e2893213cf1c30efa51ac5fd1ba8281";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "postcss_value_parser___postcss_value_parser_4.2.0.tgz";
      path = fetchurl {
        name = "postcss_value_parser___postcss_value_parser_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz";
<<<<<<< HEAD
        sha512 = "1NNCs6uurfkVbeXG4S8JFT9t19m45ICnif8zWLd5oPSZ50QnwMfK+H3jv408d4jw/7Bttv5axS5IiHoLaVNHeQ==";
      };
    }
    {
      name = "postcss___postcss_8.4.23.tgz";
      path = fetchurl {
        name = "postcss___postcss_8.4.23.tgz";
        url  = "https://registry.yarnpkg.com/postcss/-/postcss-8.4.23.tgz";
        sha512 = "bQ3qMcpF6A/YjR55xtoTr0jGOlnPOKAIMdOWiv0EIT6HVPEaJiJB4NLljSbiHoC2RX7DN5Uvjtpbg1NPdwv1oA==";
=======
        sha1 = "723c09920836ba6d3e5af019f92bc0971c02e514";
      };
    }
    {
      name = "postcss___postcss_7.0.39.tgz";
      path = fetchurl {
        name = "postcss___postcss_7.0.39.tgz";
        url  = "https://registry.yarnpkg.com/postcss/-/postcss-7.0.39.tgz";
        sha1 = "9624375d965630e2e1f2c02a935c82a59cb48309";
      };
    }
    {
      name = "postcss___postcss_8.4.5.tgz";
      path = fetchurl {
        name = "postcss___postcss_8.4.5.tgz";
        url  = "https://registry.yarnpkg.com/postcss/-/postcss-8.4.5.tgz";
        sha1 = "bae665764dfd4c6fcc24dc0fdf7e7aa00cc77f95";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "prelude_ls___prelude_ls_1.2.1.tgz";
      path = fetchurl {
        name = "prelude_ls___prelude_ls_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.2.1.tgz";
<<<<<<< HEAD
        sha512 = "vkcDPrRZo1QZLbn5RLGPpg/WmIQ65qoWWhcGKf/b5eplkkarX0m9z8ppCat4mlOqUsWpyNuYgO3VRyrYHSzX5g==";
=======
        sha1 = "debc6489d7a6e6b0e7611888cec880337d316396";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "prelude_ls___prelude_ls_1.1.2.tgz";
      path = fetchurl {
        name = "prelude_ls___prelude_ls_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.1.2.tgz";
<<<<<<< HEAD
        sha512 = "ESF23V4SKG6lVSGZgYNpbsiaAkdab6ZgOxe52p7+Kid3W3u3bxR4Vfd/o21dmN7jSt0IwgZ4v5MUd26FEtXE9w==";
=======
        sha1 = "21932a549f5e52ffd9a827f570e04be62a97da54";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "prettier_linter_helpers___prettier_linter_helpers_1.0.0.tgz";
      path = fetchurl {
        name = "prettier_linter_helpers___prettier_linter_helpers_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/prettier-linter-helpers/-/prettier-linter-helpers-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "GbK2cP9nraSSUF9N2XwUwqfzlAFlMNYYl+ShE/V+H8a9uNl/oUqB1w2EL54Jh0OlyRSd8RfWYJ3coVS4TROP2w==";
=======
        sha1 = "d23d41fe1375646de2d0104d3454a3008802cf7b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "pretty_hrtime___pretty_hrtime_1.0.3.tgz";
      path = fetchurl {
        name = "pretty_hrtime___pretty_hrtime_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/pretty-hrtime/-/pretty-hrtime-1.0.3.tgz";
<<<<<<< HEAD
        sha512 = "66hKPCr+72mlfiSjlEB1+45IjXSqvVAIy6mocupoww4tBFE9R9IhwwUGoI4G++Tc9Aq+2rxOt0RFU6gPcrte0A==";
=======
        sha1 = "b7e3ea42435a4c9b2759d99e0f201eb195802ee1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "process_nextick_args___process_nextick_args_2.0.1.tgz";
      path = fetchurl {
        name = "process_nextick_args___process_nextick_args_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz";
<<<<<<< HEAD
        sha512 = "3ouUOpQhtgrbOa17J7+uxOTpITYWaGP7/AhoR3+A+/1e9skrzelGi/dXzEYyvbxubEF6Wn2ypscTKiKJFFn1ag==";
=======
        sha1 = "7820d9b16120cc55ca9ae7792680ae7dba6d7fe2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "progress___progress_2.0.3.tgz";
      path = fetchurl {
        name = "progress___progress_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz";
<<<<<<< HEAD
        sha512 = "7PiHtLll5LdnKIMw100I+8xJXR5gW2QwWYkT6iJva0bXitZKa/XMrSbdmg3r2Xnaidz9Qumd0VPaMrZlF9V9sA==";
=======
        sha1 = "7e8cf8d8f5b8f239c1bc68beb4eb78567d572ef8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "prop_types___prop_types_15.8.1.tgz";
      path = fetchurl {
        name = "prop_types___prop_types_15.8.1.tgz";
        url  = "https://registry.yarnpkg.com/prop-types/-/prop-types-15.8.1.tgz";
<<<<<<< HEAD
        sha512 = "oj87CgZICdulUohogVAR7AjlC0327U4el4L6eAvOqCeudMDVU0NThNaV+b9Df4dXgSP1gXMTnPdhfe/2qDH5cg==";
      };
    }
    {
      name = "property_expr___property_expr_2.0.5.tgz";
      path = fetchurl {
        name = "property_expr___property_expr_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/property-expr/-/property-expr-2.0.5.tgz";
        sha512 = "IJUkICM5dP5znhCckHSv30Q4b5/JA5enCtkRHYaOVOAocnH/1BQEYTC5NMfT3AVl/iXKdr3aqQbQn9DxyWknwA==";
      };
    }
    {
      name = "punycode___punycode_2.3.0.tgz";
      path = fetchurl {
        name = "punycode___punycode_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-2.3.0.tgz";
        sha512 = "rRV+zQD8tVFys26lAGR9WUuS4iUAngJScM+ZRSKtvl5tKeZ2t5bvdNFdNHBW9FWR4guGHlgmsZ1G7BSm2wTbuA==";
=======
        sha1 = "67d87bf1a694f48435cf332c24af10214a3140b5";
      };
    }
    {
      name = "punycode___punycode_2.1.1.tgz";
      path = fetchurl {
        name = "punycode___punycode_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-2.1.1.tgz";
        sha1 = "b58b010ac40c22c5657616c8d2c2c02c7bf479ec";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "purgecss___purgecss_4.1.3.tgz";
      path = fetchurl {
        name = "purgecss___purgecss_4.1.3.tgz";
        url  = "https://registry.yarnpkg.com/purgecss/-/purgecss-4.1.3.tgz";
<<<<<<< HEAD
        sha512 = "99cKy4s+VZoXnPxaoM23e5ABcP851nC2y2GROkkjS8eJaJtlciGavd7iYAw2V84WeBqggZ12l8ef44G99HmTaw==";
=======
        sha1 = "683f6a133c8c4de7aa82fe2746d1393b214918f7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "queue_microtask___queue_microtask_1.2.3.tgz";
      path = fetchurl {
        name = "queue_microtask___queue_microtask_1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/queue-microtask/-/queue-microtask-1.2.3.tgz";
<<<<<<< HEAD
        sha512 = "NuaNSa6flKT5JaSYQzJok04JzTL1CA6aGhv5rfLW3PgqA+M2ChpZQnAC8h8i4ZFkBS8X5RqkDBHA7r4hej3K9A==";
=======
        sha1 = "4929228bbc724dfac43e0efb058caf7b6cfb6243";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "quick_lru___quick_lru_4.0.1.tgz";
      path = fetchurl {
        name = "quick_lru___quick_lru_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/quick-lru/-/quick-lru-4.0.1.tgz";
<<<<<<< HEAD
        sha512 = "ARhCpm70fzdcvNQfPoy49IaanKkTlRWF2JMzqhcJbhSFRZv7nPTvZJdcY7301IPmvW+/p0RgIWnQDLJxifsQ7g==";
=======
        sha1 = "5b8878f113a58217848c6482026c73e1ba57727f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "quick_lru___quick_lru_5.1.1.tgz";
      path = fetchurl {
        name = "quick_lru___quick_lru_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/quick-lru/-/quick-lru-5.1.1.tgz";
<<<<<<< HEAD
        sha512 = "WuyALRjWPDGtt/wzJiadO5AXY+8hZ80hVpe6MyivgraREW751X3SbhRvG3eLKOYN+8VEvqLcf3wdnt44Z4S4SA==";
=======
        sha1 = "366493e6b3e42a3a6885e2e99d18f80fb7a8c932";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "quote_stream___quote_stream_1.0.2.tgz";
      path = fetchurl {
        name = "quote_stream___quote_stream_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/quote-stream/-/quote-stream-1.0.2.tgz";
<<<<<<< HEAD
        sha512 = "kKr2uQ2AokadPjvTyKJQad9xELbZwYzWlNfI3Uz2j/ib5u6H9lDP7fUUR//rMycd0gv4Z5P1qXMfXR8YpIxrjQ==";
=======
        sha1 = "84963f8c9c26b942e153feeb53aae74652b7e0b2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "randombytes___randombytes_2.1.0.tgz";
      path = fetchurl {
        name = "randombytes___randombytes_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz";
<<<<<<< HEAD
        sha512 = "vYl3iOX+4CKUWuxGi9Ukhie6fsqXqS9FE2Zaic4tNFD2N2QQaXOMFbuKK4QmDHC0JO6B1Zp41J0LpT0oR68amQ==";
=======
        sha1 = "df6f84372f0270dc65cdf6291349ab7a473d4f2a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "react_dom___react_dom_16.14.0.tgz";
      path = fetchurl {
        name = "react_dom___react_dom_16.14.0.tgz";
        url  = "https://registry.yarnpkg.com/react-dom/-/react-dom-16.14.0.tgz";
<<<<<<< HEAD
        sha512 = "1gCeQXDLoIqMgqD3IO2Ah9bnf0w9kzhwN5q4FGnHZ67hBm9yePzB5JJAIQCc8x3pFnNlwFq4RidZggNAAkzWWw==";
      };
    }
    {
      name = "react_fast_compare___react_fast_compare_3.2.1.tgz";
      path = fetchurl {
        name = "react_fast_compare___react_fast_compare_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/react-fast-compare/-/react-fast-compare-3.2.1.tgz";
        sha512 = "xTYf9zFim2pEif/Fw16dBiXpe0hoy5PxcD8+OwBnTtNLfIm3g6WxhKNurY+6OmdH1u6Ta/W/Vl6vjbYP1MFnDg==";
=======
        sha1 = "7ad838ec29a777fb3c75c3a190f661cf92ab8b89";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "react_flatpickr___react_flatpickr_3.10.5.tgz";
      path = fetchurl {
        name = "react_flatpickr___react_flatpickr_3.10.5.tgz";
        url  = "https://registry.yarnpkg.com/react-flatpickr/-/react-flatpickr-3.10.5.tgz";
<<<<<<< HEAD
        sha512 = "MZlBN9Ml4FLFoR5tS61T9BjJRIrwF0mKDqC+ni5ZgdtIbWVebp6emx9jpg8QuXv5hSr1W1by3Tqv3ebZXU7rhg==";
      };
    }
    {
      name = "react_flip_move___react_flip_move_3.0.5.tgz";
      path = fetchurl {
        name = "react_flip_move___react_flip_move_3.0.5.tgz";
        url  = "https://registry.yarnpkg.com/react-flip-move/-/react-flip-move-3.0.5.tgz";
        sha512 = "Mf4XpbkUNZy9eu80iXXFIjToDvw+bnHxmKHVoositbMpV87O/EQswnXUqVovRHoTx/F+4dE+p//PyJnAT7OtPA==";
=======
        sha1 = "a12bd3eea8689064981cb62856d9ea60c353a295";
      };
    }
    {
      name = "react_flip_move___react_flip_move_3.0.4.tgz";
      path = fetchurl {
        name = "react_flip_move___react_flip_move_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/react-flip-move/-/react-flip-move-3.0.4.tgz";
        sha1 = "261f66101fbc305f9b7b28959c5cf8236413ca74";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "react_is___react_is_16.13.1.tgz";
      path = fetchurl {
        name = "react_is___react_is_16.13.1.tgz";
        url  = "https://registry.yarnpkg.com/react-is/-/react-is-16.13.1.tgz";
<<<<<<< HEAD
        sha512 = "24e6ynE2H+OKt4kqsOvNd8kBpV65zoxbA4BVsEOB3ARVWQki/DHzaUoC5KuON/BiccDaCCTZBuOcfZs70kR8bQ==";
=======
        sha1 = "789729a4dc36de2999dc156dd6c1d9c18cea56a4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "react_is___react_is_17.0.2.tgz";
      path = fetchurl {
        name = "react_is___react_is_17.0.2.tgz";
        url  = "https://registry.yarnpkg.com/react-is/-/react-is-17.0.2.tgz";
<<<<<<< HEAD
        sha512 = "w2GsyukL62IJnlaff/nRegPQR94C/XXamvMWmSHRJ4y7Ts/4ocGRmTHvOs8PSE6pB3dWOrD/nueuU5sduBsQ4w==";
      };
    }
    {
      name = "react_popper___react_popper_2.3.0.tgz";
      path = fetchurl {
        name = "react_popper___react_popper_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/react-popper/-/react-popper-2.3.0.tgz";
        sha512 = "e1hj8lL3uM+sgSR4Lxzn5h1GxBlpa4CQz0XLF8kx4MDrDRWY0Ena4c97PUeSX9i5W3UAfDP0z0FXCTQkoXUl3Q==";
      };
    }
    {
      name = "react_router_dom___react_router_dom_5.3.4.tgz";
      path = fetchurl {
        name = "react_router_dom___react_router_dom_5.3.4.tgz";
        url  = "https://registry.yarnpkg.com/react-router-dom/-/react-router-dom-5.3.4.tgz";
        sha512 = "m4EqFMHv/Ih4kpcBCONHbkT68KoAeHN4p3lAGoNryfHi0dMy0kCzEZakiKRsvg5wHZ/JLrLW8o8KomWiz/qbYQ==";
      };
    }
    {
      name = "react_router___react_router_5.3.4.tgz";
      path = fetchurl {
        name = "react_router___react_router_5.3.4.tgz";
        url  = "https://registry.yarnpkg.com/react-router/-/react-router-5.3.4.tgz";
        sha512 = "Ys9K+ppnJah3QuaRiLxk+jDWOR1MekYQrlytiXxC1RyfbdsZkS5pvKAzCCr031xHixZwpnsYNT5xysdFHQaYsA==";
      };
    }
    {
      name = "react_transition_group___react_transition_group_4.4.5.tgz";
      path = fetchurl {
        name = "react_transition_group___react_transition_group_4.4.5.tgz";
        url  = "https://registry.yarnpkg.com/react-transition-group/-/react-transition-group-4.4.5.tgz";
        sha512 = "pZcd1MCJoiKiBR2NRxeCRg13uCXbydPnmB4EOeRrY7480qNWO8IIgQG6zlDkm6uRMsURXPuKq0GWtiM59a5Q6g==";
=======
        sha1 = "e691d4a8e9c789365655539ab372762b0efb54f0";
      };
    }
    {
      name = "react_router_dom___react_router_dom_5.3.0.tgz";
      path = fetchurl {
        name = "react_router_dom___react_router_dom_5.3.0.tgz";
        url  = "https://registry.yarnpkg.com/react-router-dom/-/react-router-dom-5.3.0.tgz";
        sha1 = "da1bfb535a0e89a712a93b97dd76f47ad1f32363";
      };
    }
    {
      name = "react_router___react_router_5.2.1.tgz";
      path = fetchurl {
        name = "react_router___react_router_5.2.1.tgz";
        url  = "https://registry.yarnpkg.com/react-router/-/react-router-5.2.1.tgz";
        sha1 = "4d2e4e9d5ae9425091845b8dbc6d9d276239774d";
      };
    }
    {
      name = "react_transition_group___react_transition_group_4.4.2.tgz";
      path = fetchurl {
        name = "react_transition_group___react_transition_group_4.4.2.tgz";
        url  = "https://registry.yarnpkg.com/react-transition-group/-/react-transition-group-4.4.2.tgz";
        sha1 = "8b59a56f09ced7b55cbd53c36768b922890d5470";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "react___react_16.14.0.tgz";
      path = fetchurl {
        name = "react___react_16.14.0.tgz";
        url  = "https://registry.yarnpkg.com/react/-/react-16.14.0.tgz";
<<<<<<< HEAD
        sha512 = "0X2CImDkJGApiAlcf0ODKIneSwBPhqJawOa5wCtKbu7ZECrmS26NvtSILynQ66cgkT/RJ4LidJOc3bUESwmU8g==";
=======
        sha1 = "94d776ddd0aaa37da3eda8fc5b6b18a4c9a3114d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "read_pkg_up___read_pkg_up_7.0.1.tgz";
      path = fetchurl {
        name = "read_pkg_up___read_pkg_up_7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-7.0.1.tgz";
<<<<<<< HEAD
        sha512 = "zK0TB7Xd6JpCLmlLmufqykGE+/TlOePD6qKClNW7hHDKFh/J7/7gCWGR7joEQEW1bKq3a3yUZSObOoWLFQ4ohg==";
=======
        sha1 = "f3a6135758459733ae2b95638056e1854e7ef507";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "read_pkg___read_pkg_5.2.0.tgz";
      path = fetchurl {
        name = "read_pkg___read_pkg_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg/-/read-pkg-5.2.0.tgz";
<<<<<<< HEAD
        sha512 = "Ug69mNOpfvKDAc2Q8DRpMjjzdtrnv9HcSMX+4VsZxD1aZ6ZzrIE7rlzXBtWTyhULSMKg076AW6WR5iZpD0JiOg==";
      };
    }
    {
      name = "readable_stream___readable_stream_2.3.8.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_2.3.8.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.8.tgz";
        sha512 = "8p0AUk4XODgIewSi0l8Epjs+EVnWiK7NoDIEGU0HhE7+ZyY8D1IMY7odu5lRrFXGg71L15KG8QrPmum45RTtdA==";
=======
        sha1 = "7bf295438ca5a33e56cd30e053b34ee7250c93cc";
      };
    }
    {
      name = "readable_stream___readable_stream_2.3.7.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_2.3.7.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.7.tgz";
        sha1 = "1eca1cf711aef814c04f62252a36a62f6cb23b57";
      };
    }
    {
      name = "readable_stream___readable_stream_3.6.0.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_3.6.0.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.0.tgz";
        sha1 = "337bbda3adc0706bd3e024426a286d4b4b2c9198";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "readdirp___readdirp_3.6.0.tgz";
      path = fetchurl {
        name = "readdirp___readdirp_3.6.0.tgz";
        url  = "https://registry.yarnpkg.com/readdirp/-/readdirp-3.6.0.tgz";
<<<<<<< HEAD
        sha512 = "hOS089on8RduqdbhvQ5Z37A0ESjsqz6qnRcffsMU3495FuTdqSm+7bhJ29JvIOsBDEEnan5DPu9t3To9VRlMzA==";
=======
        sha1 = "74a370bd857116e245b29cc97340cd431a02a6c7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "rechoir___rechoir_0.7.1.tgz";
      path = fetchurl {
        name = "rechoir___rechoir_0.7.1.tgz";
        url  = "https://registry.yarnpkg.com/rechoir/-/rechoir-0.7.1.tgz";
<<<<<<< HEAD
        sha512 = "/njmZ8s1wVeR6pjTZ+0nCnv8SpZNRMT2D1RLOJQESlYFDBvwpTA4KWJpZ+sBJ4+vhjILRcK7JIFdGCdxEAAitg==";
=======
        sha1 = "9478a96a1ca135b5e88fc027f03ee92d6c645686";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "redent___redent_3.0.0.tgz";
      path = fetchurl {
        name = "redent___redent_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/redent/-/redent-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "6tDA8g98We0zd0GvVeMT9arEOnTw9qM03L9cJXaCjrip1OO764RDBLBfrB4cwzNGDj5OA5ioymC9GkizgWJDUg==";
=======
        sha1 = "e557b7998316bb53c9f1f56fa626352c6963059f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "reduce_css_calc___reduce_css_calc_2.1.8.tgz";
      path = fetchurl {
        name = "reduce_css_calc___reduce_css_calc_2.1.8.tgz";
        url  = "https://registry.yarnpkg.com/reduce-css-calc/-/reduce-css-calc-2.1.8.tgz";
<<<<<<< HEAD
        sha512 = "8liAVezDmUcH+tdzoEGrhfbGcP7nOV4NkGE3a74+qqvE7nt9i4sKLGBuZNOnpI4WiGksiNPklZxva80061QiPg==";
      };
    }
    {
      name = "regenerate_unicode_properties___regenerate_unicode_properties_10.1.0.tgz";
      path = fetchurl {
        name = "regenerate_unicode_properties___regenerate_unicode_properties_10.1.0.tgz";
        url  = "https://registry.yarnpkg.com/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.0.tgz";
        sha512 = "d1VudCLoIGitcU/hEg2QqvyGZQmdC0Lf8BqdOMXGFSvJP4bNV1+XqbPQeHHLD51Jh4QJJ225dlIFvY4Ly6MXmQ==";
=======
        sha1 = "7ef8761a28d614980dc0c982f772c93f7a99de03";
      };
    }
    {
      name = "regenerate_unicode_properties___regenerate_unicode_properties_9.0.0.tgz";
      path = fetchurl {
        name = "regenerate_unicode_properties___regenerate_unicode_properties_9.0.0.tgz";
        url  = "https://registry.yarnpkg.com/regenerate-unicode-properties/-/regenerate-unicode-properties-9.0.0.tgz";
        sha1 = "54d09c7115e1f53dc2314a974b32c1c344efe326";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "regenerate___regenerate_1.4.2.tgz";
      path = fetchurl {
        name = "regenerate___regenerate_1.4.2.tgz";
        url  = "https://registry.yarnpkg.com/regenerate/-/regenerate-1.4.2.tgz";
<<<<<<< HEAD
        sha512 = "zrceR/XhGYU/d/opr2EKO7aRHUeiBI8qjtfHqADTwZd6Szfy16la6kqD0MIUs5z5hx6AaKa+PixpPrR289+I0A==";
      };
    }
    {
      name = "regenerator_runtime___regenerator_runtime_0.13.11.tgz";
      path = fetchurl {
        name = "regenerator_runtime___regenerator_runtime_0.13.11.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.13.11.tgz";
        sha512 = "kY1AZVr2Ra+t+piVaJ4gxaFaReZVH40AKNo7UCX6W+dEwBo/2oZJzqfuN1qLq1oL45o56cPaTXELwrTh8Fpggg==";
      };
    }
    {
      name = "regenerator_transform___regenerator_transform_0.15.1.tgz";
      path = fetchurl {
        name = "regenerator_transform___regenerator_transform_0.15.1.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-transform/-/regenerator-transform-0.15.1.tgz";
        sha512 = "knzmNAcuyxV+gQCufkYcvOqX/qIIfHLv0u5x79kRxuGojfYVky1f15TzZEu2Avte8QGepvUNTnLskf8E6X6Vyg==";
      };
    }
    {
      name = "regexp.prototype.flags___regexp.prototype.flags_1.5.0.tgz";
      path = fetchurl {
        name = "regexp.prototype.flags___regexp.prototype.flags_1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.5.0.tgz";
        sha512 = "0SutC3pNudRKgquxGoRGIz946MZVHqbNfPjBdxeOhBrdgDKlRoXmYLQN9xRbrR09ZXWeGAdPuif7egofn6v5LA==";
=======
        sha1 = "b9346d8827e8f5a32f7ba29637d398b69014848a";
      };
    }
    {
      name = "regenerator_runtime___regenerator_runtime_0.13.9.tgz";
      path = fetchurl {
        name = "regenerator_runtime___regenerator_runtime_0.13.9.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.13.9.tgz";
        sha1 = "8925742a98ffd90814988d7566ad30ca3b263b52";
      };
    }
    {
      name = "regenerator_transform___regenerator_transform_0.14.5.tgz";
      path = fetchurl {
        name = "regenerator_transform___regenerator_transform_0.14.5.tgz";
        url  = "https://registry.yarnpkg.com/regenerator-transform/-/regenerator-transform-0.14.5.tgz";
        sha1 = "c98da154683671c9c4dcb16ece736517e1b7feb4";
      };
    }
    {
      name = "regexp.prototype.flags___regexp.prototype.flags_1.4.1.tgz";
      path = fetchurl {
        name = "regexp.prototype.flags___regexp.prototype.flags_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.4.1.tgz";
        sha1 = "b3f4c0059af9e47eca9f3f660e51d81307e72307";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "regexpp___regexpp_3.2.0.tgz";
      path = fetchurl {
        name = "regexpp___regexpp_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/regexpp/-/regexpp-3.2.0.tgz";
<<<<<<< HEAD
        sha512 = "pq2bWo9mVD43nbts2wGv17XLiNLya+GklZ8kaDLV2Z08gDCsGpnKn9BFMepvWuHCbyVvY7J5o5+BVvoQbmlJLg==";
      };
    }
    {
      name = "regexpu_core___regexpu_core_5.3.2.tgz";
      path = fetchurl {
        name = "regexpu_core___regexpu_core_5.3.2.tgz";
        url  = "https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-5.3.2.tgz";
        sha512 = "RAM5FlZz+Lhmo7db9L298p2vHP5ZywrVXmVXpmAD9GuL5MPH6t9ROw1iA/wfHkQ76Qe7AaPF0nGuim96/IrQMQ==";
      };
    }
    {
      name = "regjsparser___regjsparser_0.9.1.tgz";
      path = fetchurl {
        name = "regjsparser___regjsparser_0.9.1.tgz";
        url  = "https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.9.1.tgz";
        sha512 = "dQUtn90WanSNl+7mQKcXAgZxvUe7Z0SqXlgzv0za4LwiUhyzBC58yQO3liFoUgu8GiJVInAhJjkj1N0EtQ5nkQ==";
=======
        sha1 = "0425a2768d8f23bad70ca4b90461fa2f1213e1b2";
      };
    }
    {
      name = "regexpu_core___regexpu_core_4.8.0.tgz";
      path = fetchurl {
        name = "regexpu_core___regexpu_core_4.8.0.tgz";
        url  = "https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-4.8.0.tgz";
        sha1 = "e5605ba361b67b1718478501327502f4479a98f0";
      };
    }
    {
      name = "regjsgen___regjsgen_0.5.2.tgz";
      path = fetchurl {
        name = "regjsgen___regjsgen_0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/regjsgen/-/regjsgen-0.5.2.tgz";
        sha1 = "92ff295fb1deecbf6ecdab2543d207e91aa33733";
      };
    }
    {
      name = "regjsparser___regjsparser_0.7.0.tgz";
      path = fetchurl {
        name = "regjsparser___regjsparser_0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.7.0.tgz";
        sha1 = "a6b667b54c885e18b52554cb4960ef71187e9968";
      };
    }
    {
      name = "remark_parse___remark_parse_9.0.0.tgz";
      path = fetchurl {
        name = "remark_parse___remark_parse_9.0.0.tgz";
        url  = "https://registry.yarnpkg.com/remark-parse/-/remark-parse-9.0.0.tgz";
        sha1 = "4d20a299665880e4f4af5d90b7c7b8a935853640";
      };
    }
    {
      name = "remark_stringify___remark_stringify_9.0.1.tgz";
      path = fetchurl {
        name = "remark_stringify___remark_stringify_9.0.1.tgz";
        url  = "https://registry.yarnpkg.com/remark-stringify/-/remark-stringify-9.0.1.tgz";
        sha1 = "576d06e910548b0a7191a71f27b33f1218862894";
      };
    }
    {
      name = "remark___remark_13.0.0.tgz";
      path = fetchurl {
        name = "remark___remark_13.0.0.tgz";
        url  = "https://registry.yarnpkg.com/remark/-/remark-13.0.0.tgz";
        sha1 = "d15d9bf71a402f40287ebe36067b66d54868e425";
      };
    }
    {
      name = "repeat_string___repeat_string_1.6.1.tgz";
      path = fetchurl {
        name = "repeat_string___repeat_string_1.6.1.tgz";
        url  = "https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz";
        sha1 = "8dcae470e1c88abc2d600fff4a776286da75e637";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "require_from_string___require_from_string_2.0.2.tgz";
      path = fetchurl {
        name = "require_from_string___require_from_string_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz";
<<<<<<< HEAD
        sha512 = "Xf0nWe6RseziFMu+Ap9biiUbmplq6S9/p+7w7YXP/JBHhrUDDUhwa+vANyubuqfZWTveU//DYVGsDG7RKL/vEw==";
=======
        sha1 = "89a7fdd938261267318eafe14f9c32e598c36909";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "resolve_cwd___resolve_cwd_3.0.0.tgz";
      path = fetchurl {
        name = "resolve_cwd___resolve_cwd_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-cwd/-/resolve-cwd-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "OrZaX2Mb+rJCpH/6CpSqt9xFVpN++x01XnN2ie9g6P5/3xelLAkXWVADpdz1IHD/KFfEXyE6V0U01OQ3UO2rEg==";
=======
        sha1 = "0f0075f1bb2544766cf73ba6a6e2adfebcb13f2d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "resolve_from___resolve_from_4.0.0.tgz";
      path = fetchurl {
        name = "resolve_from___resolve_from_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "pb/MYmXstAkysRFx8piNI1tGFNQIFA3vkE3Gq4EuA1dF6gHp/+vgZqsCGJapvy8N3Q+4o7FwvquPJcnZ7RYy4g==";
=======
        sha1 = "4abcd852ad32dd7baabfe9b40e00a36db5f392e6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "resolve_from___resolve_from_5.0.0.tgz";
      path = fetchurl {
        name = "resolve_from___resolve_from_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-from/-/resolve-from-5.0.0.tgz";
<<<<<<< HEAD
        sha512 = "qYg9KP24dD5qka9J47d0aVky0N+b4fTU89LN9iDnjB5waksiC49rvMB0PrUJQGoTmH50XPiqOvAjDfaijGxYZw==";
=======
        sha1 = "c35225843df8f776df21c57557bc087e9dfdfc69";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "resolve_pathname___resolve_pathname_3.0.0.tgz";
      path = fetchurl {
        name = "resolve_pathname___resolve_pathname_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-pathname/-/resolve-pathname-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "C7rARubxI8bXFNB/hqcp/4iUeIXJhJZvFPFPiSPRnhU5UPxzMFIl+2E6yY6c4k9giDJAhtV+enfA+G89N6Csng==";
      };
    }
    {
      name = "resolve___resolve_1.22.2.tgz";
      path = fetchurl {
        name = "resolve___resolve_1.22.2.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.22.2.tgz";
        sha512 = "Sb+mjNHOULsBv818T40qSPeRiuWLyaGMa5ewydRLFimneixmVy2zdivRl+AF6jaYPC8ERxGDmFSiqui6SfPd+g==";
      };
    }
    {
      name = "resolve___resolve_2.0.0_next.4.tgz";
      path = fetchurl {
        name = "resolve___resolve_2.0.0_next.4.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-2.0.0-next.4.tgz";
        sha512 = "iMDbmAWtfU+MHpxt/I5iWI7cY6YVEZUQ3MBgPQ++XD1PELuJHIl82xBmObyP2KyQmkNB2dsqF7seoQQiAn5yDQ==";
=======
        sha1 = "99d02224d3cf263689becbb393bc560313025dcd";
      };
    }
    {
      name = "resolve___resolve_1.22.0.tgz";
      path = fetchurl {
        name = "resolve___resolve_1.22.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.22.0.tgz";
        sha1 = "5e0b8c67c15df57a89bdbabe603a002f21731198";
      };
    }
    {
      name = "resolve___resolve_2.0.0_next.3.tgz";
      path = fetchurl {
        name = "resolve___resolve_2.0.0_next.3.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-2.0.0-next.3.tgz";
        sha1 = "d41016293d4a8586a39ca5d9b5f15cbea1f55e46";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "reusify___reusify_1.0.4.tgz";
      path = fetchurl {
        name = "reusify___reusify_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz";
<<<<<<< HEAD
        sha512 = "U9nH88a3fc/ekCF1l0/UP1IosiuIjyTh7hBvXVMHYgVcfGvt897Xguj2UOLDeI5BG2m7/uwyaLVT6fbtCwTyzw==";
=======
        sha1 = "90da382b1e126efc02146e90845a88db12925d76";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "rgb_regex___rgb_regex_1.0.1.tgz";
      path = fetchurl {
        name = "rgb_regex___rgb_regex_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/rgb-regex/-/rgb-regex-1.0.1.tgz";
<<<<<<< HEAD
        sha512 = "gDK5mkALDFER2YLqH6imYvK6g02gpNGM4ILDZ472EwWfXZnC2ZEpoB2ECXTyOVUKuk/bPJZMzwQPBYICzP+D3w==";
=======
        sha1 = "c0e0d6882df0e23be254a475e8edd41915feaeb1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "rgba_regex___rgba_regex_1.0.0.tgz";
      path = fetchurl {
        name = "rgba_regex___rgba_regex_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/rgba-regex/-/rgba-regex-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "zgn5OjNQXLUTdq8m17KdaicF6w89TZs8ZU8y0AYENIU6wG8GG6LLm0yLSiPY8DmaYmHdgRW8rnApjoT0fQRfMg==";
=======
        sha1 = "43374e2e2ca0968b0ef1523460b7d730ff22eeb3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "rimraf___rimraf_3.0.2.tgz";
      path = fetchurl {
        name = "rimraf___rimraf_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz";
<<<<<<< HEAD
        sha512 = "JZkJMZkAGFFPP2YqXZXPbMlMBgsxzE8ILs4lMIX/2o0L9UBw9O/Y3o6wFw/i9YLapcUJWwqbi3kdxIPdC62TIA==";
=======
        sha1 = "f1a5402ba6220ad52cc1282bac1ae3aa49fd061a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "run_parallel___run_parallel_1.2.0.tgz";
      path = fetchurl {
        name = "run_parallel___run_parallel_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.2.0.tgz";
<<<<<<< HEAD
        sha512 = "5l4VyZR86LZ/lDxZTR6jqL8AFE2S0IFLMP26AbjsLVADxHdhB/c0GUsH+y39UfCi3dzz8OlQuPmnaJOMoDHQBA==";
=======
        sha1 = "66d1368da7bdf921eb9d95bd1a9229e7f21a43ee";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "rw___rw_1.3.3.tgz";
      path = fetchurl {
        name = "rw___rw_1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/rw/-/rw-1.3.3.tgz";
<<<<<<< HEAD
        sha512 = "PdhdWy89SiZogBLaw42zdeqtRJ//zFd2PgQavcICDUgJT5oW10QCRKbJ6bg4r0/UY2M6BWd5tkxuGFRvCkgfHQ==";
=======
        sha1 = "3f862dfa91ab766b14885ef4d01124bfda074fb4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "safe_buffer___safe_buffer_5.2.1.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.2.1.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz";
<<<<<<< HEAD
        sha512 = "rp3So07KcdmmKbGvgaNxQSJr7bGVSVk5S9Eq1F+ppbRo70+YeaDxkw5Dd8NPN+GD6bjnYm2VuPuCXmpuYvmCXQ==";
=======
        sha1 = "1eaf9fa9bdb1fdd4ec75f58f9cdb4e6b7827eec6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "safe_buffer___safe_buffer_5.1.2.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz";
<<<<<<< HEAD
        sha512 = "Gd2UZBJDkXlY7GbJxfsE8/nvKkUEU1G38c1siN6QP6a9PT9MmHB8GnpscSmMJSoF8LOIrt8ud/wPtojys4G6+g==";
      };
    }
    {
      name = "safe_regex_test___safe_regex_test_1.0.0.tgz";
      path = fetchurl {
        name = "safe_regex_test___safe_regex_test_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.0.0.tgz";
        sha512 = "JBUUzyOgEwXQY1NuPtvcj/qcBDbDmEvWufhlnXZIm75DEHp+afM1r1ujJpJsV/gSM4t59tpDyPi1sd6ZaPFfsA==";
=======
        sha1 = "991ec69d296e0313747d59bdfd2b745c35f8828d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "scheduler___scheduler_0.19.1.tgz";
      path = fetchurl {
        name = "scheduler___scheduler_0.19.1.tgz";
        url  = "https://registry.yarnpkg.com/scheduler/-/scheduler-0.19.1.tgz";
<<<<<<< HEAD
        sha512 = "n/zwRWRYSUj0/3g/otKDRPMh6qv2SYMWNq85IEa8iZyAv8od9zDYpGSnpBEjNgcMNq6Scbu5KfIPxNF72R/2EA==";
=======
        sha1 = "4f3e2ed2c1a7d65681f4c854fa8c5a1ccb40f196";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "schema_utils___schema_utils_2.7.1.tgz";
      path = fetchurl {
        name = "schema_utils___schema_utils_2.7.1.tgz";
        url  = "https://registry.yarnpkg.com/schema-utils/-/schema-utils-2.7.1.tgz";
<<<<<<< HEAD
        sha512 = "SHiNtMOUGWBQJwzISiVYKu82GiV4QYGePp3odlY1tuKO7gPtphAT5R/py0fA6xtbgLL/RvtJZnU9b8s0F1q0Xg==";
      };
    }
    {
      name = "schema_utils___schema_utils_3.1.2.tgz";
      path = fetchurl {
        name = "schema_utils___schema_utils_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/schema-utils/-/schema-utils-3.1.2.tgz";
        sha512 = "pvjEHOgWc9OWA/f/DE3ohBWTD6EleVLf7iFUkoSwAxttdBhB9QUebQgxER2kWueOvRJXPHNnyrvvh9eZINB8Eg==";
      };
    }
    {
      name = "schema_utils___schema_utils_4.0.1.tgz";
      path = fetchurl {
        name = "schema_utils___schema_utils_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/schema-utils/-/schema-utils-4.0.1.tgz";
        sha512 = "lELhBAAly9NowEsX0yZBlw9ahZG+sK/1RJ21EpzdYHKEs13Vku3LJ+MIPhh4sMs0oCCeufZQEQbMekiA4vuVIQ==";
=======
        sha1 = "1ca4f32d1b24c590c203b8e7a50bf0ea4cd394d7";
      };
    }
    {
      name = "schema_utils___schema_utils_3.1.1.tgz";
      path = fetchurl {
        name = "schema_utils___schema_utils_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/schema-utils/-/schema-utils-3.1.1.tgz";
        sha1 = "bc74c4b6b6995c1d88f76a8b77bea7219e0c8281";
      };
    }
    {
      name = "schema_utils___schema_utils_4.0.0.tgz";
      path = fetchurl {
        name = "schema_utils___schema_utils_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/schema-utils/-/schema-utils-4.0.0.tgz";
        sha1 = "60331e9e3ae78ec5d16353c467c34b3a0a1d3df7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "semver___semver_5.7.1.tgz";
      path = fetchurl {
        name = "semver___semver_5.7.1.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz";
<<<<<<< HEAD
        sha512 = "sauaDf/PZdVgrLTNYHRtpXa1iRiKcaebiKQ1BJdpQlWH2lCvexQdX55snPFyK7QzpudqbCI0qXFfOasHdyNDGQ==";
=======
        sha1 = "a954f931aeba508d307bbf069eff0c01c96116f7";
      };
    }
    {
      name = "semver___semver_7.0.0.tgz";
      path = fetchurl {
        name = "semver___semver_7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-7.0.0.tgz";
        sha1 = "5f3ca35761e47e05b206c6daff2cf814f0316b8e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "semver___semver_6.3.0.tgz";
      path = fetchurl {
        name = "semver___semver_6.3.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz";
<<<<<<< HEAD
        sha512 = "b39TBaTSfV6yBrapU89p5fKekE2m/NwnDocOVruQFS1/veMgdzuPcnOM34M6CwxW8jH/lxEa5rBoDeUwu5HHTw==";
      };
    }
    {
      name = "semver___semver_7.5.0.tgz";
      path = fetchurl {
        name = "semver___semver_7.5.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-7.5.0.tgz";
        sha512 = "+XC0AD/R7Q2mPSRuy2Id0+CGTZ98+8f+KvwirxOKIEyid+XSx6HbC63p+O4IndTHuX5Z+JxQ0TghCkO5Cg/2HA==";
      };
    }
    {
      name = "serialize_javascript___serialize_javascript_6.0.1.tgz";
      path = fetchurl {
        name = "serialize_javascript___serialize_javascript_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-6.0.1.tgz";
        sha512 = "owoXEFjWRllis8/M1Q+Cw5k8ZH40e3zhp/ovX+Xr/vi1qj6QesbyXXViFbpNvWvPNAD62SutwEXavefrLJWj7w==";
=======
        sha1 = "ee0a64c8af5e8ceea67687b133761e1becbd1d3d";
      };
    }
    {
      name = "semver___semver_7.3.5.tgz";
      path = fetchurl {
        name = "semver___semver_7.3.5.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-7.3.5.tgz";
        sha1 = "0b621c879348d8998e4b0e4be94b3f12e6018ef7";
      };
    }
    {
      name = "serialize_javascript___serialize_javascript_6.0.0.tgz";
      path = fetchurl {
        name = "serialize_javascript___serialize_javascript_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-6.0.0.tgz";
        sha1 = "efae5d88f45d7924141da8b5c3a7a7e663fefeb8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "shallow_clone___shallow_clone_3.0.1.tgz";
      path = fetchurl {
        name = "shallow_clone___shallow_clone_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/shallow-clone/-/shallow-clone-3.0.1.tgz";
<<<<<<< HEAD
        sha512 = "/6KqX+GVUdqPuPPd2LxDDxzX6CAbjJehAAOKlNpqqUpAqPM6HeL8f+o3a+JsyGjn2lv0WY8UsTgUJjU9Ok55NA==";
=======
        sha1 = "8f2981ad92531f55035b01fb230769a40e02efa3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "shallow_copy___shallow_copy_0.0.1.tgz";
      path = fetchurl {
        name = "shallow_copy___shallow_copy_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/shallow-copy/-/shallow-copy-0.0.1.tgz";
<<<<<<< HEAD
        sha512 = "b6i4ZpVuUxB9h5gfCxPiusKYkqTMOjEbBs4wMaFbkfia4yFv92UKZ6Df8WXcKbn08JNL/abvg3FnMAOfakDvUw==";
=======
        sha1 = "415f42702d73d810330292cc5ee86eae1a11a170";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "shapefile___shapefile_0.3.1.tgz";
      path = fetchurl {
        name = "shapefile___shapefile_0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/shapefile/-/shapefile-0.3.1.tgz";
<<<<<<< HEAD
        sha512 = "BZoPvnq4ULce0pyKiZUU4D8CdPl0Z1fpE73AeCkwyMbD2hpUeVA0s7jIE/wX8uWNruVeJV6e+rznPHBwuH5J6g==";
=======
        sha1 = "9bb9a429bd6086a0cfb03962d14cfdf420ffba12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "shebang_command___shebang_command_2.0.0.tgz";
      path = fetchurl {
        name = "shebang_command___shebang_command_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz";
<<<<<<< HEAD
        sha512 = "kHxr2zZpYtdmrN1qDjrrX/Z1rR1kG8Dx+gkpK1G4eXmvXswmcE1hTWBWYUzlraYw1/yZp6YuDY77YtvbN0dmDA==";
=======
        sha1 = "ccd0af4f8835fbdc265b82461aaf0c36663f34ea";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "shebang_regex___shebang_regex_3.0.0.tgz";
      path = fetchurl {
        name = "shebang_regex___shebang_regex_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "7++dFhtcx3353uBaq8DDR4NuxBetBzC7ZQOhmTQInHEd6bSrXdiEyzCvG07Z44UYdLShWUyXt5M/yhz8ekcb1A==";
=======
        sha1 = "ae16f1644d873ecad843b0307b143362d4c42172";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "side_channel___side_channel_1.0.4.tgz";
      path = fetchurl {
        name = "side_channel___side_channel_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz";
<<<<<<< HEAD
        sha512 = "q5XPytqFEIKHkGdiMIrY10mvLRvnQh42/+GoBlFW3b2LXLE2xxJpZFdm94we0BaoV3RwJyGqg5wS7epxTv0Zvw==";
      };
    }
    {
      name = "signal_exit___signal_exit_3.0.7.tgz";
      path = fetchurl {
        name = "signal_exit___signal_exit_3.0.7.tgz";
        url  = "https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.7.tgz";
        sha512 = "wnD2ZE+l+SPC/uoS0vXeE9L1+0wuaMqKlfz9AMUo38JsyLSBWSFcHR1Rri62LZc12vLr1gb3jl7iwQhgwpAbGQ==";
=======
        sha1 = "efce5c8fdc104ee751b25c58d4290011fa5ea2cf";
      };
    }
    {
      name = "signal_exit___signal_exit_3.0.6.tgz";
      path = fetchurl {
        name = "signal_exit___signal_exit_3.0.6.tgz";
        url  = "https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.6.tgz";
        sha1 = "24e630c4b0f03fea446a2bd299e62b4a6ca8d0af";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "simple_swizzle___simple_swizzle_0.2.2.tgz";
      path = fetchurl {
        name = "simple_swizzle___simple_swizzle_0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/simple-swizzle/-/simple-swizzle-0.2.2.tgz";
<<<<<<< HEAD
        sha512 = "JA//kQgZtbuY83m+xT+tXJkmJncGMTFT+C+g2h2R9uxkYIrE2yy9sgmcLhCnw57/WSD+Eh3J97FPEDFnbXnDUg==";
=======
        sha1 = "a4da6b635ffcccca33f70d17cb92592de95e557a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "sirv___sirv_1.0.19.tgz";
      path = fetchurl {
        name = "sirv___sirv_1.0.19.tgz";
        url  = "https://registry.yarnpkg.com/sirv/-/sirv-1.0.19.tgz";
<<<<<<< HEAD
        sha512 = "JuLThK3TnZG1TAKDwNIqNq6QA2afLOCcm+iE8D1Kj3GA40pSPsxQjjJl0J8X3tsR7T+CP1GavpzLwYkgVLWrZQ==";
=======
        sha1 = "1d73979b38c7fe91fcba49c85280daa9c2363b49";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "slash___slash_3.0.0.tgz";
      path = fetchurl {
        name = "slash___slash_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/slash/-/slash-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "g9Q1haeby36OSStwb4ntCGGGaKsaVSjQ68fBxoQcutl5fS1vuY18H3wSt3jFyFtrkx+Kz0V1G85A4MyAdDMi2Q==";
=======
        sha1 = "6539be870c165adbd5240220dbe361f1bc4d4634";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "slice_ansi___slice_ansi_4.0.0.tgz";
      path = fetchurl {
        name = "slice_ansi___slice_ansi_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "qMCMfhY040cVHT43K9BFygqYbUPFZKHOg7K73mtTWJRb8pyP3fzf4Ixd5SzdEJQ6MRUg/WBnOLxghZtKKurENQ==";
=======
        sha1 = "500e8dd0fd55b05815086255b3195adf2a45fe6b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "source_list_map___source_list_map_2.0.1.tgz";
      path = fetchurl {
        name = "source_list_map___source_list_map_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/source-list-map/-/source-list-map-2.0.1.tgz";
<<<<<<< HEAD
        sha512 = "qnQ7gVMxGNxsiL4lEuJwe/To8UnK7fAnmbGEEH8RpLouuKbeEm0lhbQVFIrNSuB+G7tVrAlVsZgETT5nljf+Iw==";
=======
        sha1 = "3993bd873bfc48479cca9ea3a547835c7c154b34";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "source_map_js___source_map_js_1.0.2.tgz";
      path = fetchurl {
        name = "source_map_js___source_map_js_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/source-map-js/-/source-map-js-1.0.2.tgz";
<<<<<<< HEAD
        sha512 = "R0XvVJ9WusLiqTCEiGCmICCMplcCkIwwR11mOSD9CR5u+IXYdiseeEuXCVAjS54zqwkLcPNnmU4OeJ6tUrWhDw==";
=======
        sha1 = "adbc361d9c62df380125e7f161f71c826f1e490c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "source_map_support___source_map_support_0.5.21.tgz";
      path = fetchurl {
        name = "source_map_support___source_map_support_0.5.21.tgz";
        url  = "https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz";
<<<<<<< HEAD
        sha512 = "uBHU3L3czsIyYXKX88fdrGovxdSCoTGDRZ6SYXtSRxLZUzHg5P/66Ht6uoUlHu9EZod+inXhKo3qQgwXUT/y1w==";
=======
        sha1 = "04fe7c7f9e1ed2d662233c28cb2b35b9f63f6e4f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "source_map___source_map_0.5.7.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.5.7.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz";
<<<<<<< HEAD
        sha512 = "LbrmJOMUSdEVxIKvdcJzQC+nQhe8FUZQTXQy6+I75skNgn3OoQ0DZA8YnFa7gp8tqtL3KPf1kmo0R5DoApeSGQ==";
=======
        sha1 = "8a039d2d1021d22d1ea14c80d8ea468ba2ef3fcc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "source_map___source_map_0.6.1.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz";
<<<<<<< HEAD
        sha512 = "UjgapumWlbMhkBgzT7Ykc5YXUT46F0iKu8SGXq0bcwP5dz/h0Plj6enJqjz1Zbq2l5WaqYnrVbwWOWMyF3F47g==";
      };
    }
    {
      name = "spdx_correct___spdx_correct_3.2.0.tgz";
      path = fetchurl {
        name = "spdx_correct___spdx_correct_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.2.0.tgz";
        sha512 = "kN9dJbvnySHULIluDHy32WHRUu3Og7B9sbY7tsFLctQkIqnMh3hErYgdMjTYuqmcXX+lK5T1lnUt3G7zNswmZA==";
=======
        sha1 = "74722af32e9614e9c287a8d0bbde48b5e2f1a263";
      };
    }
    {
      name = "source_map___source_map_0.7.3.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.7.3.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.7.3.tgz";
        sha1 = "5302f8169031735226544092e64981f751750383";
      };
    }
    {
      name = "spdx_correct___spdx_correct_3.1.1.tgz";
      path = fetchurl {
        name = "spdx_correct___spdx_correct_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.1.1.tgz";
        sha1 = "dece81ac9c1e6713e5f7d1b6f17d468fa53d89a9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "spdx_exceptions___spdx_exceptions_2.3.0.tgz";
      path = fetchurl {
        name = "spdx_exceptions___spdx_exceptions_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz";
<<<<<<< HEAD
        sha512 = "/tTrYOC7PPI1nUAgx34hUpqXuyJG+DTHJTnIULG4rDygi4xu/tfgmq1e1cIRwRzwZgo4NLySi+ricLkZkw4i5A==";
=======
        sha1 = "3f28ce1a77a00372683eade4a433183527a2163d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "spdx_expression_parse___spdx_expression_parse_3.0.1.tgz";
      path = fetchurl {
        name = "spdx_expression_parse___spdx_expression_parse_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz";
<<<<<<< HEAD
        sha512 = "cbqHunsQWnJNE6KhVSMsMeH5H/L9EpymbzqTQ3uLwNCLZ1Q481oWaofqH7nO6V07xlXwY6PhQdQ2IedWx/ZK4Q==";
      };
    }
    {
      name = "spdx_license_ids___spdx_license_ids_3.0.13.tgz";
      path = fetchurl {
        name = "spdx_license_ids___spdx_license_ids_3.0.13.tgz";
        url  = "https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz";
        sha512 = "XkD+zwiqXHikFZm4AX/7JSCXA98U5Db4AFd5XUg/+9UNtnH75+Z9KxtpYiJZx36mUDVOwH83pl7yvCer6ewM3w==";
=======
        sha1 = "cf70f50482eefdc98e3ce0a6833e4a53ceeba679";
      };
    }
    {
      name = "spdx_license_ids___spdx_license_ids_3.0.11.tgz";
      path = fetchurl {
        name = "spdx_license_ids___spdx_license_ids_3.0.11.tgz";
        url  = "https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.11.tgz";
        sha1 = "50c0d8c40a14ec1bf449bae69a0ea4685a9d9f95";
      };
    }
    {
      name = "specificity___specificity_0.4.1.tgz";
      path = fetchurl {
        name = "specificity___specificity_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/specificity/-/specificity-0.4.1.tgz";
        sha1 = "aab5e645012db08ba182e151165738d00887b019";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "sprintf_js___sprintf_js_1.0.3.tgz";
      path = fetchurl {
        name = "sprintf_js___sprintf_js_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz";
<<<<<<< HEAD
        sha512 = "D9cPgkvLlV3t3IzL0D0YLvGA9Ahk4PcvVwUbN0dSGr1aP0Nrt4AEnTUbuGvquEC0mA64Gqt1fzirlRs5ibXx8g==";
=======
        sha1 = "04e6926f662895354f3dd015203633b857297e2c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "stable___stable_0.1.8.tgz";
      path = fetchurl {
        name = "stable___stable_0.1.8.tgz";
        url  = "https://registry.yarnpkg.com/stable/-/stable-0.1.8.tgz";
<<<<<<< HEAD
        sha512 = "ji9qxRnOVfcuLDySj9qzhGSEFVobyt1kIOSkj1qZzYLzq7Tos/oUUWvotUPQLlrsidqsK6tBH89Bc9kL5zHA6w==";
=======
        sha1 = "836eb3c8382fe2936feaf544631017ce7d47a3cf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "static_eval___static_eval_2.1.0.tgz";
      path = fetchurl {
        name = "static_eval___static_eval_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/static-eval/-/static-eval-2.1.0.tgz";
<<<<<<< HEAD
        sha512 = "agtxZ/kWSsCkI5E4QifRwsaPs0P0JmZV6dkLz6ILYfFYQGn+5plctanRN+IC8dJRiFkyXHrwEE3W9Wmx67uDbw==";
=======
        sha1 = "a16dbe54522d7fa5ef1389129d813fd47b148014";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "static_module___static_module_2.2.5.tgz";
      path = fetchurl {
        name = "static_module___static_module_2.2.5.tgz";
        url  = "https://registry.yarnpkg.com/static-module/-/static-module-2.2.5.tgz";
<<<<<<< HEAD
        sha512 = "D8vv82E/Kpmz3TXHKG8PPsCPg+RAX6cbCOyvjM6x04qZtQ47EtJFVwRsdov3n5d6/6ynrOY9XB4JkaZwB2xoRQ==";
      };
    }
    {
      name = "stop_iteration_iterator___stop_iteration_iterator_1.0.0.tgz";
      path = fetchurl {
        name = "stop_iteration_iterator___stop_iteration_iterator_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stop-iteration-iterator/-/stop-iteration-iterator-1.0.0.tgz";
        sha512 = "iCGQj+0l0HOdZ2AEeBADlsRC+vsnDsZsbdSiH1yNSjcfKM7fdpCMfqAL/dwF5BLiw/XhRft/Wax6zQbhq2BcjQ==";
=======
        sha1 = "bd40abceae33da6b7afb84a0e4329ff8852bfbbf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "string_width___string_width_4.2.3.tgz";
      path = fetchurl {
        name = "string_width___string_width_4.2.3.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz";
<<<<<<< HEAD
        sha512 = "wKyQRQpjJ0sIp62ErSZdGsjMJWsap5oRNihHhu6G7JVO/9jIB6UyevL+tXuOqrng8j/cxKTWyWUwvSTriiZz/g==";
      };
    }
    {
      name = "string.prototype.matchall___string.prototype.matchall_4.0.8.tgz";
      path = fetchurl {
        name = "string.prototype.matchall___string.prototype.matchall_4.0.8.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.matchall/-/string.prototype.matchall-4.0.8.tgz";
        sha512 = "6zOCOcJ+RJAQshcTvXPHoxoQGONa3e/Lqx90wUA+wEzX78sg5Bo+1tQo4N0pohS0erG9qtCqJDjNCQBjeWVxyg==";
      };
    }
    {
      name = "string.prototype.trim___string.prototype.trim_1.2.7.tgz";
      path = fetchurl {
        name = "string.prototype.trim___string.prototype.trim_1.2.7.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz";
        sha512 = "p6TmeT1T3411M8Cgg9wBTMRtY2q9+PNy9EV1i2lIXUN/btt763oIfxwN3RR8VU6wHX8j/1CFy0L+YuThm6bgOg==";
      };
    }
    {
      name = "string.prototype.trimend___string.prototype.trimend_1.0.6.tgz";
      path = fetchurl {
        name = "string.prototype.trimend___string.prototype.trimend_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz";
        sha512 = "JySq+4mrPf9EsDBEDYMOb/lM7XQLulwg5R/m1r0PXEFqrV0qHvl58sdTilSXtKOflCsK2E8jxf+GKC0T07RWwQ==";
      };
    }
    {
      name = "string.prototype.trimstart___string.prototype.trimstart_1.0.6.tgz";
      path = fetchurl {
        name = "string.prototype.trimstart___string.prototype.trimstart_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz";
        sha512 = "omqjMDaY92pbn5HOX7f9IccLA+U1tA9GvtU4JrodiXFfYB7jPzzHpRzpglLAjtUV6bB557zwClJezTqnAiYnQA==";
=======
        sha1 = "269c7117d27b05ad2e536830a8ec895ef9c6d010";
      };
    }
    {
      name = "string.prototype.matchall___string.prototype.matchall_4.0.6.tgz";
      path = fetchurl {
        name = "string.prototype.matchall___string.prototype.matchall_4.0.6.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.matchall/-/string.prototype.matchall-4.0.6.tgz";
        sha1 = "5abb5dabc94c7b0ea2380f65ba610b3a544b15fa";
      };
    }
    {
      name = "string.prototype.trimend___string.prototype.trimend_1.0.4.tgz";
      path = fetchurl {
        name = "string.prototype.trimend___string.prototype.trimend_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.4.tgz";
        sha1 = "e75ae90c2942c63504686c18b287b4a0b1a45f80";
      };
    }
    {
      name = "string.prototype.trimstart___string.prototype.trimstart_1.0.4.tgz";
      path = fetchurl {
        name = "string.prototype.trimstart___string.prototype.trimstart_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.4.tgz";
        sha1 = "b36399af4ab2999b4c9c648bd7a3fb2bb26feeed";
      };
    }
    {
      name = "string_decoder___string_decoder_1.3.0.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz";
        sha1 = "42f114594a46cf1a8e30b0a84f56c78c3edac21e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "string_decoder___string_decoder_1.1.1.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz";
<<<<<<< HEAD
        sha512 = "n/ShnvDi6FHbbVfviro+WojiFzv+s8MPMHBczVePfUpDJLwoLT0ht1l4YwBCbi8pJAveEEdnkHyPyTP/mzRfwg==";
=======
        sha1 = "9cf1611ba62685d7030ae9e4ba34149c3af03fc8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "strip_ansi___strip_ansi_6.0.1.tgz";
      path = fetchurl {
        name = "strip_ansi___strip_ansi_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz";
<<<<<<< HEAD
        sha512 = "Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==";
=======
        sha1 = "9e26c63d30f53443e9489495b2105d37b67a85d9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "strip_bom___strip_bom_3.0.0.tgz";
      path = fetchurl {
        name = "strip_bom___strip_bom_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "vavAMRXOgBVNF6nyEEmL3DBK19iRpDcoIwW+swQ+CbGiu7lju6t+JklA1MHweoWtadgt4ISVUsXLyDq34ddcwA==";
=======
        sha1 = "2334c18e9c759f7bdd56fdef7e9ae3d588e68ed3";
      };
    }
    {
      name = "strip_final_newline___strip_final_newline_2.0.0.tgz";
      path = fetchurl {
        name = "strip_final_newline___strip_final_newline_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-final-newline/-/strip-final-newline-2.0.0.tgz";
        sha1 = "89b852fb2fcbe936f6f4b3187afb0a12c1ab58ad";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "strip_indent___strip_indent_3.0.0.tgz";
      path = fetchurl {
        name = "strip_indent___strip_indent_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-indent/-/strip-indent-3.0.0.tgz";
<<<<<<< HEAD
        sha512 = "laJTa3Jb+VQpaC6DseHhF7dXVqHTfJPCRDaEbid/drOhgitgYku/letMUqOXFoWV0zIIUbjpdH2t+tYj4bQMRQ==";
=======
        sha1 = "c32e1cee940b6b3432c771bc2c54bcce73cd3001";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "strip_json_comments___strip_json_comments_3.1.1.tgz";
      path = fetchurl {
        name = "strip_json_comments___strip_json_comments_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz";
<<<<<<< HEAD
        sha512 = "6fPc+R4ihwqP6N/aIv2f1gMH8lOVtWQHoqC4yK6oSDVVocumAsfCqjkXnqiYMhmMwS/mEHLp7Vehlt3ql6lEig==";
=======
        sha1 = "31f1281b3832630434831c310c01cccda8cbe006";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "style_search___style_search_0.1.0.tgz";
      path = fetchurl {
        name = "style_search___style_search_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/style-search/-/style-search-0.1.0.tgz";
<<<<<<< HEAD
        sha512 = "Dj1Okke1C3uKKwQcetra4jSuk0DqbzbYtXipzFlFMZtowbF1x7BKJwB9AayVMyFARvU8EDrZdcax4At/452cAg==";
      };
    }
    {
      name = "stylehacks___stylehacks_5.1.1.tgz";
      path = fetchurl {
        name = "stylehacks___stylehacks_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/stylehacks/-/stylehacks-5.1.1.tgz";
        sha512 = "sBpcd5Hx7G6seo7b1LkpttvTz7ikD0LlH5RmdcBNb6fFR0Fl7LQwHDFr300q4cwUqi+IYrFGmsIHieMBfnN/Bw==";
      };
    }
    {
      name = "stylelint_config_prettier___stylelint_config_prettier_9.0.5.tgz";
      path = fetchurl {
        name = "stylelint_config_prettier___stylelint_config_prettier_9.0.5.tgz";
        url  = "https://registry.yarnpkg.com/stylelint-config-prettier/-/stylelint-config-prettier-9.0.5.tgz";
        sha512 = "U44lELgLZhbAD/xy/vncZ2Pq8sh2TnpiPvo38Ifg9+zeioR+LAkHu0i6YORIOxFafZoVg0xqQwex6e6F25S5XA==";
      };
    }
    {
      name = "stylelint_config_recommended___stylelint_config_recommended_6.0.0.tgz";
      path = fetchurl {
        name = "stylelint_config_recommended___stylelint_config_recommended_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stylelint-config-recommended/-/stylelint-config-recommended-6.0.0.tgz";
        sha512 = "ZorSSdyMcxWpROYUvLEMm0vSZud2uB7tX1hzBZwvVY9SV/uly4AvvJPPhCcymZL3fcQhEQG5AELmrxWqtmzacw==";
      };
    }
    {
      name = "stylelint_config_standard___stylelint_config_standard_24.0.0.tgz";
      path = fetchurl {
        name = "stylelint_config_standard___stylelint_config_standard_24.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stylelint-config-standard/-/stylelint-config-standard-24.0.0.tgz";
        sha512 = "+RtU7fbNT+VlNbdXJvnjc3USNPZRiRVp/d2DxOF/vBDDTi0kH5RX2Ny6errdtZJH3boO+bmqIYEllEmok4jiuw==";
      };
    }
    {
      name = "stylelint___stylelint_14.16.1.tgz";
      path = fetchurl {
        name = "stylelint___stylelint_14.16.1.tgz";
        url  = "https://registry.yarnpkg.com/stylelint/-/stylelint-14.16.1.tgz";
        sha512 = "ErlzR/T3hhbV+a925/gbfc3f3Fep9/bnspMiJPorfGEmcBbXdS+oo6LrVtoUZ/w9fqD6o6k7PtUlCOsCRdjX/A==";
=======
        sha1 = "7958c793e47e32e07d2b5cafe5c0bf8e12e77902";
      };
    }
    {
      name = "stylehacks___stylehacks_5.0.2.tgz";
      path = fetchurl {
        name = "stylehacks___stylehacks_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/stylehacks/-/stylehacks-5.0.2.tgz";
        sha1 = "fa10e5181c6e8dc0bddb4a3fb372e9ac42bba2ad";
      };
    }
    {
      name = "stylelint_config_prettier___stylelint_config_prettier_8.0.2.tgz";
      path = fetchurl {
        name = "stylelint_config_prettier___stylelint_config_prettier_8.0.2.tgz";
        url  = "https://registry.yarnpkg.com/stylelint-config-prettier/-/stylelint-config-prettier-8.0.2.tgz";
        sha1 = "da9de33da4c56893cbe7e26df239a7374045e14e";
      };
    }
    {
      name = "stylelint_config_recommended___stylelint_config_recommended_3.0.0.tgz";
      path = fetchurl {
        name = "stylelint_config_recommended___stylelint_config_recommended_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stylelint-config-recommended/-/stylelint-config-recommended-3.0.0.tgz";
        sha1 = "e0e547434016c5539fe2650afd58049a2fd1d657";
      };
    }
    {
      name = "stylelint_config_standard___stylelint_config_standard_20.0.0.tgz";
      path = fetchurl {
        name = "stylelint_config_standard___stylelint_config_standard_20.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stylelint-config-standard/-/stylelint-config-standard-20.0.0.tgz";
        sha1 = "06135090c9e064befee3d594289f50e295b5e20d";
      };
    }
    {
      name = "stylelint___stylelint_13.13.1.tgz";
      path = fetchurl {
        name = "stylelint___stylelint_13.13.1.tgz";
        url  = "https://registry.yarnpkg.com/stylelint/-/stylelint-13.13.1.tgz";
        sha1 = "fca9c9f5de7990ab26a00f167b8978f083a18f3c";
      };
    }
    {
      name = "sugarss___sugarss_2.0.0.tgz";
      path = fetchurl {
        name = "sugarss___sugarss_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/sugarss/-/sugarss-2.0.0.tgz";
        sha1 = "ddd76e0124b297d40bf3cca31c8b22ecb43bc61d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "supports_color___supports_color_5.5.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_5.5.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz";
<<<<<<< HEAD
        sha512 = "QjVjwdXIt408MIiAqCX4oUKsgU2EqAGzs2Ppkm4aQYbjm+ZEWEcW4SfFNTr4uMNZma0ey4f5lgLrkB0aX0QMow==";
=======
        sha1 = "e2e69a44ac8772f78a1ec0b35b689df6530efc8f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "supports_color___supports_color_7.2.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_7.2.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz";
<<<<<<< HEAD
        sha512 = "qpCAvRl9stuOHveKsn7HncJRvv501qIacKzQlO/+Lwxc9+0q2wLyv4Dfvt80/DPn2pqOBsJdDiogXGR9+OvwRw==";
=======
        sha1 = "1b7dcdcb32b8138801b3e478ba6a51caa89648da";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "supports_color___supports_color_8.1.1.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_8.1.1.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-8.1.1.tgz";
<<<<<<< HEAD
        sha512 = "MpUEN2OodtUzxvKQl72cUF7RQ5EiHsGvSsVG0ia9c5RbWGL2CI4C7EpPS8UTBIplnlzZiNuV56w+FuNxy3ty2Q==";
      };
    }
    {
      name = "supports_hyperlinks___supports_hyperlinks_2.3.0.tgz";
      path = fetchurl {
        name = "supports_hyperlinks___supports_hyperlinks_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-hyperlinks/-/supports-hyperlinks-2.3.0.tgz";
        sha512 = "RpsAZlpWcDwOPQA22aCH4J0t7L8JmAvsCxfOSEwm7cQs3LshN36QaTkwd70DnBOXDWGssw2eUoc8CaRWT0XunA==";
=======
        sha1 = "cd6fc17e28500cff56c1b86c0a7fd4a54a73005c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "supports_preserve_symlinks_flag___supports_preserve_symlinks_flag_1.0.0.tgz";
      path = fetchurl {
        name = "supports_preserve_symlinks_flag___supports_preserve_symlinks_flag_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "ot0WnXS9fgdkgIcePe6RHNk1WA8+muPa6cSjeR3V8K27q9BB1rTE3R1p7Hv0z1ZyAc8s6Vvv8DIyWf681MAt0w==";
=======
        sha1 = "6eda4bd344a3c94aea376d4cc31bc77311039e09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "svg_tags___svg_tags_1.0.0.tgz";
      path = fetchurl {
        name = "svg_tags___svg_tags_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/svg-tags/-/svg-tags-1.0.0.tgz";
<<<<<<< HEAD
        sha512 = "ovssysQTa+luh7A5Weu3Rta6FJlFBBbInjOh722LIt6klpU2/HtdUbszju/G4devcvk8PGt7FCLv5wftu3THUA==";
=======
        sha1 = "58f71cee3bd519b59d4b2a843b6c7de64ac04764";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "svgo___svgo_2.8.0.tgz";
      path = fetchurl {
        name = "svgo___svgo_2.8.0.tgz";
        url  = "https://registry.yarnpkg.com/svgo/-/svgo-2.8.0.tgz";
<<<<<<< HEAD
        sha512 = "+N/Q9kV1+F+UeWYoSiULYo4xYSDQlTgb+ayMobAXPwMnLvop7oxKMo9OzIrX5x3eS4L4f2UHhc9axXwY8DpChg==";
      };
    }
    {
      name = "table___table_6.8.1.tgz";
      path = fetchurl {
        name = "table___table_6.8.1.tgz";
        url  = "https://registry.yarnpkg.com/table/-/table-6.8.1.tgz";
        sha512 = "Y4X9zqrCftUhMeH2EptSSERdVKt/nEdijTOacGD/97EKjhQ/Qs8RTlEGABSJNNN8lac9kheH+af7yAkEWlgneA==";
=======
        sha1 = "4ff80cce6710dc2795f0c7c74101e6764cfccd24";
      };
    }
    {
      name = "table___table_6.8.0.tgz";
      path = fetchurl {
        name = "table___table_6.8.0.tgz";
        url  = "https://registry.yarnpkg.com/table/-/table-6.8.0.tgz";
        sha1 = "87e28f14fa4321c3377ba286f07b79b281a3b3ca";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "tailwindcss___tailwindcss_2.2.19.tgz";
      path = fetchurl {
        name = "tailwindcss___tailwindcss_2.2.19.tgz";
        url  = "https://registry.yarnpkg.com/tailwindcss/-/tailwindcss-2.2.19.tgz";
<<<<<<< HEAD
        sha512 = "6Ui7JSVtXadtTUo2NtkBBacobzWiQYVjYW0ZnKaP9S1ZCKQ0w7KVNz+YSDI/j7O7KCMHbOkz94ZMQhbT9pOqjw==";
=======
        sha1 = "540e464832cd462bb9649c1484b0a38315c2653c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "tapable___tapable_2.2.1.tgz";
      path = fetchurl {
        name = "tapable___tapable_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/tapable/-/tapable-2.2.1.tgz";
<<<<<<< HEAD
        sha512 = "GNzQvQTOIP6RyTfE2Qxb8ZVlNmw0n88vp1szwWRimP02mnTsx3Wtn5qRdqY9w2XduFNUgvOwhNnQsjwCp+kqaQ==";
      };
    }
    {
      name = "terser_webpack_plugin___terser_webpack_plugin_5.3.7.tgz";
      path = fetchurl {
        name = "terser_webpack_plugin___terser_webpack_plugin_5.3.7.tgz";
        url  = "https://registry.yarnpkg.com/terser-webpack-plugin/-/terser-webpack-plugin-5.3.7.tgz";
        sha512 = "AfKwIktyP7Cu50xNjXF/6Qb5lBNzYaWpU6YfoX3uZicTx0zTy0stDDCsvjDapKsSDvOeWo5MEq4TmdBy2cNoHw==";
      };
    }
    {
      name = "terser___terser_5.17.1.tgz";
      path = fetchurl {
        name = "terser___terser_5.17.1.tgz";
        url  = "https://registry.yarnpkg.com/terser/-/terser-5.17.1.tgz";
        sha512 = "hVl35zClmpisy6oaoKALOpS0rDYLxRFLHhRuDlEGTKey9qHjS1w9GMORjuwIMt70Wan4lwsLYyWDVnWgF+KUEw==";
=======
        sha1 = "1967a73ef4060a82f12ab96af86d52fdb76eeca0";
      };
    }
    {
      name = "terser_webpack_plugin___terser_webpack_plugin_5.3.0.tgz";
      path = fetchurl {
        name = "terser_webpack_plugin___terser_webpack_plugin_5.3.0.tgz";
        url  = "https://registry.yarnpkg.com/terser-webpack-plugin/-/terser-webpack-plugin-5.3.0.tgz";
        sha1 = "21641326486ecf91d8054161c816e464435bae9f";
      };
    }
    {
      name = "terser___terser_5.10.0.tgz";
      path = fetchurl {
        name = "terser___terser_5.10.0.tgz";
        url  = "https://registry.yarnpkg.com/terser/-/terser-5.10.0.tgz";
        sha1 = "b86390809c0389105eb0a0b62397563096ddafcc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "text_table___text_table_0.2.0.tgz";
      path = fetchurl {
        name = "text_table___text_table_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz";
<<<<<<< HEAD
        sha512 = "N+8UisAXDGk8PFXP4HAzVR9nbfmVJ3zYLAWiTIoqC5v5isinhr+r5uaO8+7r3BMfuNIufIsA7RdpVgacC2cSpw==";
=======
        sha1 = "7f5ee823ae805207c00af2df4a84ec3fcfa570b4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "through2___through2_2.0.5.tgz";
      path = fetchurl {
        name = "through2___through2_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz";
<<<<<<< HEAD
        sha512 = "/mrRod8xqpA+IHSLyGCQ2s8SPHiCDEeQJSep1jqLYeEUClOFG2Qsh+4FU6G9VeqpZnGW/Su8LQGc4YKni5rYSQ==";
      };
    }
    {
      name = "tiny_invariant___tiny_invariant_1.3.1.tgz";
      path = fetchurl {
        name = "tiny_invariant___tiny_invariant_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/tiny-invariant/-/tiny-invariant-1.3.1.tgz";
        sha512 = "AD5ih2NlSssTCwsMznbvwMZpJ1cbhkGd2uueNxzv2jDlEeZdU04JQfRnggJQ8DrcVBGjAsCKwFBbDlVNtEMlzw==";
=======
        sha1 = "01c1e39eb31d07cb7d03a96a70823260b23132cd";
      };
    }
    {
      name = "timsort___timsort_0.3.0.tgz";
      path = fetchurl {
        name = "timsort___timsort_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/timsort/-/timsort-0.3.0.tgz";
        sha1 = "405411a8e7e6339fe64db9a234de11dc31e02bd4";
      };
    }
    {
      name = "tiny_invariant___tiny_invariant_1.2.0.tgz";
      path = fetchurl {
        name = "tiny_invariant___tiny_invariant_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/tiny-invariant/-/tiny-invariant-1.2.0.tgz";
        sha1 = "a1141f86b672a9148c72e978a19a73b9b94a15a9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "tiny_warning___tiny_warning_1.0.3.tgz";
      path = fetchurl {
        name = "tiny_warning___tiny_warning_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/tiny-warning/-/tiny-warning-1.0.3.tgz";
<<<<<<< HEAD
        sha512 = "lBN9zLN/oAf68o3zNXYrdCt1kP8WsiGW8Oo2ka41b2IM5JL/S1CTyX1rW0mb/zSuJun0ZUrDxx4sqvYS2FWzPA==";
=======
        sha1 = "94a30db453df4c643d0fd566060d60a875d84754";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "tmp___tmp_0.2.1.tgz";
      path = fetchurl {
        name = "tmp___tmp_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/tmp/-/tmp-0.2.1.tgz";
<<<<<<< HEAD
        sha512 = "76SUhtfqR2Ijn+xllcI5P1oyannHNHByD80W1q447gU3mp9G9PSpGdWmjUOHRDPiHYacIk66W7ubDTuPF3BEtQ==";
=======
        sha1 = "8457fc3037dcf4719c251367a1af6500ee1ccf14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "to_fast_properties___to_fast_properties_2.0.0.tgz";
      path = fetchurl {
        name = "to_fast_properties___to_fast_properties_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-2.0.0.tgz";
<<<<<<< HEAD
        sha512 = "/OaKK0xYrs3DmxRYqL/yDc+FxFUVYhDlXMhRmv3z915w2HF1tnN1omB354j8VUGO/hbRzyD6Y3sA7v7GS/ceog==";
=======
        sha1 = "dc5e698cbd079265bc73e0377681a4e4e83f616e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "to_regex_range___to_regex_range_5.0.1.tgz";
      path = fetchurl {
        name = "to_regex_range___to_regex_range_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz";
<<<<<<< HEAD
        sha512 = "65P7iz6X5yEr1cwcgvQxbbIw7Uk3gOy5dIdtZ4rDveLqhrdJP+Li/Hx6tyK0NEb+2GCyneCMJiGqrADCSNk8sQ==";
=======
        sha1 = "1648c44aae7c8d988a326018ed72f5b4dd0392e4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "topojson___topojson_1.6.27.tgz";
      path = fetchurl {
        name = "topojson___topojson_1.6.27.tgz";
        url  = "https://registry.yarnpkg.com/topojson/-/topojson-1.6.27.tgz";
<<<<<<< HEAD
        sha512 = "JLFtrhClUH/k/yvsiCXqcWcXaOfO3DgFvHnYb+gS2xlDbjbvkKh6YB1CPilmEV++tH33xw6wCxoYA5g6YLZw/Q==";
      };
    }
    {
      name = "toposort___toposort_2.0.2.tgz";
      path = fetchurl {
        name = "toposort___toposort_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/toposort/-/toposort-2.0.2.tgz";
        sha512 = "0a5EOkAUp8D4moMi2W8ZF8jcga7BgZd91O/yabJCFY8az+XSzeGyTKs0Aoo897iV1Nj6guFq8orWDS96z91oGg==";
=======
        sha1 = "adbe33a67e2f1673d338df12644ad20fc20b42ed";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "totalist___totalist_1.1.0.tgz";
      path = fetchurl {
        name = "totalist___totalist_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/totalist/-/totalist-1.1.0.tgz";
<<<<<<< HEAD
        sha512 = "gduQwd1rOdDMGxFG1gEvhV88Oirdo2p+KjoYFU7k2g+i7n6AFFbDQ5kMPUsW0pNbfQsB/cwXvT1i4Bue0s9g5g==";
=======
        sha1 = "a4d65a3e546517701e3e5c37a47a70ac97fe56df";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "trim_newlines___trim_newlines_3.0.1.tgz";
      path = fetchurl {
        name = "trim_newlines___trim_newlines_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/trim-newlines/-/trim-newlines-3.0.1.tgz";
<<<<<<< HEAD
        sha512 = "c1PTsA3tYrIsLGkJkzHF+w9F2EyxfXGo4UyJc4pFL++FMjnq0HJS69T3M7d//gKrFKwy429bouPescbjecU+Zw==";
      };
    }
    {
      name = "tsconfig_paths___tsconfig_paths_3.14.2.tgz";
      path = fetchurl {
        name = "tsconfig_paths___tsconfig_paths_3.14.2.tgz";
        url  = "https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz";
        sha512 = "o/9iXgCYc5L/JxCHPe3Hvh8Q/2xm5Z+p18PESBU6Ff33695QnCHBEjcytY2q19ua7Mbl/DavtBOLq+oG0RCL+g==";
      };
    }
    {
      name = "tslib___tslib_2.5.0.tgz";
      path = fetchurl {
        name = "tslib___tslib_2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/tslib/-/tslib-2.5.0.tgz";
        sha512 = "336iVw3rtn2BUK7ORdIAHTyxHGRIHVReokCR3XjbckJMK7ms8FysBfhLR8IXnAgy7T0PTPNBWKiH514FOW/WSg==";
=======
        sha1 = "260a5d962d8b752425b32f3a7db0dcacd176c144";
      };
    }
    {
      name = "trough___trough_1.0.5.tgz";
      path = fetchurl {
        name = "trough___trough_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/trough/-/trough-1.0.5.tgz";
        sha1 = "b8b639cefad7d0bb2abd37d433ff8293efa5f406";
      };
    }
    {
      name = "tsconfig_paths___tsconfig_paths_3.12.0.tgz";
      path = fetchurl {
        name = "tsconfig_paths___tsconfig_paths_3.12.0.tgz";
        url  = "https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.12.0.tgz";
        sha1 = "19769aca6ee8f6a1a341e38c8fa45dd9fb18899b";
      };
    }
    {
      name = "tslib___tslib_2.3.1.tgz";
      path = fetchurl {
        name = "tslib___tslib_2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/tslib/-/tslib-2.3.1.tgz";
        sha1 = "e8a335add5ceae51aa261d32a490158ef042ef01";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "type_check___type_check_0.4.0.tgz";
      path = fetchurl {
        name = "type_check___type_check_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/type-check/-/type-check-0.4.0.tgz";
<<<<<<< HEAD
        sha512 = "XleUoc9uwGXqjWwXaUTZAmzMcFZ5858QA2vvx1Ur5xIcixXIP+8LnFDgRplU30us6teqdlskFfu+ae4K79Ooew==";
=======
        sha1 = "07b8203bfa7056c0657050e3ccd2c37730bab8f1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "type_check___type_check_0.3.2.tgz";
      path = fetchurl {
        name = "type_check___type_check_0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/type-check/-/type-check-0.3.2.tgz";
<<<<<<< HEAD
        sha512 = "ZCmOJdvOWDBYJlzAoFkC+Q0+bUyEOS1ltgp1MGU03fqHG+dbi9tBFU2Rd9QKiDZFAYrhPh2JUf7rZRIuHRKtOg==";
=======
        sha1 = "5884cab512cf1d355e3fb784f30804b2b520db72";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "type_fest___type_fest_0.18.1.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.18.1.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.18.1.tgz";
<<<<<<< HEAD
        sha512 = "OIAYXk8+ISY+qTOwkHtKqzAuxchoMiD9Udx+FSGQDuiRR+PJKJHc2NJAXlbhkGwTt/4/nKZxELY1w3ReWOL8mw==";
=======
        sha1 = "db4bc151a4a2cf4eebf9add5db75508db6cc841f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "type_fest___type_fest_0.20.2.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.20.2.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.20.2.tgz";
<<<<<<< HEAD
        sha512 = "Ne+eE4r0/iWnpAxD852z3A+N0Bt5RN//NjJwRd2VFHEmrywxf5vsZlh4R6lixl6B+wz/8d+maTSAkN1FIkI3LQ==";
=======
        sha1 = "1bf207f4b28f91583666cb5fbd327887301cd5f4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "type_fest___type_fest_0.6.0.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.6.0.tgz";
<<<<<<< HEAD
        sha512 = "q+MB8nYR1KDLrgr4G5yemftpMC7/QLqVndBmEEdqzmNj5dcFOO4Oo8qlwZE3ULT3+Zim1F8Kq4cBnikNhlCMlg==";
=======
        sha1 = "8d2a2370d3df886eb5c90ada1c5bf6188acf838b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "type_fest___type_fest_0.8.1.tgz";
      path = fetchurl {
        name = "type_fest___type_fest_0.8.1.tgz";
        url  = "https://registry.yarnpkg.com/type-fest/-/type-fest-0.8.1.tgz";
<<<<<<< HEAD
        sha512 = "4dbzIzqvjtgiM5rw1k5rEHtBANKmdudhGyBEajN01fEyhaAIhsoKNy6y7+IN93IfpFtwY9iqi7kD+xwKhQsNJA==";
      };
    }
    {
      name = "typed_array_length___typed_array_length_1.0.4.tgz";
      path = fetchurl {
        name = "typed_array_length___typed_array_length_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.4.tgz";
        sha512 = "KjZypGq+I/H7HI5HlOoGHkWUUGq+Q0TPhQurLbyrVrvnKTBgzLhIJ7j6J/XTQOi0d1RjyZ0wdas8bKs2p0x3Ng==";
=======
        sha1 = "09e249ebde851d3b1e48d27c105444667f17b83d";
      };
    }
    {
      name = "typedarray_to_buffer___typedarray_to_buffer_3.1.5.tgz";
      path = fetchurl {
        name = "typedarray_to_buffer___typedarray_to_buffer_3.1.5.tgz";
        url  = "https://registry.yarnpkg.com/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz";
        sha1 = "a97ee7a9ff42691b9f783ff1bc5112fe3fca9080";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "typedarray___typedarray_0.0.6.tgz";
      path = fetchurl {
        name = "typedarray___typedarray_0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz";
<<<<<<< HEAD
        sha512 = "/aCDEGatGvZ2BIk+HmLf4ifCJFwvKFNb9/JeZPMulfgFracn9QFcAf5GO8B/mweUjSoblS5In0cWhqpfs/5PQA==";
      };
    }
    {
      name = "unbox_primitive___unbox_primitive_1.0.2.tgz";
      path = fetchurl {
        name = "unbox_primitive___unbox_primitive_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.2.tgz";
        sha512 = "61pPlCD9h51VoreyJ0BReideM3MDKMKnh6+V9L08331ipq6Q8OFXZYiqP6n/tbHx4s5I9uRhcye6BrbkizkBDw==";
=======
        sha1 = "867ac74e3864187b1d3d47d996a78ec5c8830777";
      };
    }
    {
      name = "unbox_primitive___unbox_primitive_1.0.1.tgz";
      path = fetchurl {
        name = "unbox_primitive___unbox_primitive_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.1.tgz";
        sha1 = "085e215625ec3162574dc8859abee78a59b14471";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "unicode_canonical_property_names_ecmascript___unicode_canonical_property_names_ecmascript_2.0.0.tgz";
      path = fetchurl {
        name = "unicode_canonical_property_names_ecmascript___unicode_canonical_property_names_ecmascript_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz";
<<<<<<< HEAD
        sha512 = "yY5PpDlfVIU5+y/BSCxAJRBIS1Zc2dDG3Ujq+sR0U+JjUevW2JhocOF+soROYDSaAezOzOKuyyixhD6mBknSmQ==";
=======
        sha1 = "301acdc525631670d39f6146e0e77ff6bbdebddc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "unicode_match_property_ecmascript___unicode_match_property_ecmascript_2.0.0.tgz";
      path = fetchurl {
        name = "unicode_match_property_ecmascript___unicode_match_property_ecmascript_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz";
<<<<<<< HEAD
        sha512 = "5kaZCrbp5mmbz5ulBkDkbY0SsPOjKqVS35VpL9ulMPfSl0J0Xsm+9Evphv9CoIZFwre7aJoa94AY6seMKGVN5Q==";
      };
    }
    {
      name = "unicode_match_property_value_ecmascript___unicode_match_property_value_ecmascript_2.1.0.tgz";
      path = fetchurl {
        name = "unicode_match_property_value_ecmascript___unicode_match_property_value_ecmascript_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz";
        sha512 = "qxkjQt6qjg/mYscYMC0XKRn3Rh0wFPlfxB0xkt9CfyTvpX1Ra0+rAmdX2QyAobptSEvuy4RtpPRui6XkV+8wjA==";
      };
    }
    {
      name = "unicode_property_aliases_ecmascript___unicode_property_aliases_ecmascript_2.1.0.tgz";
      path = fetchurl {
        name = "unicode_property_aliases_ecmascript___unicode_property_aliases_ecmascript_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz";
        sha512 = "6t3foTQI9qne+OZoVQB/8x8rk2k1eVy1gRXhV3oFQ5T6R1dqQ1xtin3XqSlx3+ATBkliTaR/hHyJBm+LVPNM8w==";
=======
        sha1 = "54fd16e0ecb167cf04cf1f756bdcc92eba7976c3";
      };
    }
    {
      name = "unicode_match_property_value_ecmascript___unicode_match_property_value_ecmascript_2.0.0.tgz";
      path = fetchurl {
        name = "unicode_match_property_value_ecmascript___unicode_match_property_value_ecmascript_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.0.0.tgz";
        sha1 = "1a01aa57247c14c568b89775a54938788189a714";
      };
    }
    {
      name = "unicode_property_aliases_ecmascript___unicode_property_aliases_ecmascript_2.0.0.tgz";
      path = fetchurl {
        name = "unicode_property_aliases_ecmascript___unicode_property_aliases_ecmascript_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.0.0.tgz";
        sha1 = "0a36cb9a585c4f6abd51ad1deddb285c165297c8";
      };
    }
    {
      name = "unified___unified_9.2.2.tgz";
      path = fetchurl {
        name = "unified___unified_9.2.2.tgz";
        url  = "https://registry.yarnpkg.com/unified/-/unified-9.2.2.tgz";
        sha1 = "67649a1abfc3ab85d2969502902775eb03146975";
      };
    }
    {
      name = "unist_util_find_all_after___unist_util_find_all_after_3.0.2.tgz";
      path = fetchurl {
        name = "unist_util_find_all_after___unist_util_find_all_after_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/unist-util-find-all-after/-/unist-util-find-all-after-3.0.2.tgz";
        sha1 = "fdfecd14c5b7aea5e9ef38d5e0d5f774eeb561f6";
      };
    }
    {
      name = "unist_util_is___unist_util_is_4.1.0.tgz";
      path = fetchurl {
        name = "unist_util_is___unist_util_is_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/unist-util-is/-/unist-util-is-4.1.0.tgz";
        sha1 = "976e5f462a7a5de73d94b706bac1b90671b57797";
      };
    }
    {
      name = "unist_util_stringify_position___unist_util_stringify_position_2.0.3.tgz";
      path = fetchurl {
        name = "unist_util_stringify_position___unist_util_stringify_position_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/unist-util-stringify-position/-/unist-util-stringify-position-2.0.3.tgz";
        sha1 = "cce3bfa1cdf85ba7375d1d5b17bdc4cada9bd9da";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "universalify___universalify_2.0.0.tgz";
      path = fetchurl {
        name = "universalify___universalify_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz";
<<<<<<< HEAD
        sha512 = "hAZsKq7Yy11Zu1DE0OzWjw7nnLZmJZYTDZZyEFHZdUhV8FkH5MCfoU1XMaxXovpyW5nq5scPqq0ZDP9Zyl04oQ==";
      };
    }
    {
      name = "update_browserslist_db___update_browserslist_db_1.0.11.tgz";
      path = fetchurl {
        name = "update_browserslist_db___update_browserslist_db_1.0.11.tgz";
        url  = "https://registry.yarnpkg.com/update-browserslist-db/-/update-browserslist-db-1.0.11.tgz";
        sha512 = "dCwEFf0/oT85M1fHBg4F0jtLwJrutGoHSQXCh7u4o2t1drG+c0a9Flnqww6XUKSfQMPpJBRjU8d4RXB09qtvaA==";
=======
        sha1 = "75a4984efedc4b08975c5aeb73f530d02df25717";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "uri_js___uri_js_4.4.1.tgz";
      path = fetchurl {
        name = "uri_js___uri_js_4.4.1.tgz";
        url  = "https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz";
<<<<<<< HEAD
        sha512 = "7rKUyy33Q1yc98pQ1DAmLtwX109F7TIfWlW1Ydo8Wl1ii1SeHieeh0HHfPeL2fMXK6z0s8ecKs9frCuLJvndBg==";
=======
        sha1 = "9b1a52595225859e55f669d928f88c6c57f2a77e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "url_search_params_polyfill___url_search_params_polyfill_8.1.1.tgz";
      path = fetchurl {
        name = "url_search_params_polyfill___url_search_params_polyfill_8.1.1.tgz";
        url  = "https://registry.yarnpkg.com/url-search-params-polyfill/-/url-search-params-polyfill-8.1.1.tgz";
<<<<<<< HEAD
        sha512 = "KmkCs6SjE6t4ihrfW9JelAPQIIIFbJweaaSLTh/4AO+c58JlDcb+GbdPt8yr5lRcFg4rPswRFRRhBGpWwh0K/Q==";
=======
        sha1 = "9e69e4dba300a71ae7ad3cead62c7717fd99329f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "util_deprecate___util_deprecate_1.0.2.tgz";
      path = fetchurl {
        name = "util_deprecate___util_deprecate_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz";
<<<<<<< HEAD
        sha512 = "EPD5q1uXyFxJpCrLnCc1nHnq3gOa6DZBocAIiI2TaSCA7VCJ1UJDMagCzIkXNsUYfD1daK//LTEQ8xiIbrHtcw==";
=======
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "v8_compile_cache___v8_compile_cache_2.3.0.tgz";
      path = fetchurl {
        name = "v8_compile_cache___v8_compile_cache_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/v8-compile-cache/-/v8-compile-cache-2.3.0.tgz";
<<<<<<< HEAD
        sha512 = "l8lCEmLcLYZh4nbunNZvQCJc5pv7+RCwa8q/LdUx8u7lsWvPDKmpodJAJNwkAhJC//dFY48KuIEmjtd4RViDrA==";
=======
        sha1 = "2de19618c66dc247dcfb6f99338035d8245a2cee";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "validate_npm_package_license___validate_npm_package_license_3.0.4.tgz";
      path = fetchurl {
        name = "validate_npm_package_license___validate_npm_package_license_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz";
<<<<<<< HEAD
        sha512 = "DpKm2Ui/xN7/HQKCtpZxoRWBhZ9Z0kqtygG8XCgNQ8ZlDnxuQmWhj566j8fN4Cu3/JmbhsDo7fcAJq4s9h27Ew==";
=======
        sha1 = "fc91f6b9c7ba15c857f4cb2c5defeec39d4f410a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "value_equal___value_equal_1.0.1.tgz";
      path = fetchurl {
        name = "value_equal___value_equal_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/value-equal/-/value-equal-1.0.1.tgz";
<<<<<<< HEAD
        sha512 = "NOJ6JZCAWr0zlxZt+xqCHNTEKOsrks2HQd4MqhP1qy4z1SkbEP467eNx6TgDKXMvUOb+OENfJCZwM+16n7fRfw==";
=======
        sha1 = "1e0b794c734c5c0cade179c437d356d931a34d6c";
      };
    }
    {
      name = "vfile_message___vfile_message_2.0.4.tgz";
      path = fetchurl {
        name = "vfile_message___vfile_message_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/vfile-message/-/vfile-message-2.0.4.tgz";
        sha1 = "5b43b88171d409eae58477d13f23dd41d52c371a";
      };
    }
    {
      name = "vfile___vfile_4.2.1.tgz";
      path = fetchurl {
        name = "vfile___vfile_4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/vfile/-/vfile-4.2.1.tgz";
        sha1 = "03f1dce28fc625c625bc6514350fbdb00fa9e624";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "vlq___vlq_0.2.3.tgz";
      path = fetchurl {
        name = "vlq___vlq_0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/vlq/-/vlq-0.2.3.tgz";
<<<<<<< HEAD
        sha512 = "DRibZL6DsNhIgYQ+wNdWDL2SL3bKPlVrRiBqV5yuMm++op8W4kGFtaQfCs4KEJn0wBZcHVHJ3eoywX8983k1ow==";
      };
    }
    {
      name = "warning___warning_4.0.3.tgz";
      path = fetchurl {
        name = "warning___warning_4.0.3.tgz";
        url  = "https://registry.yarnpkg.com/warning/-/warning-4.0.3.tgz";
        sha512 = "rpJyN222KWIvHJ/F53XSZv0Zl/accqHR8et1kpaMTD/fLCRxtV8iX8czMzY7sVZupTI3zcUTg8eycS2kNF9l6w==";
      };
    }
    {
      name = "watchpack___watchpack_2.4.0.tgz";
      path = fetchurl {
        name = "watchpack___watchpack_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/watchpack/-/watchpack-2.4.0.tgz";
        sha512 = "Lcvm7MGST/4fup+ifyKi2hjyIAwcdI4HRgtvTpIUxBRhB+RFtUh8XtDOxUfctVCnhVi+QQj49i91OyvzkJl6cg==";
      };
    }
    {
      name = "webpack_bundle_analyzer___webpack_bundle_analyzer_4.8.0.tgz";
      path = fetchurl {
        name = "webpack_bundle_analyzer___webpack_bundle_analyzer_4.8.0.tgz";
        url  = "https://registry.yarnpkg.com/webpack-bundle-analyzer/-/webpack-bundle-analyzer-4.8.0.tgz";
        sha512 = "ZzoSBePshOKhr+hd8u6oCkZVwpVaXgpw23ScGLFpR6SjYI7+7iIWYarjN6OEYOfRt8o7ZyZZQk0DuMizJ+LEIg==";
      };
    }
    {
      name = "webpack_cli___webpack_cli_4.10.0.tgz";
      path = fetchurl {
        name = "webpack_cli___webpack_cli_4.10.0.tgz";
        url  = "https://registry.yarnpkg.com/webpack-cli/-/webpack-cli-4.10.0.tgz";
        sha512 = "NLhDfH/h4O6UOy+0LSso42xvYypClINuMNBVVzX4vX98TmTaTUxwRbXdhucbFMd2qLaCTcLq/PdYrvi8onw90w==";
=======
        sha1 = "8f3e4328cf63b1540c0d67e1b2778386f8975b26";
      };
    }
    {
      name = "watchpack___watchpack_2.3.1.tgz";
      path = fetchurl {
        name = "watchpack___watchpack_2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/watchpack/-/watchpack-2.3.1.tgz";
        sha1 = "4200d9447b401156eeca7767ee610f8809bc9d25";
      };
    }
    {
      name = "webpack_bundle_analyzer___webpack_bundle_analyzer_4.5.0.tgz";
      path = fetchurl {
        name = "webpack_bundle_analyzer___webpack_bundle_analyzer_4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/webpack-bundle-analyzer/-/webpack-bundle-analyzer-4.5.0.tgz";
        sha1 = "1b0eea2947e73528754a6f9af3e91b2b6e0f79d5";
      };
    }
    {
      name = "webpack_cli___webpack_cli_4.9.2.tgz";
      path = fetchurl {
        name = "webpack_cli___webpack_cli_4.9.2.tgz";
        url  = "https://registry.yarnpkg.com/webpack-cli/-/webpack-cli-4.9.2.tgz";
        sha1 = "77c1adaea020c3f9e2db8aad8ea78d235c83659d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "webpack_merge___webpack_merge_5.8.0.tgz";
      path = fetchurl {
        name = "webpack_merge___webpack_merge_5.8.0.tgz";
        url  = "https://registry.yarnpkg.com/webpack-merge/-/webpack-merge-5.8.0.tgz";
<<<<<<< HEAD
        sha512 = "/SaI7xY0831XwP6kzuwhKWVKDP9t1QY1h65lAFLbZqMPIuYcD9QAW4u9STIbU9kaJbPBB/geU/gLr1wDjOhQ+Q==";
=======
        sha1 = "2b39dbf22af87776ad744c390223731d30a68f61";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "webpack_sources___webpack_sources_1.4.3.tgz";
      path = fetchurl {
        name = "webpack_sources___webpack_sources_1.4.3.tgz";
        url  = "https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-1.4.3.tgz";
<<<<<<< HEAD
        sha512 = "lgTS3Xhv1lCOKo7SA5TjKXMjpSM4sBjNV5+q2bqesbSPs5FjGmU6jjtBSkX9b4qW87vDIsCIlUPOEhbZrMdjeQ==";
=======
        sha1 = "eedd8ec0b928fbf1cbfe994e22d2d890f330a933";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "webpack_sources___webpack_sources_2.3.1.tgz";
      path = fetchurl {
        name = "webpack_sources___webpack_sources_2.3.1.tgz";
        url  = "https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-2.3.1.tgz";
<<<<<<< HEAD
        sha512 = "y9EI9AO42JjEcrTJFOYmVywVZdKVUfOvDUPsJea5GIr1JOEGFVqwlY2K098fFoIjOkDzHn2AjRvM8dsBZu+gCA==";
=======
        sha1 = "570de0af163949fe272233c2cefe1b56f74511fd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "webpack___webpack_5.38.1.tgz";
      path = fetchurl {
        name = "webpack___webpack_5.38.1.tgz";
        url  = "https://registry.yarnpkg.com/webpack/-/webpack-5.38.1.tgz";
<<<<<<< HEAD
        sha512 = "OqRmYD1OJbHZph6RUMD93GcCZy4Z4wC0ele4FXyYF0J6AxO1vOSuIlU1hkS/lDlR9CDYBz64MZRmdbdnFFoT2g==";
=======
        sha1 = "5224c7f24c18e729268d3e3bc97240d6e880258e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "which_boxed_primitive___which_boxed_primitive_1.0.2.tgz";
      path = fetchurl {
        name = "which_boxed_primitive___which_boxed_primitive_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz";
<<<<<<< HEAD
        sha512 = "bwZdv0AKLpplFY2KZRX6TvyuN7ojjr7lwkg6ml0roIy9YeuSr7JS372qlNW18UQYzgYK9ziGcerWqZOmEn9VNg==";
      };
    }
    {
      name = "which_collection___which_collection_1.0.1.tgz";
      path = fetchurl {
        name = "which_collection___which_collection_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/which-collection/-/which-collection-1.0.1.tgz";
        sha512 = "W8xeTUwaln8i3K/cY1nGXzdnVZlidBcagyNFtBdD5kxnb4TvGKR7FfSIS3mYpwWS1QUCutfKz8IY8RjftB0+1A==";
      };
    }
    {
      name = "which_typed_array___which_typed_array_1.1.9.tgz";
      path = fetchurl {
        name = "which_typed_array___which_typed_array_1.1.9.tgz";
        url  = "https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.9.tgz";
        sha512 = "w9c4xkx6mPidwp7180ckYWfMmvxpjlZuIudNtDf4N/tTAUB8VJbX25qZoAsrtGuYNnGw3pa0AXgbGKRB8/EceA==";
=======
        sha1 = "13757bc89b209b049fe5d86430e21cf40a89a8e6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "which___which_1.3.1.tgz";
      path = fetchurl {
        name = "which___which_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-1.3.1.tgz";
<<<<<<< HEAD
        sha512 = "HxJdYWq1MTIQbJ3nw0cqssHoTNU267KlrDuGZ1WYlxDStUtKUhOaJmh112/TZmHxxUfuJqPXSOm7tDyas0OSIQ==";
=======
        sha1 = "a45043d54f5805316da8d62f9f50918d3da70b0a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "which___which_2.0.2.tgz";
      path = fetchurl {
        name = "which___which_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-2.0.2.tgz";
<<<<<<< HEAD
        sha512 = "BLI3Tl1TW3Pvl70l3yq3Y64i+awpwXqsGBYWkkqMtnbXgrMD+yj7rhW0kuEDxzJaYXGjEW5ogapKNMEKNMjibA==";
      };
    }
    {
      name = "wildcard___wildcard_2.0.1.tgz";
      path = fetchurl {
        name = "wildcard___wildcard_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/wildcard/-/wildcard-2.0.1.tgz";
        sha512 = "CC1bOL87PIWSBhDcTrdeLo6eGT7mCFtrg0uIJtqJUFyK+eJnzl8A1niH56uu7KMa5XFrtiV+AQuHO3n7DsHnLQ==";
=======
        sha1 = "7c6a8dd0a636a0327e10b59c9286eee93f3f51b1";
      };
    }
    {
      name = "wildcard___wildcard_2.0.0.tgz";
      path = fetchurl {
        name = "wildcard___wildcard_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/wildcard/-/wildcard-2.0.0.tgz";
        sha1 = "a77d20e5200c6faaac979e4b3aadc7b3dd7f8fec";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "word_wrap___word_wrap_1.2.3.tgz";
      path = fetchurl {
        name = "word_wrap___word_wrap_1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz";
<<<<<<< HEAD
        sha512 = "Hz/mrNwitNRh/HUAtM/VT/5VH+ygD6DV7mYKZAtHOrbs8U7lvPS6xf7EJKMF0uW1KJCl0H701g3ZGus+muE5vQ==";
=======
        sha1 = "610636f6b1f703891bd34771ccb17fb93b47079c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "wordwrap___wordwrap_0.0.3.tgz";
      path = fetchurl {
        name = "wordwrap___wordwrap_0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/wordwrap/-/wordwrap-0.0.3.tgz";
<<<<<<< HEAD
        sha512 = "1tMA907+V4QmxV7dbRvb4/8MaRALK6q9Abid3ndMYnbyo8piisCmeONVqVSXqQA3KaP4SLt5b7ud6E2sqP8TFw==";
=======
        sha1 = "a3d5da6cd5c0bc0008d37234bbaf1bed63059107";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "wrappy___wrappy_1.0.2.tgz";
      path = fetchurl {
        name = "wrappy___wrappy_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz";
<<<<<<< HEAD
        sha512 = "l4Sp/DRseor9wL6EvV2+TuQn63dMkPjZ/sp9XkghTEbV9KlPS1xUsZ3u7/IQO4wxtcFB4bgpQPRcR3QCvezPcQ==";
      };
    }
    {
      name = "write_file_atomic___write_file_atomic_4.0.2.tgz";
      path = fetchurl {
        name = "write_file_atomic___write_file_atomic_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-4.0.2.tgz";
        sha512 = "7KxauUdBmSdWnmpaGFg+ppNjKF8uNLry8LyzjauQDOVONfFLNKrKvQOxZ/VuTIcS/gge/YNahf5RIIQWTSarlg==";
      };
    }
    {
      name = "ws___ws_7.5.9.tgz";
      path = fetchurl {
        name = "ws___ws_7.5.9.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-7.5.9.tgz";
        sha512 = "F+P9Jil7UiSKSkppIiD94dN07AwvFixvLIj1Og1Rl9GGMuNipJnV9JzjD6XuqmAeiswGvUmNLjr5cFuXwNS77Q==";
=======
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    }
    {
      name = "write_file_atomic___write_file_atomic_3.0.3.tgz";
      path = fetchurl {
        name = "write_file_atomic___write_file_atomic_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-3.0.3.tgz";
        sha1 = "56bd5c5a5c70481cd19c571bd39ab965a5de56e8";
      };
    }
    {
      name = "ws___ws_7.5.6.tgz";
      path = fetchurl {
        name = "ws___ws_7.5.6.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-7.5.6.tgz";
        sha1 = "e59fc509fb15ddfb65487ee9765c5a51dec5fe7b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "xtend___xtend_4.0.2.tgz";
      path = fetchurl {
        name = "xtend___xtend_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz";
<<<<<<< HEAD
        sha512 = "LKYU1iAXJXUgAXn9URjiu+MWhyUXHsvfp7mcuYm9dSUKK0/CjtrUwFAxD82/mCWbtLsGjFIad0wIsod4zrTAEQ==";
      };
    }
    {
      name = "yallist___yallist_3.1.1.tgz";
      path = fetchurl {
        name = "yallist___yallist_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-3.1.1.tgz";
        sha512 = "a4UGQaWPH59mOXUYnAG2ewncQS4i4F43Tv3JoAM+s2VDAmS9NsK8GpDMLrCHPksFT7h3K6TOoUNn2pb7RoXx4g==";
=======
        sha1 = "bb72779f5fa465186b1f438f674fa347fdb5db54";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "yallist___yallist_4.0.0.tgz";
      path = fetchurl {
        name = "yallist___yallist_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz";
<<<<<<< HEAD
        sha512 = "3wdGidZyq5PB084XLES5TpOSRA3wjXAlIWMhum2kRcv/41Sn2emQ0dycQW4uZXLejwKvg6EsvbdlVL+FYEct7A==";
=======
        sha1 = "9bb92790d9c0effec63be73519e11a35019a3a72";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "yaml___yaml_1.10.2.tgz";
      path = fetchurl {
        name = "yaml___yaml_1.10.2.tgz";
        url  = "https://registry.yarnpkg.com/yaml/-/yaml-1.10.2.tgz";
<<<<<<< HEAD
        sha512 = "r3vXyErRCYJ7wg28yvBY5VSoAF8ZvlcW9/BwUzEtUsjvX/DKs24dIkuwjtuprwJJHsbyUbLApepYTR1BN4uHrg==";
=======
        sha1 = "2301c5ffbf12b467de8da2333a459e29e7920e4b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
    {
      name = "yargs_parser___yargs_parser_20.2.9.tgz";
      path = fetchurl {
        name = "yargs_parser___yargs_parser_20.2.9.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.9.tgz";
<<<<<<< HEAD
        sha512 = "y11nGElTIV+CT3Zv9t7VKl+Q3hTQoT9a1Qzezhhl6Rp21gJ/IVTW7Z3y9EWXhuUBC2Shnf+DX0antecpAwSP8w==";
      };
    }
    {
      name = "yup___yup_0.32.11.tgz";
      path = fetchurl {
        name = "yup___yup_0.32.11.tgz";
        url  = "https://registry.yarnpkg.com/yup/-/yup-0.32.11.tgz";
        sha512 = "Z2Fe1bn+eLstG8DRR6FTavGD+MeAwyfmouhHsIUgaADz8jvFKbO/fXc2trJKZg+5EBjh4gGm3iU/t3onKlXHIg==";
=======
        sha1 = "2eb7dc3b0289718fc295f362753845c41a0c94ee";
      };
    }
    {
      name = "zwitch___zwitch_1.0.5.tgz";
      path = fetchurl {
        name = "zwitch___zwitch_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/zwitch/-/zwitch-1.0.5.tgz";
        sha1 = "d11d7381ffed16b742f6af7b3f223d5cd9fe9920";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    }
  ];
}
