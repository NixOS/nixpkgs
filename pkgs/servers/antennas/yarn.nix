{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
      name = "accepts___accepts_1.3.5.tgz";
      path = fetchurl {
        name = "accepts___accepts_1.3.5.tgz";
        url  = "https://registry.yarnpkg.com/accepts/-/accepts-1.3.5.tgz";
        sha1 = "eb777df6011723a3b14e8a72c0805c8e86746bd2";
      };
    }
    {
      name = "ajv___ajv_5.5.2.tgz";
      path = fetchurl {
        name = "ajv___ajv_5.5.2.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-5.5.2.tgz";
        sha1 = "73b5eeca3fab653e3d3f9422b341ad42205dc965";
      };
    }
    {
      name = "ansi_regex___ansi_regex_2.1.1.tgz";
      path = fetchurl {
        name = "ansi_regex___ansi_regex_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz";
        sha1 = "c3b33ab5ee360d86e0e628f0468ae7ef27d654df";
      };
    }
    {
      name = "ansi_styles___ansi_styles_2.2.1.tgz";
      path = fetchurl {
        name = "ansi_styles___ansi_styles_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-2.2.1.tgz";
        sha1 = "b432dd3358b634cf75e1e4664368240533c1ddbe";
      };
    }
    {
      name = "any_promise___any_promise_1.3.0.tgz";
      path = fetchurl {
        name = "any_promise___any_promise_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/any-promise/-/any-promise-1.3.0.tgz";
        sha1 = "abc6afeedcea52e809cdc0376aed3ce39635d17f";
      };
    }
    {
      name = "argparse___argparse_1.0.10.tgz";
      path = fetchurl {
        name = "argparse___argparse_1.0.10.tgz";
        url  = "https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz";
        sha1 = "bcd6791ea5ae09725e17e5ad988134cd40b3d911";
      };
    }
    {
      name = "asn1___asn1_0.2.3.tgz";
      path = fetchurl {
        name = "asn1___asn1_0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/asn1/-/asn1-0.2.3.tgz";
        sha1 = "dac8787713c9966849fc8180777ebe9c1ddf3b86";
      };
    }
    {
      name = "assert_plus___assert_plus_1.0.0.tgz";
      path = fetchurl {
        name = "assert_plus___assert_plus_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/assert-plus/-/assert-plus-1.0.0.tgz";
        sha1 = "f12e0f3c5d77b0b1cdd9146942e4e96c1e4dd525";
      };
    }
    {
      name = "async___async_2.6.0.tgz";
      path = fetchurl {
        name = "async___async_2.6.0.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-2.6.0.tgz";
        sha1 = "61a29abb6fcc026fea77e56d1c6ec53a795951f4";
      };
    }
    {
      name = "asynckit___asynckit_0.4.0.tgz";
      path = fetchurl {
        name = "asynckit___asynckit_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz";
        sha1 = "c79ed97f7f34cb8f2ba1bc9790bcc366474b4b79";
      };
    }
    {
      name = "aws_sign2___aws_sign2_0.7.0.tgz";
      path = fetchurl {
        name = "aws_sign2___aws_sign2_0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/aws-sign2/-/aws-sign2-0.7.0.tgz";
        sha1 = "b46e890934a9591f2d2f6f86d7e6a9f1b3fe76a8";
      };
    }
    {
      name = "aws4___aws4_1.7.0.tgz";
      path = fetchurl {
        name = "aws4___aws4_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/aws4/-/aws4-1.7.0.tgz";
        sha1 = "d4d0e9b9dbfca77bf08eeb0a8a471550fe39e289";
      };
    }
    {
      name = "bcrypt_pbkdf___bcrypt_pbkdf_1.0.1.tgz";
      path = fetchurl {
        name = "bcrypt_pbkdf___bcrypt_pbkdf_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.1.tgz";
        sha1 = "63bc5dcb61331b92bc05fd528953c33462a06f8d";
      };
    }
    {
      name = "bluebird___bluebird_3.5.1.tgz";
      path = fetchurl {
        name = "bluebird___bluebird_3.5.1.tgz";
        url  = "https://registry.yarnpkg.com/bluebird/-/bluebird-3.5.1.tgz";
        sha1 = "d9551f9de98f1fcda1e683d17ee91a0602ee2eb9";
      };
    }
    {
      name = "boom___boom_4.3.1.tgz";
      path = fetchurl {
        name = "boom___boom_4.3.1.tgz";
        url  = "https://registry.yarnpkg.com/boom/-/boom-4.3.1.tgz";
        sha1 = "4f8a3005cb4a7e3889f749030fd25b96e01d2e31";
      };
    }
    {
      name = "boom___boom_5.2.0.tgz";
      path = fetchurl {
        name = "boom___boom_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/boom/-/boom-5.2.0.tgz";
        sha1 = "5dd9da6ee3a5f302077436290cb717d3f4a54e02";
      };
    }
    {
      name = "bytes___bytes_2.5.0.tgz";
      path = fetchurl {
        name = "bytes___bytes_2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/bytes/-/bytes-2.5.0.tgz";
        sha1 = "4c9423ea2d252c270c41b2bdefeff9bb6b62c06a";
      };
    }
    {
      name = "caseless___caseless_0.12.0.tgz";
      path = fetchurl {
        name = "caseless___caseless_0.12.0.tgz";
        url  = "https://registry.yarnpkg.com/caseless/-/caseless-0.12.0.tgz";
        sha1 = "1b681c21ff84033c826543090689420d187151dc";
      };
    }
    {
      name = "chalk___chalk_1.1.3.tgz";
      path = fetchurl {
        name = "chalk___chalk_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-1.1.3.tgz";
        sha1 = "a8115c55e4a702fe4d150abd3872822a7e09fc98";
      };
    }
    {
      name = "co___co_4.6.0.tgz";
      path = fetchurl {
        name = "co___co_4.6.0.tgz";
        url  = "https://registry.yarnpkg.com/co/-/co-4.6.0.tgz";
        sha1 = "6ea6bdf3d853ae54ccb8e47bfa0bf3f9031fb184";
      };
    }
    {
      name = "combined_stream___combined_stream_1.0.6.tgz";
      path = fetchurl {
        name = "combined_stream___combined_stream_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.6.tgz";
        sha1 = "723e7df6e801ac5613113a7e445a9b69cb632818";
      };
    }
    {
      name = "content_disposition___content_disposition_0.5.2.tgz";
      path = fetchurl {
        name = "content_disposition___content_disposition_0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/content-disposition/-/content-disposition-0.5.2.tgz";
        sha1 = "0cf68bb9ddf5f2be7961c3a85178cb85dba78cb4";
      };
    }
    {
      name = "content_type___content_type_1.0.4.tgz";
      path = fetchurl {
        name = "content_type___content_type_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/content-type/-/content-type-1.0.4.tgz";
        sha1 = "e138cc75e040c727b1966fe5e5f8c9aee256fe3b";
      };
    }
    {
      name = "cookies___cookies_0.7.1.tgz";
      path = fetchurl {
        name = "cookies___cookies_0.7.1.tgz";
        url  = "https://registry.yarnpkg.com/cookies/-/cookies-0.7.1.tgz";
        sha1 = "7c8a615f5481c61ab9f16c833731bcb8f663b99b";
      };
    }
    {
      name = "core_util_is___core_util_is_1.0.2.tgz";
      path = fetchurl {
        name = "core_util_is___core_util_is_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz";
        sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
      };
    }
    {
      name = "cryptiles___cryptiles_3.1.2.tgz";
      path = fetchurl {
        name = "cryptiles___cryptiles_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/cryptiles/-/cryptiles-3.1.2.tgz";
        sha1 = "a89fbb220f5ce25ec56e8c4aa8a4fd7b5b0d29fe";
      };
    }
    {
      name = "dashdash___dashdash_1.14.1.tgz";
      path = fetchurl {
        name = "dashdash___dashdash_1.14.1.tgz";
        url  = "https://registry.yarnpkg.com/dashdash/-/dashdash-1.14.1.tgz";
        sha1 = "853cfa0f7cbe2fed5de20326b8dd581035f6e2f0";
      };
    }
    {
      name = "debug___debug_2.6.9.tgz";
      path = fetchurl {
        name = "debug___debug_2.6.9.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz";
        sha1 = "5d128515df134ff327e90a4c93f4e077a536341f";
      };
    }
    {
      name = "debug___debug_3.1.0.tgz";
      path = fetchurl {
        name = "debug___debug_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-3.1.0.tgz";
        sha1 = "5bb5a0672628b64149566ba16819e61518c67261";
      };
    }
    {
      name = "deep_equal___deep_equal_1.0.1.tgz";
      path = fetchurl {
        name = "deep_equal___deep_equal_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/deep-equal/-/deep-equal-1.0.1.tgz";
        sha1 = "f5d260292b660e084eff4cdbc9f08ad3247448b5";
      };
    }
    {
      name = "delayed_stream___delayed_stream_1.0.0.tgz";
      path = fetchurl {
        name = "delayed_stream___delayed_stream_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz";
        sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
      };
    }
    {
      name = "delegates___delegates_1.0.0.tgz";
      path = fetchurl {
        name = "delegates___delegates_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz";
        sha1 = "84c6e159b81904fdca59a0ef44cd870d31250f9a";
      };
    }
    {
      name = "depd___depd_1.1.2.tgz";
      path = fetchurl {
        name = "depd___depd_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/depd/-/depd-1.1.2.tgz";
        sha1 = "9bcd52e14c097763e749b274c4346ed2e560b5a9";
      };
    }
    {
      name = "destroy___destroy_1.0.4.tgz";
      path = fetchurl {
        name = "destroy___destroy_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/destroy/-/destroy-1.0.4.tgz";
        sha1 = "978857442c44749e4206613e37946205826abd80";
      };
    }
    {
      name = "ecc_jsbn___ecc_jsbn_0.1.1.tgz";
      path = fetchurl {
        name = "ecc_jsbn___ecc_jsbn_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz";
        sha1 = "0fc73a9ed5f0d53c38193398523ef7e543777505";
      };
    }
    {
      name = "ee_first___ee_first_1.1.1.tgz";
      path = fetchurl {
        name = "ee_first___ee_first_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ee-first/-/ee-first-1.1.1.tgz";
        sha1 = "590c61156b0ae2f4f0255732a158b266bc56b21d";
      };
    }
    {
      name = "error_inject___error_inject_1.0.0.tgz";
      path = fetchurl {
        name = "error_inject___error_inject_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/error-inject/-/error-inject-1.0.0.tgz";
        sha1 = "e2b3d91b54aed672f309d950d154850fa11d4f37";
      };
    }
    {
      name = "escape_html___escape_html_1.0.3.tgz";
      path = fetchurl {
        name = "escape_html___escape_html_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/escape-html/-/escape-html-1.0.3.tgz";
        sha1 = "0258eae4d3d0c0974de1c169188ef0051d1d1988";
      };
    }
    {
      name = "escape_string_regexp___escape_string_regexp_1.0.5.tgz";
      path = fetchurl {
        name = "escape_string_regexp___escape_string_regexp_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
        sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
      };
    }
    {
      name = "esprima___esprima_4.0.0.tgz";
      path = fetchurl {
        name = "esprima___esprima_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-4.0.0.tgz";
        sha1 = "4499eddcd1110e0b218bacf2fa7f7f59f55ca804";
      };
    }
    {
      name = "extend___extend_3.0.1.tgz";
      path = fetchurl {
        name = "extend___extend_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/extend/-/extend-3.0.1.tgz";
        sha1 = "a755ea7bc1adfcc5a31ce7e762dbaadc5e636444";
      };
    }
    {
      name = "extsprintf___extsprintf_1.3.0.tgz";
      path = fetchurl {
        name = "extsprintf___extsprintf_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.3.0.tgz";
        sha1 = "96918440e3041a7a414f8c52e3c574eb3c3e1e05";
      };
    }
    {
      name = "fast_deep_equal___fast_deep_equal_1.1.0.tgz";
      path = fetchurl {
        name = "fast_deep_equal___fast_deep_equal_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-1.1.0.tgz";
        sha1 = "c053477817c86b51daa853c81e059b733d023614";
      };
    }
    {
      name = "fast_json_stable_stringify___fast_json_stable_stringify_2.0.0.tgz";
      path = fetchurl {
        name = "fast_json_stable_stringify___fast_json_stable_stringify_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.0.0.tgz";
        sha1 = "d5142c0caee6b1189f87d3a76111064f86c8bbf2";
      };
    }
    {
      name = "forever_agent___forever_agent_0.6.1.tgz";
      path = fetchurl {
        name = "forever_agent___forever_agent_0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/forever-agent/-/forever-agent-0.6.1.tgz";
        sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
      };
    }
    {
      name = "form_data___form_data_2.3.2.tgz";
      path = fetchurl {
        name = "form_data___form_data_2.3.2.tgz";
        url  = "https://registry.yarnpkg.com/form-data/-/form-data-2.3.2.tgz";
        sha1 = "4970498be604c20c005d4f5c23aecd21d6b49099";
      };
    }
    {
      name = "fresh___fresh_0.5.2.tgz";
      path = fetchurl {
        name = "fresh___fresh_0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/fresh/-/fresh-0.5.2.tgz";
        sha1 = "3d8cadd90d976569fa835ab1f8e4b23a105605a7";
      };
    }
    {
      name = "getpass___getpass_0.1.7.tgz";
      path = fetchurl {
        name = "getpass___getpass_0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/getpass/-/getpass-0.1.7.tgz";
        sha1 = "5eff8e3e684d569ae4cb2b1282604e8ba62149fa";
      };
    }
    {
      name = "har_schema___har_schema_2.0.0.tgz";
      path = fetchurl {
        name = "har_schema___har_schema_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/har-schema/-/har-schema-2.0.0.tgz";
        sha1 = "a94c2224ebcac04782a0d9035521f24735b7ec92";
      };
    }
    {
      name = "har_validator___har_validator_5.0.3.tgz";
      path = fetchurl {
        name = "har_validator___har_validator_5.0.3.tgz";
        url  = "https://registry.yarnpkg.com/har-validator/-/har-validator-5.0.3.tgz";
        sha1 = "ba402c266194f15956ef15e0fcf242993f6a7dfd";
      };
    }
    {
      name = "has_ansi___has_ansi_2.0.0.tgz";
      path = fetchurl {
        name = "has_ansi___has_ansi_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-ansi/-/has-ansi-2.0.0.tgz";
        sha1 = "34f5049ce1ecdf2b0649af3ef24e45ed35416d91";
      };
    }
    {
      name = "hawk___hawk_6.0.2.tgz";
      path = fetchurl {
        name = "hawk___hawk_6.0.2.tgz";
        url  = "https://registry.yarnpkg.com/hawk/-/hawk-6.0.2.tgz";
        sha1 = "af4d914eb065f9b5ce4d9d11c1cb2126eecc3038";
      };
    }
    {
      name = "hoek___hoek_4.2.1.tgz";
      path = fetchurl {
        name = "hoek___hoek_4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/hoek/-/hoek-4.2.1.tgz";
        sha1 = "9634502aa12c445dd5a7c5734b572bb8738aacbb";
      };
    }
    {
      name = "http_assert___http_assert_1.3.0.tgz";
      path = fetchurl {
        name = "http_assert___http_assert_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/http-assert/-/http-assert-1.3.0.tgz";
        sha1 = "a31a5cf88c873ecbb5796907d4d6f132e8c01e4a";
      };
    }
    {
      name = "http_errors___http_errors_1.6.3.tgz";
      path = fetchurl {
        name = "http_errors___http_errors_1.6.3.tgz";
        url  = "https://registry.yarnpkg.com/http-errors/-/http-errors-1.6.3.tgz";
        sha1 = "8b55680bb4be283a0b5bf4ea2e38580be1d9320d";
      };
    }
    {
      name = "http_signature___http_signature_1.2.0.tgz";
      path = fetchurl {
        name = "http_signature___http_signature_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/http-signature/-/http-signature-1.2.0.tgz";
        sha1 = "9aecd925114772f3d95b65a60abb8f7c18fbace1";
      };
    }
    {
      name = "humanize_number___humanize_number_0.0.2.tgz";
      path = fetchurl {
        name = "humanize_number___humanize_number_0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/humanize-number/-/humanize-number-0.0.2.tgz";
        sha1 = "11c0af6a471643633588588048f1799541489c18";
      };
    }
    {
      name = "inherits___inherits_2.0.3.tgz";
      path = fetchurl {
        name = "inherits___inherits_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.3.tgz";
        sha1 = "633c2c83e3da42a502f52466022480f4208261de";
      };
    }
    {
      name = "ip___ip_1.1.5.tgz";
      path = fetchurl {
        name = "ip___ip_1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/ip/-/ip-1.1.5.tgz";
        sha1 = "bdded70114290828c0a039e72ef25f5aaec4354a";
      };
    }
    {
      name = "is_generator_function___is_generator_function_1.0.7.tgz";
      path = fetchurl {
        name = "is_generator_function___is_generator_function_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/is-generator-function/-/is-generator-function-1.0.7.tgz";
        sha1 = "d2132e529bb0000a7f80794d4bdf5cd5e5813522";
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
      name = "isarray___isarray_0.0.1.tgz";
      path = fetchurl {
        name = "isarray___isarray_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz";
        sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
      };
    }
    {
      name = "isstream___isstream_0.1.2.tgz";
      path = fetchurl {
        name = "isstream___isstream_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/isstream/-/isstream-0.1.2.tgz";
        sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
      };
    }
    {
      name = "js_yaml___js_yaml_3.13.1.tgz";
      path = fetchurl {
        name = "js_yaml___js_yaml_3.13.1.tgz";
        url  = "https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.13.1.tgz";
        sha1 = "aff151b30bfdfa8e49e05da22e7415e9dfa37847";
      };
    }
    {
      name = "jsbn___jsbn_0.1.1.tgz";
      path = fetchurl {
        name = "jsbn___jsbn_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/jsbn/-/jsbn-0.1.1.tgz";
        sha1 = "a5e654c2e5a2deb5f201d96cefbca80c0ef2f513";
      };
    }
    {
      name = "json_schema_traverse___json_schema_traverse_0.3.1.tgz";
      path = fetchurl {
        name = "json_schema_traverse___json_schema_traverse_0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.3.1.tgz";
        sha1 = "349a6d44c53a51de89b40805c5d5e59b417d3340";
      };
    }
    {
      name = "json_schema___json_schema_0.2.3.tgz";
      path = fetchurl {
        name = "json_schema___json_schema_0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/json-schema/-/json-schema-0.2.3.tgz";
        sha1 = "b480c892e59a2f05954ce727bd3f2a4e882f9e13";
      };
    }
    {
      name = "json_stringify_safe___json_stringify_safe_5.0.1.tgz";
      path = fetchurl {
        name = "json_stringify_safe___json_stringify_safe_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
      };
    }
    {
      name = "jsprim___jsprim_1.4.1.tgz";
      path = fetchurl {
        name = "jsprim___jsprim_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/jsprim/-/jsprim-1.4.1.tgz";
        sha1 = "313e66bc1e5cc06e438bc1b7499c2e5c56acb6a2";
      };
    }
    {
      name = "keygrip___keygrip_1.0.2.tgz";
      path = fetchurl {
        name = "keygrip___keygrip_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/keygrip/-/keygrip-1.0.2.tgz";
        sha1 = "ad3297c557069dea8bcfe7a4fa491b75c5ddeb91";
      };
    }
    {
      name = "koa_compose___koa_compose_3.2.1.tgz";
      path = fetchurl {
        name = "koa_compose___koa_compose_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/koa-compose/-/koa-compose-3.2.1.tgz";
        sha1 = "a85ccb40b7d986d8e5a345b3a1ace8eabcf54de7";
      };
    }
    {
      name = "koa_compose___koa_compose_4.0.0.tgz";
      path = fetchurl {
        name = "koa_compose___koa_compose_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/koa-compose/-/koa-compose-4.0.0.tgz";
        sha1 = "2800a513d9c361ef0d63852b038e4f6f2d5a773c";
      };
    }
    {
      name = "koa_convert___koa_convert_1.2.0.tgz";
      path = fetchurl {
        name = "koa_convert___koa_convert_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/koa-convert/-/koa-convert-1.2.0.tgz";
        sha1 = "da40875df49de0539098d1700b50820cebcd21d0";
      };
    }
    {
      name = "koa_is_json___koa_is_json_1.0.0.tgz";
      path = fetchurl {
        name = "koa_is_json___koa_is_json_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/koa-is-json/-/koa-is-json-1.0.0.tgz";
        sha1 = "273c07edcdcb8df6a2c1ab7d59ee76491451ec14";
      };
    }
    {
      name = "koa_logger___koa_logger_3.2.0.tgz";
      path = fetchurl {
        name = "koa_logger___koa_logger_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/koa-logger/-/koa-logger-3.2.0.tgz";
        sha1 = "8aef64d8b848fb6253a9b31aa708d0e05141f0e6";
      };
    }
    {
      name = "koa_request___koa_request_1.0.0.tgz";
      path = fetchurl {
        name = "koa_request___koa_request_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/koa-request/-/koa-request-1.0.0.tgz";
        sha1 = "19343352479d2cb965d7aff0a802b1a06d408e16";
      };
    }
    {
      name = "koa_router___koa_router_7.4.0.tgz";
      path = fetchurl {
        name = "koa_router___koa_router_7.4.0.tgz";
        url  = "https://registry.yarnpkg.com/koa-router/-/koa-router-7.4.0.tgz";
        sha1 = "aee1f7adc02d5cb31d7d67465c9eacc825e8c5e0";
      };
    }
    {
      name = "koa_send___koa_send_4.1.3.tgz";
      path = fetchurl {
        name = "koa_send___koa_send_4.1.3.tgz";
        url  = "https://registry.yarnpkg.com/koa-send/-/koa-send-4.1.3.tgz";
        sha1 = "0822207bbf5253a414c8f1765ebc29fa41353cb6";
      };
    }
    {
      name = "koa_static___koa_static_4.0.2.tgz";
      path = fetchurl {
        name = "koa_static___koa_static_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/koa-static/-/koa-static-4.0.2.tgz";
        sha1 = "6cda92d88d771dcaad9f0d825cd94a631c861a1a";
      };
    }
    {
      name = "koa___koa_2.5.0.tgz";
      path = fetchurl {
        name = "koa___koa_2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/koa/-/koa-2.5.0.tgz";
        sha1 = "b0fbe1e195e43b27588a04fd0be0ddaeca2c154c";
      };
    }
    {
      name = "lodash___lodash_4.17.19.tgz";
      path = fetchurl {
        name = "lodash___lodash_4.17.19.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.19.tgz";
        sha1 = "e48ddedbe30b3321783c5b4301fbd353bc1e4a4b";
      };
    }
    {
      name = "media_typer___media_typer_0.3.0.tgz";
      path = fetchurl {
        name = "media_typer___media_typer_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/media-typer/-/media-typer-0.3.0.tgz";
        sha1 = "8710d7af0aa626f8fffa1ce00168545263255748";
      };
    }
    {
      name = "methods___methods_1.1.2.tgz";
      path = fetchurl {
        name = "methods___methods_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/methods/-/methods-1.1.2.tgz";
        sha1 = "5529a4d67654134edcc5266656835b0f851afcee";
      };
    }
    {
      name = "mime_db___mime_db_1.33.0.tgz";
      path = fetchurl {
        name = "mime_db___mime_db_1.33.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.33.0.tgz";
        sha1 = "a3492050a5cb9b63450541e39d9788d2272783db";
      };
    }
    {
      name = "mime_types___mime_types_2.1.18.tgz";
      path = fetchurl {
        name = "mime_types___mime_types_2.1.18.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.18.tgz";
        sha1 = "6f323f60a83d11146f831ff11fd66e2fe5503bb8";
      };
    }
    {
      name = "ms___ms_2.0.0.tgz";
      path = fetchurl {
        name = "ms___ms_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz";
        sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
      };
    }
    {
      name = "mz___mz_2.7.0.tgz";
      path = fetchurl {
        name = "mz___mz_2.7.0.tgz";
        url  = "https://registry.yarnpkg.com/mz/-/mz-2.7.0.tgz";
        sha1 = "95008057a56cafadc2bc63dde7f9ff6955948e32";
      };
    }
    {
      name = "negotiator___negotiator_0.6.1.tgz";
      path = fetchurl {
        name = "negotiator___negotiator_0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.1.tgz";
        sha1 = "2b327184e8992101177b28563fb5e7102acd0ca9";
      };
    }
    {
      name = "node_ssdp___node_ssdp_3.3.0.tgz";
      path = fetchurl {
        name = "node_ssdp___node_ssdp_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/node-ssdp/-/node-ssdp-3.3.0.tgz";
        sha1 = "f19b1faec355f08d29b3ed3f9c626dc80354e6bd";
      };
    }
    {
      name = "oauth_sign___oauth_sign_0.8.2.tgz";
      path = fetchurl {
        name = "oauth_sign___oauth_sign_0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/oauth-sign/-/oauth-sign-0.8.2.tgz";
        sha1 = "46a6ab7f0aead8deae9ec0565780b7d4efeb9d43";
      };
    }
    {
      name = "object_assign___object_assign_4.1.1.tgz";
      path = fetchurl {
        name = "object_assign___object_assign_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz";
        sha1 = "2109adc7965887cfc05cbbd442cac8bfbb360863";
      };
    }
    {
      name = "on_finished___on_finished_2.3.0.tgz";
      path = fetchurl {
        name = "on_finished___on_finished_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/on-finished/-/on-finished-2.3.0.tgz";
        sha1 = "20f1336481b083cd75337992a16971aa2d906947";
      };
    }
    {
      name = "only___only_0.0.2.tgz";
      path = fetchurl {
        name = "only___only_0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/only/-/only-0.0.2.tgz";
        sha1 = "2afde84d03e50b9a8edc444e30610a70295edfb4";
      };
    }
    {
      name = "parseurl___parseurl_1.3.2.tgz";
      path = fetchurl {
        name = "parseurl___parseurl_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/parseurl/-/parseurl-1.3.2.tgz";
        sha1 = "fc289d4ed8993119460c156253262cdc8de65bf3";
      };
    }
    {
      name = "passthrough_counter___passthrough_counter_1.0.0.tgz";
      path = fetchurl {
        name = "passthrough_counter___passthrough_counter_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/passthrough-counter/-/passthrough-counter-1.0.0.tgz";
        sha1 = "1967d9e66da572b5c023c787db112a387ab166fa";
      };
    }
    {
      name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
      path = fetchurl {
        name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
      };
    }
    {
      name = "path_to_regexp___path_to_regexp_1.7.0.tgz";
      path = fetchurl {
        name = "path_to_regexp___path_to_regexp_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-1.7.0.tgz";
        sha1 = "59fde0f435badacba103a84e9d3bc64e96b9937d";
      };
    }
    {
      name = "performance_now___performance_now_2.1.0.tgz";
      path = fetchurl {
        name = "performance_now___performance_now_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/performance-now/-/performance-now-2.1.0.tgz";
        sha1 = "6309f4e0e5fa913ec1c69307ae364b4b377c9e7b";
      };
    }
    {
      name = "punycode___punycode_1.4.1.tgz";
      path = fetchurl {
        name = "punycode___punycode_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-1.4.1.tgz";
        sha1 = "c0d5a63b2718800ad8e1eb0fa5269c84dd41845e";
      };
    }
    {
      name = "qs___qs_6.5.1.tgz";
      path = fetchurl {
        name = "qs___qs_6.5.1.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.5.1.tgz";
        sha1 = "349cdf6eef89ec45c12d7d5eb3fc0c870343a6d8";
      };
    }
    {
      name = "request_promise_core___request_promise_core_1.1.1.tgz";
      path = fetchurl {
        name = "request_promise_core___request_promise_core_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/request-promise-core/-/request-promise-core-1.1.1.tgz";
        sha1 = "3eee00b2c5aa83239cfb04c5700da36f81cd08b6";
      };
    }
    {
      name = "request_promise_native___request_promise_native_1.0.5.tgz";
      path = fetchurl {
        name = "request_promise_native___request_promise_native_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/request-promise-native/-/request-promise-native-1.0.5.tgz";
        sha1 = "5281770f68e0c9719e5163fd3fab482215f4fda5";
      };
    }
    {
      name = "request___request_2.85.0.tgz";
      path = fetchurl {
        name = "request___request_2.85.0.tgz";
        url  = "https://registry.yarnpkg.com/request/-/request-2.85.0.tgz";
        sha1 = "5a03615a47c61420b3eb99b7dba204f83603e1fa";
      };
    }
    {
      name = "resolve_path___resolve_path_1.4.0.tgz";
      path = fetchurl {
        name = "resolve_path___resolve_path_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-path/-/resolve-path-1.4.0.tgz";
        sha1 = "c4bda9f5efb2fce65247873ab36bb4d834fe16f7";
      };
    }
    {
      name = "safe_buffer___safe_buffer_5.1.1.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.1.tgz";
        sha1 = "893312af69b2123def71f57889001671eeb2c853";
      };
    }
    {
      name = "setprototypeof___setprototypeof_1.1.0.tgz";
      path = fetchurl {
        name = "setprototypeof___setprototypeof_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.1.0.tgz";
        sha1 = "d0bd85536887b6fe7c0d818cb962d9d91c54e656";
      };
    }
    {
      name = "sntp___sntp_2.1.0.tgz";
      path = fetchurl {
        name = "sntp___sntp_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/sntp/-/sntp-2.1.0.tgz";
        sha1 = "2c6cec14fedc2222739caf9b5c3d85d1cc5a2cc8";
      };
    }
    {
      name = "sprintf_js___sprintf_js_1.0.3.tgz";
      path = fetchurl {
        name = "sprintf_js___sprintf_js_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz";
        sha1 = "04e6926f662895354f3dd015203633b857297e2c";
      };
    }
    {
      name = "sshpk___sshpk_1.14.1.tgz";
      path = fetchurl {
        name = "sshpk___sshpk_1.14.1.tgz";
        url  = "https://registry.yarnpkg.com/sshpk/-/sshpk-1.14.1.tgz";
        sha1 = "130f5975eddad963f1d56f92b9ac6c51fa9f83eb";
      };
    }
    {
      name = "statuses___statuses_1.4.0.tgz";
      path = fetchurl {
        name = "statuses___statuses_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/statuses/-/statuses-1.4.0.tgz";
        sha1 = "bb73d446da2796106efcc1b601a253d6c46bd087";
      };
    }
    {
      name = "stealthy_require___stealthy_require_1.1.1.tgz";
      path = fetchurl {
        name = "stealthy_require___stealthy_require_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/stealthy-require/-/stealthy-require-1.1.1.tgz";
        sha1 = "35b09875b4ff49f26a777e509b3090a3226bf24b";
      };
    }
    {
      name = "stringstream___stringstream_0.0.6.tgz";
      path = fetchurl {
        name = "stringstream___stringstream_0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/stringstream/-/stringstream-0.0.6.tgz";
        sha1 = "7880225b0d4ad10e30927d167a1d6f2fd3b33a72";
      };
    }
    {
      name = "strip_ansi___strip_ansi_3.0.1.tgz";
      path = fetchurl {
        name = "strip_ansi___strip_ansi_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz";
        sha1 = "6a385fb8853d952d5ff05d0e8aaf94278dc63dcf";
      };
    }
    {
      name = "supports_color___supports_color_2.0.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-2.0.0.tgz";
        sha1 = "535d045ce6b6363fa40117084629995e9df324c7";
      };
    }
    {
      name = "thenify_all___thenify_all_1.6.0.tgz";
      path = fetchurl {
        name = "thenify_all___thenify_all_1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/thenify-all/-/thenify-all-1.6.0.tgz";
        sha1 = "1a1918d402d8fc3f98fbf234db0bcc8cc10e9726";
      };
    }
    {
      name = "thenify___thenify_3.3.0.tgz";
      path = fetchurl {
        name = "thenify___thenify_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/thenify/-/thenify-3.3.0.tgz";
        sha1 = "e69e38a1babe969b0108207978b9f62b88604839";
      };
    }
    {
      name = "tough_cookie___tough_cookie_2.3.4.tgz";
      path = fetchurl {
        name = "tough_cookie___tough_cookie_2.3.4.tgz";
        url  = "https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.3.4.tgz";
        sha1 = "ec60cee38ac675063ffc97a5c18970578ee83655";
      };
    }
    {
      name = "tunnel_agent___tunnel_agent_0.6.0.tgz";
      path = fetchurl {
        name = "tunnel_agent___tunnel_agent_0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/tunnel-agent/-/tunnel-agent-0.6.0.tgz";
        sha1 = "27a5dea06b36b04a0a9966774b290868f0fc40fd";
      };
    }
    {
      name = "tweetnacl___tweetnacl_0.14.5.tgz";
      path = fetchurl {
        name = "tweetnacl___tweetnacl_0.14.5.tgz";
        url  = "https://registry.yarnpkg.com/tweetnacl/-/tweetnacl-0.14.5.tgz";
        sha1 = "5ae68177f192d4456269d108afa93ff8743f4f64";
      };
    }
    {
      name = "type_is___type_is_1.6.16.tgz";
      path = fetchurl {
        name = "type_is___type_is_1.6.16.tgz";
        url  = "https://registry.yarnpkg.com/type-is/-/type-is-1.6.16.tgz";
        sha1 = "f89ce341541c672b25ee7ae3c73dee3b2be50194";
      };
    }
    {
      name = "urijs___urijs_1.19.1.tgz";
      path = fetchurl {
        name = "urijs___urijs_1.19.1.tgz";
        url  = "https://registry.yarnpkg.com/urijs/-/urijs-1.19.1.tgz";
        sha1 = "5b0ff530c0cbde8386f6342235ba5ca6e995d25a";
      };
    }
    {
      name = "uuid___uuid_3.2.1.tgz";
      path = fetchurl {
        name = "uuid___uuid_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/uuid/-/uuid-3.2.1.tgz";
        sha1 = "12c528bb9d58d0b9265d9a2f6f0fe8be17ff1f14";
      };
    }
    {
      name = "vary___vary_1.1.2.tgz";
      path = fetchurl {
        name = "vary___vary_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/vary/-/vary-1.1.2.tgz";
        sha1 = "2299f02c6ded30d4a5961b0b9f74524a18f634fc";
      };
    }
    {
      name = "verror___verror_1.10.0.tgz";
      path = fetchurl {
        name = "verror___verror_1.10.0.tgz";
        url  = "https://registry.yarnpkg.com/verror/-/verror-1.10.0.tgz";
        sha1 = "3a105ca17053af55d6e270c1f8288682e18da400";
      };
    }
  ];
}
