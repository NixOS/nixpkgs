{ fetchurl, fetchgit, linkFarm, runCommandNoCC, gnutar }: rec {
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
      name = "after___after_0.8.2.tgz";
      path = fetchurl {
        name = "after___after_0.8.2.tgz";
        url  = "https://registry.yarnpkg.com/after/-/after-0.8.2.tgz";
        sha1 = "fedb394f9f0e02aa9768e702bda23b505fae7e1f";
      };
    }
    {
      name = "arraybuffer.slice___arraybuffer.slice_0.0.7.tgz";
      path = fetchurl {
        name = "arraybuffer.slice___arraybuffer.slice_0.0.7.tgz";
        url  = "https://registry.yarnpkg.com/arraybuffer.slice/-/arraybuffer.slice-0.0.7.tgz";
        sha1 = "3bbc4275dd584cc1b10809b89d4e8b63a69e7675";
      };
    }
    {
      name = "async_limiter___async_limiter_1.0.0.tgz";
      path = fetchurl {
        name = "async_limiter___async_limiter_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/async-limiter/-/async-limiter-1.0.0.tgz";
        sha1 = "78faed8c3d074ab81f22b4e985d79e8738f720f8";
      };
    }
    {
      name = "async___async_1.0.0.tgz";
      path = fetchurl {
        name = "async___async_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-1.0.0.tgz";
        sha1 = "f8fc04ca3a13784ade9e1641af98578cfbd647a9";
      };
    }
    {
      name = "backo2___backo2_1.0.2.tgz";
      path = fetchurl {
        name = "backo2___backo2_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/backo2/-/backo2-1.0.2.tgz";
        sha1 = "31ab1ac8b129363463e35b3ebb69f4dfcfba7947";
      };
    }
    {
      name = "base64_arraybuffer___base64_arraybuffer_0.1.5.tgz";
      path = fetchurl {
        name = "base64_arraybuffer___base64_arraybuffer_0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/base64-arraybuffer/-/base64-arraybuffer-0.1.5.tgz";
        sha1 = "73926771923b5a19747ad666aa5cd4bf9c6e9ce8";
      };
    }
    {
      name = "base64id___base64id_1.0.0.tgz";
      path = fetchurl {
        name = "base64id___base64id_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/base64id/-/base64id-1.0.0.tgz";
        sha1 = "47688cb99bb6804f0e06d3e763b1c32e57d8e6b6";
      };
    }
    {
      name = "better_assert___better_assert_1.0.2.tgz";
      path = fetchurl {
        name = "better_assert___better_assert_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/better-assert/-/better-assert-1.0.2.tgz";
        sha1 = "40866b9e1b9e0b55b481894311e68faffaebc522";
      };
    }
    {
      name = "blob___blob_0.0.5.tgz";
      path = fetchurl {
        name = "blob___blob_0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/blob/-/blob-0.0.5.tgz";
        sha1 = "d680eeef25f8cd91ad533f5b01eed48e64caf683";
      };
    }
    {
      name = "callsite___callsite_1.0.0.tgz";
      path = fetchurl {
        name = "callsite___callsite_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/callsite/-/callsite-1.0.0.tgz";
        sha1 = "280398e5d664bd74038b6f0905153e6e8af1bc20";
      };
    }
    {
      name = "circular_json___circular_json_0.5.9.tgz";
      path = fetchurl {
        name = "circular_json___circular_json_0.5.9.tgz";
        url  = "https://registry.yarnpkg.com/circular-json/-/circular-json-0.5.9.tgz";
        sha1 = "932763ae88f4f7dead7a0d09c8a51a4743a53b1d";
      };
    }
    {
      name = "colors___colors_1.0.3.tgz";
      path = fetchurl {
        name = "colors___colors_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/colors/-/colors-1.0.3.tgz";
        sha1 = "0433f44d809680fdeb60ed260f1b0c262e82a40b";
      };
    }
    {
      name = "component_bind___component_bind_1.0.0.tgz";
      path = fetchurl {
        name = "component_bind___component_bind_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/component-bind/-/component-bind-1.0.0.tgz";
        sha1 = "00c608ab7dcd93897c0009651b1d3a8e1e73bbd1";
      };
    }
    {
      name = "component_emitter___component_emitter_1.2.1.tgz";
      path = fetchurl {
        name = "component_emitter___component_emitter_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.2.1.tgz";
        sha1 = "137918d6d78283f7df7a6b7c5a63e140e69425e6";
      };
    }
    {
      name = "component_inherit___component_inherit_0.0.3.tgz";
      path = fetchurl {
        name = "component_inherit___component_inherit_0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/component-inherit/-/component-inherit-0.0.3.tgz";
        sha1 = "645fc4adf58b72b649d5cae65135619db26ff143";
      };
    }
    {
      name = "cookie___cookie_0.3.1.tgz";
      path = fetchurl {
        name = "cookie___cookie_0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/cookie/-/cookie-0.3.1.tgz";
        sha1 = "e7e0a1f9ef43b4c8ba925c5c5a96e806d16873bb";
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
      name = "cycle___cycle_1.0.3.tgz";
      path = fetchurl {
        name = "cycle___cycle_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/cycle/-/cycle-1.0.3.tgz";
        sha1 = "21e80b2be8580f98b468f379430662b046c34ad2";
      };
    }
    {
      name = "date_format___date_format_1.2.0.tgz";
      path = fetchurl {
        name = "date_format___date_format_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/date-format/-/date-format-1.2.0.tgz";
        sha1 = "615e828e233dd1ab9bb9ae0950e0ceccfa6ecad8";
      };
    }
    {
      name = "debug___debug_3.2.6.tgz";
      path = fetchurl {
        name = "debug___debug_3.2.6.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-3.2.6.tgz";
        sha1 = "e83d17de16d8a7efb7717edbe5fb10135eee629b";
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
      name = "engine.io_client___engine.io_client_3.2.1.tgz";
      path = fetchurl {
        name = "engine.io_client___engine.io_client_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/engine.io-client/-/engine.io-client-3.2.1.tgz";
        sha1 = "6f54c0475de487158a1a7c77d10178708b6add36";
      };
    }
    {
      name = "engine.io_parser___engine.io_parser_2.1.3.tgz";
      path = fetchurl {
        name = "engine.io_parser___engine.io_parser_2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/engine.io-parser/-/engine.io-parser-2.1.3.tgz";
        sha1 = "757ab970fbf2dfb32c7b74b033216d5739ef79a6";
      };
    }
    {
      name = "engine.io___engine.io_3.2.1.tgz";
      path = fetchurl {
        name = "engine.io___engine.io_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/engine.io/-/engine.io-3.2.1.tgz";
        sha1 = "b60281c35484a70ee0351ea0ebff83ec8c9522a2";
      };
    }
    {
      name = "event_lite___event_lite_0.1.2.tgz";
      path = fetchurl {
        name = "event_lite___event_lite_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/event-lite/-/event-lite-0.1.2.tgz";
        sha1 = "838a3e0fdddef8cc90f128006c8e55a4e4e4c11b";
      };
    }
    {
      name = "eyes___eyes_0.1.8.tgz";
      path = fetchurl {
        name = "eyes___eyes_0.1.8.tgz";
        url  = "https://registry.yarnpkg.com/eyes/-/eyes-0.1.8.tgz";
        sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
      };
    }
    {
      name = "has_binary2___has_binary2_1.0.3.tgz";
      path = fetchurl {
        name = "has_binary2___has_binary2_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/has-binary2/-/has-binary2-1.0.3.tgz";
        sha1 = "7776ac627f3ea77250cfc332dab7ddf5e4f5d11d";
      };
    }
    {
      name = "has_cors___has_cors_1.1.0.tgz";
      path = fetchurl {
        name = "has_cors___has_cors_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/has-cors/-/has-cors-1.1.0.tgz";
        sha1 = "5e474793f7ea9843d1bb99c23eef49ff126fff39";
      };
    }
    {
      name = "ieee754___ieee754_1.1.12.tgz";
      path = fetchurl {
        name = "ieee754___ieee754_1.1.12.tgz";
        url  = "https://registry.yarnpkg.com/ieee754/-/ieee754-1.1.12.tgz";
        sha1 = "50bf24e5b9c8bb98af4964c941cdb0918da7b60b";
      };
    }
    {
      name = "indexof___indexof_0.0.1.tgz";
      path = fetchurl {
        name = "indexof___indexof_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/indexof/-/indexof-0.0.1.tgz";
        sha1 = "82dc336d232b9062179d05ab3293a66059fd435d";
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
      name = "int64_buffer___int64_buffer_0.1.10.tgz";
      path = fetchurl {
        name = "int64_buffer___int64_buffer_0.1.10.tgz";
        url  = "https://registry.yarnpkg.com/int64-buffer/-/int64-buffer-0.1.10.tgz";
        sha1 = "277b228a87d95ad777d07c13832022406a473423";
      };
    }
    {
      name = "isarray___isarray_2.0.1.tgz";
      path = fetchurl {
        name = "isarray___isarray_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-2.0.1.tgz";
        sha1 = "a37d94ed9cda2d59865c9f76fe596ee1f338741e";
      };
    }
    {
      name = "isarray___isarray_1.0.0.tgz";
      path = fetchurl {
        name = "isarray___isarray_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz";
        sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
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
      name = "lodash___lodash_4.17.19.tgz";
      path = fetchurl {
        name = "lodash___lodash_4.17.19.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.19.tgz";
        sha1 = "e48ddedbe30b3321783c5b4301fbd353bc1e4a4b";
      };
    }
    {
      name = "log4js___log4js_3.0.6.tgz";
      path = fetchurl {
        name = "log4js___log4js_3.0.6.tgz";
        url  = "https://registry.yarnpkg.com/log4js/-/log4js-3.0.6.tgz";
        sha1 = "e6caced94967eeeb9ce399f9f8682a4b2b28c8ff";
      };
    }
    {
      name = "mime_db___mime_db_1.37.0.tgz";
      path = fetchurl {
        name = "mime_db___mime_db_1.37.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.37.0.tgz";
        sha1 = "0b6a0ce6fdbe9576e25f1f2d2fde8830dc0ad0d8";
      };
    }
    {
      name = "mime_types___mime_types_2.1.21.tgz";
      path = fetchurl {
        name = "mime_types___mime_types_2.1.21.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.21.tgz";
        sha1 = "28995aa1ecb770742fe6ae7e58f9181c744b3f96";
      };
    }
    {
      name = "minimist___minimist_0.0.8.tgz";
      path = fetchurl {
        name = "minimist___minimist_0.0.8.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      };
    }
    {
      name = "mkdirp___mkdirp_0.5.1.tgz";
      path = fetchurl {
        name = "mkdirp___mkdirp_0.5.1.tgz";
        url  = "https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.1.tgz";
        sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
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
      name = "ms___ms_2.1.1.tgz";
      path = fetchurl {
        name = "ms___ms_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.1.1.tgz";
        sha1 = "30a5864eb3ebb0a66f2ebe6d727af06a09d86e0a";
      };
    }
    {
      name = "msgpack_lite___msgpack_lite_0.1.26.tgz";
      path = fetchurl {
        name = "msgpack_lite___msgpack_lite_0.1.26.tgz";
        url  = "https://registry.yarnpkg.com/msgpack-lite/-/msgpack-lite-0.1.26.tgz";
        sha1 = "dd3c50b26f059f25e7edee3644418358e2a9ad89";
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
      name = "neovim___neovim_4.2.1.tgz";
      path = fetchurl {
        name = "neovim___neovim_4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/neovim/-/neovim-4.2.1.tgz";
        sha1 = "25e99703831fafd9e26190feec15366bebfda8c0";
      };
    }
    {
      name = "object_component___object_component_0.0.3.tgz";
      path = fetchurl {
        name = "object_component___object_component_0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/object-component/-/object-component-0.0.3.tgz";
        sha1 = "f0c69aa50efc95b866c186f400a33769cb2f1291";
      };
    }
    {
      name = "parseqs___parseqs_0.0.5.tgz";
      path = fetchurl {
        name = "parseqs___parseqs_0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/parseqs/-/parseqs-0.0.5.tgz";
        sha1 = "d5208a3738e46766e291ba2ea173684921a8b89d";
      };
    }
    {
      name = "parseuri___parseuri_0.0.5.tgz";
      path = fetchurl {
        name = "parseuri___parseuri_0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/parseuri/-/parseuri-0.0.5.tgz";
        sha1 = "80204a50d4dbb779bfdc6ebe2778d90e4bce320a";
      };
    }
    {
      name = "process_nextick_args___process_nextick_args_2.0.0.tgz";
      path = fetchurl {
        name = "process_nextick_args___process_nextick_args_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.0.tgz";
        sha1 = "a37d732f4271b4ab1ad070d35508e8290788ffaa";
      };
    }
    {
      name = "readable_stream___readable_stream_2.3.6.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_2.3.6.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.6.tgz";
        sha1 = "b11c27d88b8ff1fbe070643cf94b0c79ae1b0aaf";
      };
    }
    {
      name = "rfdc___rfdc_1.1.2.tgz";
      path = fetchurl {
        name = "rfdc___rfdc_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/rfdc/-/rfdc-1.1.2.tgz";
        sha1 = "e6e72d74f5dc39de8f538f65e00c36c18018e349";
      };
    }
    {
      name = "safe_buffer___safe_buffer_5.1.2.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz";
        sha1 = "991ec69d296e0313747d59bdfd2b745c35f8828d";
      };
    }
    {
      name = "socket.io_adapter___socket.io_adapter_1.1.1.tgz";
      path = fetchurl {
        name = "socket.io_adapter___socket.io_adapter_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-adapter/-/socket.io-adapter-1.1.1.tgz";
        sha1 = "2a805e8a14d6372124dd9159ad4502f8cb07f06b";
      };
    }
    {
      name = "socket.io_client___socket.io_client_2.1.1.tgz";
      path = fetchurl {
        name = "socket.io_client___socket.io_client_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-client/-/socket.io-client-2.1.1.tgz";
        sha1 = "dcb38103436ab4578ddb026638ae2f21b623671f";
      };
    }
    {
      name = "socket.io_parser___socket.io_parser_3.2.0.tgz";
      path = fetchurl {
        name = "socket.io_parser___socket.io_parser_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-parser/-/socket.io-parser-3.2.0.tgz";
        sha1 = "e7c6228b6aa1f814e6148aea325b51aa9499e077";
      };
    }
    {
      name = "socket.io___socket.io_2.1.1.tgz";
      path = fetchurl {
        name = "socket.io___socket.io_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/socket.io/-/socket.io-2.1.1.tgz";
        sha1 = "a069c5feabee3e6b214a75b40ce0652e1cfb9980";
      };
    }
    {
      name = "stack_trace___stack_trace_0.0.10.tgz";
      path = fetchurl {
        name = "stack_trace___stack_trace_0.0.10.tgz";
        url  = "https://registry.yarnpkg.com/stack-trace/-/stack-trace-0.0.10.tgz";
        sha1 = "547c70b347e8d32b4e108ea1a2a159e5fdde19c0";
      };
    }
    {
      name = "streamroller___streamroller_0.7.0.tgz";
      path = fetchurl {
        name = "streamroller___streamroller_0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/streamroller/-/streamroller-0.7.0.tgz";
        sha1 = "a1d1b7cf83d39afb0d63049a5acbf93493bdf64b";
      };
    }
    {
      name = "string_decoder___string_decoder_1.1.1.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz";
        sha1 = "9cf1611ba62685d7030ae9e4ba34149c3af03fc8";
      };
    }
    {
      name = "to_array___to_array_0.1.4.tgz";
      path = fetchurl {
        name = "to_array___to_array_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/to-array/-/to-array-0.1.4.tgz";
        sha1 = "17e6c11f73dd4f3d74cda7a4ff3238e9ad9bf890";
      };
    }
    {
      name = "traverse___traverse_0.6.6.tgz";
      path = fetchurl {
        name = "traverse___traverse_0.6.6.tgz";
        url  = "https://registry.yarnpkg.com/traverse/-/traverse-0.6.6.tgz";
        sha1 = "cbdf560fd7b9af632502fed40f918c157ea97137";
      };
    }
    {
      name = "tslib___tslib_1.9.3.tgz";
      path = fetchurl {
        name = "tslib___tslib_1.9.3.tgz";
        url  = "https://registry.yarnpkg.com/tslib/-/tslib-1.9.3.tgz";
        sha1 = "d7e4dd79245d85428c4d7e4822a79917954ca286";
      };
    }
    {
      name = "ultron___ultron_1.1.1.tgz";
      path = fetchurl {
        name = "ultron___ultron_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/ultron/-/ultron-1.1.1.tgz";
        sha1 = "9fe1536a10a664a65266a1e3ccf85fd36302bc9c";
      };
    }
    {
      name = "util_deprecate___util_deprecate_1.0.2.tgz";
      path = fetchurl {
        name = "util_deprecate___util_deprecate_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
    }
    {
      name = "uuid___uuid_3.3.2.tgz";
      path = fetchurl {
        name = "uuid___uuid_3.3.2.tgz";
        url  = "https://registry.yarnpkg.com/uuid/-/uuid-3.3.2.tgz";
        sha1 = "1b4af4955eb3077c501c23872fc6513811587131";
      };
    }
    {
      name = "vim_node_rpc___vim_node_rpc_0.1.24.tgz";
      path = fetchurl {
        name = "vim_node_rpc___vim_node_rpc_0.1.24.tgz";
        url  = "https://registry.yarnpkg.com/vim-node-rpc/-/vim-node-rpc-0.1.24.tgz";
        sha1 = "38caba5659a1945fd4a31301ff5caef3c08a1f38";
      };
    }
    {
      name = "winston___winston_2.4.4.tgz";
      path = fetchurl {
        name = "winston___winston_2.4.4.tgz";
        url  = "https://registry.yarnpkg.com/winston/-/winston-2.4.4.tgz";
        sha1 = "a01e4d1d0a103cf4eada6fc1f886b3110d71c34b";
      };
    }
    {
      name = "ws___ws_3.3.3.tgz";
      path = fetchurl {
        name = "ws___ws_3.3.3.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-3.3.3.tgz";
        sha1 = "f1cf84fe2d5e901ebce94efaece785f187a228f2";
      };
    }
    {
      name = "xmlhttprequest_ssl___xmlhttprequest_ssl_1.5.5.tgz";
      path = fetchurl {
        name = "xmlhttprequest_ssl___xmlhttprequest_ssl_1.5.5.tgz";
        url  = "https://registry.yarnpkg.com/xmlhttprequest-ssl/-/xmlhttprequest-ssl-1.5.5.tgz";
        sha1 = "c2876b06168aadc40e57d97e81191ac8f4398b3e";
      };
    }
    {
      name = "yeast___yeast_0.1.2.tgz";
      path = fetchurl {
        name = "yeast___yeast_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/yeast/-/yeast-0.1.2.tgz";
        sha1 = "008e06d8094320c372dbc2f8ed76a0ca6c8ac419";
      };
    }
  ];
}
