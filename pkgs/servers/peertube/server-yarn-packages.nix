{fetchurl, linkFarm}: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [

    {
      name = "_babel_code_frame___code_frame_7.5.5.tgz";
      path = fetchurl {
        name = "_babel_code_frame___code_frame_7.5.5.tgz";
        url  = "https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.5.5.tgz";
        sha1 = "bc0782f6d69f7b7d49531219699b988f669a8f9d";
      };
    }

    {
      name = "_babel_highlight___highlight_7.5.0.tgz";
      path = fetchurl {
        name = "_babel_highlight___highlight_7.5.0.tgz";
        url  = "https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.5.0.tgz";
        sha1 = "56d11312bd9248fa619591d02472be6e8cb32540";
      };
    }

    {
      name = "_nodelib_fs.scandir___fs.scandir_2.1.3.tgz";
      path = fetchurl {
        name = "_nodelib_fs.scandir___fs.scandir_2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/@nodelib/fs.scandir/-/fs.scandir-2.1.3.tgz";
        sha1 = "3a582bdb53804c6ba6d146579c46e52130cf4a3b";
      };
    }

    {
      name = "_nodelib_fs.stat___fs.stat_2.0.3.tgz";
      path = fetchurl {
        name = "_nodelib_fs.stat___fs.stat_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.3.tgz";
        sha1 = "34dc5f4cabbc720f4e60f75a747e7ecd6c175bd3";
      };
    }

    {
      name = "_nodelib_fs.walk___fs.walk_1.2.4.tgz";
      path = fetchurl {
        name = "_nodelib_fs.walk___fs.walk_1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/@nodelib/fs.walk/-/fs.walk-1.2.4.tgz";
        sha1 = "011b9202a70a6366e436ca5c065844528ab04976";
      };
    }

    {
      name = "_samverschueren_stream_to_observable___stream_to_observable_0.3.0.tgz";
      path = fetchurl {
        name = "_samverschueren_stream_to_observable___stream_to_observable_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/@samverschueren/stream-to-observable/-/stream-to-observable-0.3.0.tgz";
        sha1 = "ecdf48d532c58ea477acfcab80348424f8d0662f";
      };
    }

    {
      name = "_types_apicache___apicache_1.2.2.tgz";
      path = fetchurl {
        name = "_types_apicache___apicache_1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/apicache/-/apicache-1.2.2.tgz";
        sha1 = "b820659b1d95e66ec0e71dcd0317e9d30f0c154b";
      };
    }

    {
      name = "_types_async_lock___async_lock_1.1.1.tgz";
      path = fetchurl {
        name = "_types_async_lock___async_lock_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/async-lock/-/async-lock-1.1.1.tgz";
        sha1 = "81f218213bebcc5f740efe9648272c774a2e4b4b";
      };
    }

    {
      name = "_types_async___async_3.0.3.tgz";
      path = fetchurl {
        name = "_types_async___async_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/async/-/async-3.0.3.tgz";
        sha1 = "ea3694128c757580e4f9328cd941b81d9c3e9bf6";
      };
    }

    {
      name = "_types_bcrypt___bcrypt_3.0.0.tgz";
      path = fetchurl {
        name = "_types_bcrypt___bcrypt_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/bcrypt/-/bcrypt-3.0.0.tgz";
        sha1 = "851489a9065a067cb7f3c9cbe4ce9bed8bba0876";
      };
    }

    {
      name = "_types_bittorrent_protocol___bittorrent_protocol_2.2.4.tgz";
      path = fetchurl {
        name = "_types_bittorrent_protocol___bittorrent_protocol_2.2.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/bittorrent-protocol/-/bittorrent-protocol-2.2.4.tgz";
        sha1 = "7dc0716924bc6a904753d39846ad235c7dab4641";
      };
    }

    {
      name = "_types_bluebird___bluebird_3.5.27.tgz";
      path = fetchurl {
        name = "_types_bluebird___bluebird_3.5.27.tgz";
        url  = "https://registry.yarnpkg.com/@types/bluebird/-/bluebird-3.5.27.tgz";
        sha1 = "61eb4d75dc6bfbce51cf49ee9bbebe941b2cb5d0";
      };
    }

    {
      name = "_types_bluebird___bluebird_3.5.21.tgz";
      path = fetchurl {
        name = "_types_bluebird___bluebird_3.5.21.tgz";
        url  = "https://registry.yarnpkg.com/@types/bluebird/-/bluebird-3.5.21.tgz";
        sha1 = "567615589cc913e84a28ecf9edb031732bdf2634";
      };
    }

    {
      name = "_types_body_parser___body_parser_1.17.1.tgz";
      path = fetchurl {
        name = "_types_body_parser___body_parser_1.17.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/body-parser/-/body-parser-1.17.1.tgz";
        sha1 = "18fcf61768fb5c30ccc508c21d6fd2e8b3bf7897";
      };
    }

    {
      name = "_types_bull___bull_3.4.0.tgz";
      path = fetchurl {
        name = "_types_bull___bull_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/bull/-/bull-3.4.0.tgz";
        sha1 = "18ffefefa4dd1cfbdbdc8ca7df56c934459f6b9d";
      };
    }

    {
      name = "_types_bytes___bytes_3.1.0.tgz";
      path = fetchurl {
        name = "_types_bytes___bytes_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/bytes/-/bytes-3.1.0.tgz";
        sha1 = "835a3e4aea3b4d7604aca216a78de372bff3ecc3";
      };
    }

    {
      name = "_types_caseless___caseless_0.12.2.tgz";
      path = fetchurl {
        name = "_types_caseless___caseless_0.12.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/caseless/-/caseless-0.12.2.tgz";
        sha1 = "f65d3d6389e01eeb458bd54dc8f52b95a9463bc8";
      };
    }

    {
      name = "_types_chai_json_schema___chai_json_schema_1.4.5.tgz";
      path = fetchurl {
        name = "_types_chai_json_schema___chai_json_schema_1.4.5.tgz";
        url  = "https://registry.yarnpkg.com/@types/chai-json-schema/-/chai-json-schema-1.4.5.tgz";
        sha1 = "fa1b11e10a87f0a189cfcfb8bd08a7f1e50a6d90";
      };
    }

    {
      name = "_types_chai_xml___chai_xml_0.3.2.tgz";
      path = fetchurl {
        name = "_types_chai_xml___chai_xml_0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/chai-xml/-/chai-xml-0.3.2.tgz";
        sha1 = "fbd4fe4041ab62ce59aa12ca2346cfd91b372169";
      };
    }

    {
      name = "_types_chai___chai_4.2.7.tgz";
      path = fetchurl {
        name = "_types_chai___chai_4.2.7.tgz";
        url  = "https://registry.yarnpkg.com/@types/chai/-/chai-4.2.7.tgz";
        sha1 = "1c8c25cbf6e59ffa7d6b9652c78e547d9a41692d";
      };
    }

    {
      name = "_types_color_name___color_name_1.1.1.tgz";
      path = fetchurl {
        name = "_types_color_name___color_name_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/color-name/-/color-name-1.1.1.tgz";
        sha1 = "1c1261bbeaa10a8055bbc5d8ab84b7b2afc846a0";
      };
    }

    {
      name = "_types_config___config_0.0.36.tgz";
      path = fetchurl {
        name = "_types_config___config_0.0.36.tgz";
        url  = "https://registry.yarnpkg.com/@types/config/-/config-0.0.36.tgz";
        sha1 = "bf53ca640f3a1a6a2072a9f33e02a44def07a40b";
      };
    }

    {
      name = "_types_connect___connect_3.4.33.tgz";
      path = fetchurl {
        name = "_types_connect___connect_3.4.33.tgz";
        url  = "https://registry.yarnpkg.com/@types/connect/-/connect-3.4.33.tgz";
        sha1 = "31610c901eca573b8713c3330abc6e6b9f588546";
      };
    }

    {
      name = "_types_cookiejar___cookiejar_2.1.1.tgz";
      path = fetchurl {
        name = "_types_cookiejar___cookiejar_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/cookiejar/-/cookiejar-2.1.1.tgz";
        sha1 = "90b68446364baf9efd8e8349bb36bd3852b75b80";
      };
    }

    {
      name = "_types_events___events_3.0.0.tgz";
      path = fetchurl {
        name = "_types_events___events_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/events/-/events-3.0.0.tgz";
        sha1 = "2862f3f58a9a7f7c3e78d79f130dd4d71c25c2a7";
      };
    }

    {
      name = "_types_express_rate_limit___express_rate_limit_3.3.3.tgz";
      path = fetchurl {
        name = "_types_express_rate_limit___express_rate_limit_3.3.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/express-rate-limit/-/express-rate-limit-3.3.3.tgz";
        sha1 = "1be5c551be1615d243e3eec14dca091009c61113";
      };
    }

    {
      name = "_types_express_serve_static_core___express_serve_static_core_4.17.1.tgz";
      path = fetchurl {
        name = "_types_express_serve_static_core___express_serve_static_core_4.17.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/express-serve-static-core/-/express-serve-static-core-4.17.1.tgz";
        sha1 = "82be64a77211b205641e0209096fd3afb62481d3";
      };
    }

    {
      name = "_types_express___express_4.17.2.tgz";
      path = fetchurl {
        name = "_types_express___express_4.17.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/express/-/express-4.17.2.tgz";
        sha1 = "a0fb7a23d8855bac31bc01d5a58cadd9b2173e6c";
      };
    }

    {
      name = "_types_fluent_ffmpeg___fluent_ffmpeg_2.1.13.tgz";
      path = fetchurl {
        name = "_types_fluent_ffmpeg___fluent_ffmpeg_2.1.13.tgz";
        url  = "https://registry.yarnpkg.com/@types/fluent-ffmpeg/-/fluent-ffmpeg-2.1.13.tgz";
        sha1 = "bfffbcf298b0980924e9ba9aa471aba234626afb";
      };
    }

    {
      name = "_types_fs_extra___fs_extra_8.0.1.tgz";
      path = fetchurl {
        name = "_types_fs_extra___fs_extra_8.0.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-8.0.1.tgz";
        sha1 = "a2378d6e7e8afea1564e44aafa2e207dadf77686";
      };
    }

    {
      name = "_types_glob___glob_7.1.1.tgz";
      path = fetchurl {
        name = "_types_glob___glob_7.1.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/glob/-/glob-7.1.1.tgz";
        sha1 = "aa59a1c6e3fbc421e07ccd31a944c30eba521575";
      };
    }

    {
      name = "_types_ioredis___ioredis_4.14.3.tgz";
      path = fetchurl {
        name = "_types_ioredis___ioredis_4.14.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/ioredis/-/ioredis-4.14.3.tgz";
        sha1 = "6a6089296d6fb90bbaee96d36b19d480efff026a";
      };
    }

    {
      name = "_types_json5___json5_0.0.29.tgz";
      path = fetchurl {
        name = "_types_json5___json5_0.0.29.tgz";
        url  = "https://registry.yarnpkg.com/@types/json5/-/json5-0.0.29.tgz";
        sha1 = "ee28707ae94e11d2b827bcbe5270bcea7f3e71ee";
      };
    }

    {
      name = "_types_libxmljs___libxmljs_0.18.5.tgz";
      path = fetchurl {
        name = "_types_libxmljs___libxmljs_0.18.5.tgz";
        url  = "https://registry.yarnpkg.com/@types/libxmljs/-/libxmljs-0.18.5.tgz";
        sha1 = "3fc132f2d9752de209126d57d553d04684b3d13e";
      };
    }

    {
      name = "_types_lodash___lodash_4.14.149.tgz";
      path = fetchurl {
        name = "_types_lodash___lodash_4.14.149.tgz";
        url  = "https://registry.yarnpkg.com/@types/lodash/-/lodash-4.14.149.tgz";
        sha1 = "1342d63d948c6062838fbf961012f74d4e638440";
      };
    }

    {
      name = "_types_lru_cache___lru_cache_5.1.0.tgz";
      path = fetchurl {
        name = "_types_lru_cache___lru_cache_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/lru-cache/-/lru-cache-5.1.0.tgz";
        sha1 = "57f228f2b80c046b4a1bd5cac031f81f207f4f03";
      };
    }

    {
      name = "_types_magnet_uri___magnet_uri_5.1.2.tgz";
      path = fetchurl {
        name = "_types_magnet_uri___magnet_uri_5.1.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/magnet-uri/-/magnet-uri-5.1.2.tgz";
        sha1 = "7860417399d52ddc0be1021d570b4ac93ffc133e";
      };
    }

    {
      name = "_types_maildev___maildev_0.0.1.tgz";
      path = fetchurl {
        name = "_types_maildev___maildev_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/maildev/-/maildev-0.0.1.tgz";
        sha1 = "9fe4fa05610f6c6afc10224bcca6b67bc3c56fc0";
      };
    }

    {
      name = "_types_memoizee___memoizee_0.4.3.tgz";
      path = fetchurl {
        name = "_types_memoizee___memoizee_0.4.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/memoizee/-/memoizee-0.4.3.tgz";
        sha1 = "f48270d19327c1709620132cf54d598650f98492";
      };
    }

    {
      name = "_types_mime___mime_2.0.1.tgz";
      path = fetchurl {
        name = "_types_mime___mime_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/mime/-/mime-2.0.1.tgz";
        sha1 = "dc488842312a7f075149312905b5e3c0b054c79d";
      };
    }

    {
      name = "_types_minimatch___minimatch_3.0.3.tgz";
      path = fetchurl {
        name = "_types_minimatch___minimatch_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/minimatch/-/minimatch-3.0.3.tgz";
        sha1 = "3dca0e3f33b200fc7d1139c0cd96c1268cadfd9d";
      };
    }

    {
      name = "_types_mkdirp___mkdirp_0.5.2.tgz";
      path = fetchurl {
        name = "_types_mkdirp___mkdirp_0.5.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/mkdirp/-/mkdirp-0.5.2.tgz";
        sha1 = "503aacfe5cc2703d5484326b1b27efa67a339c1f";
      };
    }

    {
      name = "_types_mocha___mocha_5.2.7.tgz";
      path = fetchurl {
        name = "_types_mocha___mocha_5.2.7.tgz";
        url  = "https://registry.yarnpkg.com/@types/mocha/-/mocha-5.2.7.tgz";
        sha1 = "315d570ccb56c53452ff8638738df60726d5b6ea";
      };
    }

    {
      name = "_types_morgan___morgan_1.7.37.tgz";
      path = fetchurl {
        name = "_types_morgan___morgan_1.7.37.tgz";
        url  = "https://registry.yarnpkg.com/@types/morgan/-/morgan-1.7.37.tgz";
        sha1 = "ebdd0b0f0276073f85283bf4f03c7c54284874df";
      };
    }

    {
      name = "_types_multer___multer_1.3.10.tgz";
      path = fetchurl {
        name = "_types_multer___multer_1.3.10.tgz";
        url  = "https://registry.yarnpkg.com/@types/multer/-/multer-1.3.10.tgz";
        sha1 = "d7afbd916f688fceb4460320e62a8ad1ab3e3cad";
      };
    }

    {
      name = "_types_node___node_13.1.4.tgz";
      path = fetchurl {
        name = "_types_node___node_13.1.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-13.1.4.tgz";
        sha1 = "4cfd90175a200ee9b02bd6b1cd19bc349741607e";
      };
    }

    {
      name = "_types_node___node_10.17.13.tgz";
      path = fetchurl {
        name = "_types_node___node_10.17.13.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-10.17.13.tgz";
        sha1 = "ccebcdb990bd6139cd16e84c39dc2fb1023ca90c";
      };
    }

    {
      name = "_types_node___node_12.12.24.tgz";
      path = fetchurl {
        name = "_types_node___node_12.12.24.tgz";
        url  = "https://registry.yarnpkg.com/@types/node/-/node-12.12.24.tgz";
        sha1 = "d4606afd8cf6c609036b854360367d1b2c78931f";
      };
    }

    {
      name = "_types_nodemailer___nodemailer_6.4.0.tgz";
      path = fetchurl {
        name = "_types_nodemailer___nodemailer_6.4.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/nodemailer/-/nodemailer-6.4.0.tgz";
        sha1 = "d8c039be3ed685c4719a026455555be82c124b74";
      };
    }

    {
      name = "_types_oauth2_server___oauth2_server_3.0.12.tgz";
      path = fetchurl {
        name = "_types_oauth2_server___oauth2_server_3.0.12.tgz";
        url  = "https://registry.yarnpkg.com/@types/oauth2-server/-/oauth2-server-3.0.12.tgz";
        sha1 = "3c404055c2c88068a3ee8f5e5a0c5a12bca8c365";
      };
    }

    {
      name = "_types_parse_torrent_file___parse_torrent_file_4.0.2.tgz";
      path = fetchurl {
        name = "_types_parse_torrent_file___parse_torrent_file_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/@types/parse-torrent-file/-/parse-torrent-file-4.0.2.tgz";
        sha1 = "40c96fc075aec256514807c6c381d11d9035bd9e";
      };
    }

    {
      name = "_types_parse_torrent___parse_torrent_5.8.3.tgz";
      path = fetchurl {
        name = "_types_parse_torrent___parse_torrent_5.8.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/parse-torrent/-/parse-torrent-5.8.3.tgz";
        sha1 = "ff4e987d09ad27ccc1c8893b3a2c6a31a3bc4042";
      };
    }

    {
      name = "_types_pem___pem_1.9.5.tgz";
      path = fetchurl {
        name = "_types_pem___pem_1.9.5.tgz";
        url  = "https://registry.yarnpkg.com/@types/pem/-/pem-1.9.5.tgz";
        sha1 = "cd5548b5e0acb4b41a9e21067e9fcd8c57089c99";
      };
    }

    {
      name = "_types_range_parser___range_parser_1.2.3.tgz";
      path = fetchurl {
        name = "_types_range_parser___range_parser_1.2.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/range-parser/-/range-parser-1.2.3.tgz";
        sha1 = "7ee330ba7caafb98090bece86a5ee44115904c2c";
      };
    }

    {
      name = "_types_redis___redis_2.8.14.tgz";
      path = fetchurl {
        name = "_types_redis___redis_2.8.14.tgz";
        url  = "https://registry.yarnpkg.com/@types/redis/-/redis-2.8.14.tgz";
        sha1 = "2ed46d0f923f7ccd63fbe73a46a1241e606cf716";
      };
    }

    {
      name = "_types_request___request_2.48.4.tgz";
      path = fetchurl {
        name = "_types_request___request_2.48.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/request/-/request-2.48.4.tgz";
        sha1 = "df3d43d7b9ed3550feaa1286c6eabf0738e6cf7e";
      };
    }

    {
      name = "_types_sax___sax_1.2.0.tgz";
      path = fetchurl {
        name = "_types_sax___sax_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/sax/-/sax-1.2.0.tgz";
        sha1 = "6025e0b7fc7cd5f3d83808a6809730bac798565d";
      };
    }

    {
      name = "_types_serve_static___serve_static_1.13.3.tgz";
      path = fetchurl {
        name = "_types_serve_static___serve_static_1.13.3.tgz";
        url  = "https://registry.yarnpkg.com/@types/serve-static/-/serve-static-1.13.3.tgz";
        sha1 = "eb7e1c41c4468272557e897e9171ded5e2ded9d1";
      };
    }

    {
      name = "_types_sharp___sharp_0.23.1.tgz";
      path = fetchurl {
        name = "_types_sharp___sharp_0.23.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/sharp/-/sharp-0.23.1.tgz";
        sha1 = "1e02560371d6603adc121389512f0745028aa507";
      };
    }

    {
      name = "_types_simple_peer___simple_peer_9.6.0.tgz";
      path = fetchurl {
        name = "_types_simple_peer___simple_peer_9.6.0.tgz";
        url  = "https://registry.yarnpkg.com/@types/simple-peer/-/simple-peer-9.6.0.tgz";
        sha1 = "b5828d835b7f42dde27db584ba127e7a9f9072f4";
      };
    }

    {
      name = "_types_socket.io___socket.io_2.1.4.tgz";
      path = fetchurl {
        name = "_types_socket.io___socket.io_2.1.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/socket.io/-/socket.io-2.1.4.tgz";
        sha1 = "674e7bc193c5ccdadd4433f79f3660d31759e9ac";
      };
    }

    {
      name = "_types_superagent___superagent_4.1.4.tgz";
      path = fetchurl {
        name = "_types_superagent___superagent_4.1.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/superagent/-/superagent-4.1.4.tgz";
        sha1 = "63f74955a28073870cfd9c100bcacb26d72b3764";
      };
    }

    {
      name = "_types_supertest___supertest_2.0.8.tgz";
      path = fetchurl {
        name = "_types_supertest___supertest_2.0.8.tgz";
        url  = "https://registry.yarnpkg.com/@types/supertest/-/supertest-2.0.8.tgz";
        sha1 = "23801236e2b85204ed771a8e7c40febba7da2bda";
      };
    }

    {
      name = "_types_tough_cookie___tough_cookie_2.3.6.tgz";
      path = fetchurl {
        name = "_types_tough_cookie___tough_cookie_2.3.6.tgz";
        url  = "https://registry.yarnpkg.com/@types/tough-cookie/-/tough-cookie-2.3.6.tgz";
        sha1 = "c880579e087d7a0db13777ff8af689f4ffc7b0d5";
      };
    }

    {
      name = "_types_tv4___tv4_1.2.29.tgz";
      path = fetchurl {
        name = "_types_tv4___tv4_1.2.29.tgz";
        url  = "https://registry.yarnpkg.com/@types/tv4/-/tv4-1.2.29.tgz";
        sha1 = "4c6d2222b03245dd2104f4fd67f54d1658985911";
      };
    }

    {
      name = "_types_validator___validator_12.0.1.tgz";
      path = fetchurl {
        name = "_types_validator___validator_12.0.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/validator/-/validator-12.0.1.tgz";
        sha1 = "73dbc7f5f730ff7131754bca682824eb3c260b79";
      };
    }

    {
      name = "_types_webtorrent___webtorrent_0.107.1.tgz";
      path = fetchurl {
        name = "_types_webtorrent___webtorrent_0.107.1.tgz";
        url  = "https://registry.yarnpkg.com/@types/webtorrent/-/webtorrent-0.107.1.tgz";
        sha1 = "1aeec48b6386b162e1a210c188fadca75f2fa0bd";
      };
    }

    {
      name = "_types_ws___ws_6.0.4.tgz";
      path = fetchurl {
        name = "_types_ws___ws_6.0.4.tgz";
        url  = "https://registry.yarnpkg.com/@types/ws/-/ws-6.0.4.tgz";
        sha1 = "7797707c8acce8f76d8c34b370d4645b70421ff1";
      };
    }

    {
      name = "abbrev___abbrev_1.1.1.tgz";
      path = fetchurl {
        name = "abbrev___abbrev_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz";
        sha1 = "f8f2c887ad10bf67f634f005b6987fed3179aac8";
      };
    }

    {
      name = "accepts___accepts_1.3.7.tgz";
      path = fetchurl {
        name = "accepts___accepts_1.3.7.tgz";
        url  = "https://registry.yarnpkg.com/accepts/-/accepts-1.3.7.tgz";
        sha1 = "531bc726517a3b2b41f850021c6cc15eaab507cd";
      };
    }

    {
      name = "addr_to_ip_port___addr_to_ip_port_1.5.1.tgz";
      path = fetchurl {
        name = "addr_to_ip_port___addr_to_ip_port_1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/addr-to-ip-port/-/addr-to-ip-port-1.5.1.tgz";
        sha1 = "bfada13fd6aeeeac19f1e9f7d84b4bbab45e5208";
      };
    }

    {
      name = "addressparser___addressparser_1.0.1.tgz";
      path = fetchurl {
        name = "addressparser___addressparser_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/addressparser/-/addressparser-1.0.1.tgz";
        sha1 = "47afbe1a2a9262191db6838e4fd1d39b40821746";
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
      name = "aggregate_error___aggregate_error_3.0.1.tgz";
      path = fetchurl {
        name = "aggregate_error___aggregate_error_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.0.1.tgz";
        sha1 = "db2fe7246e536f40d9b5442a39e117d7dd6a24e0";
      };
    }

    {
      name = "ajv___ajv_6.10.2.tgz";
      path = fetchurl {
        name = "ajv___ajv_6.10.2.tgz";
        url  = "https://registry.yarnpkg.com/ajv/-/ajv-6.10.2.tgz";
        sha1 = "d3cea04d6b017b2894ad69040fec8b623eb4bd52";
      };
    }

    {
      name = "ansi_align___ansi_align_2.0.0.tgz";
      path = fetchurl {
        name = "ansi_align___ansi_align_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-align/-/ansi-align-2.0.0.tgz";
        sha1 = "c36aeccba563b89ceb556f3690f0b1d9e3547f7f";
      };
    }

    {
      name = "ansi_colors___ansi_colors_3.2.3.tgz";
      path = fetchurl {
        name = "ansi_colors___ansi_colors_3.2.3.tgz";
        url  = "https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-3.2.3.tgz";
        sha1 = "57d35b8686e851e2cc04c403f1c00203976a1813";
      };
    }

    {
      name = "ansi_escapes___ansi_escapes_3.2.0.tgz";
      path = fetchurl {
        name = "ansi_escapes___ansi_escapes_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-3.2.0.tgz";
        sha1 = "8780b98ff9dbf5638152d1f1fe5c1d7b4442976b";
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
      name = "ansi_regex___ansi_regex_3.0.0.tgz";
      path = fetchurl {
        name = "ansi_regex___ansi_regex_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-3.0.0.tgz";
        sha1 = "ed0317c322064f79466c02966bddb605ab37d998";
      };
    }

    {
      name = "ansi_regex___ansi_regex_4.1.0.tgz";
      path = fetchurl {
        name = "ansi_regex___ansi_regex_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-4.1.0.tgz";
        sha1 = "8b9f8f08cf1acb843756a839ca8c7e3168c51997";
      };
    }

    {
      name = "ansi_regex___ansi_regex_5.0.0.tgz";
      path = fetchurl {
        name = "ansi_regex___ansi_regex_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.0.tgz";
        sha1 = "388539f55179bf39339c81af30a654d69f87cb75";
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
      name = "ansi_styles___ansi_styles_3.2.1.tgz";
      path = fetchurl {
        name = "ansi_styles___ansi_styles_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz";
        sha1 = "41fbb20243e50b12be0f04b8dedbf07520ce841d";
      };
    }

    {
      name = "ansi_styles___ansi_styles_4.2.1.tgz";
      path = fetchurl {
        name = "ansi_styles___ansi_styles_4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.2.1.tgz";
        sha1 = "90ae75c424d008d2624c5bf29ead3177ebfcf359";
      };
    }

    {
      name = "any_observable___any_observable_0.3.0.tgz";
      path = fetchurl {
        name = "any_observable___any_observable_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/any-observable/-/any-observable-0.3.0.tgz";
        sha1 = "af933475e5806a67d0d7df090dd5e8bef65d119b";
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
      name = "anymatch___anymatch_3.1.1.tgz";
      path = fetchurl {
        name = "anymatch___anymatch_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.1.tgz";
        sha1 = "c55ecf02185e2469259399310c173ce31233b142";
      };
    }

    {
      name = "apicache___apicache_1.5.2.tgz";
      path = fetchurl {
        name = "apicache___apicache_1.5.2.tgz";
        url  = "https://registry.yarnpkg.com/apicache/-/apicache-1.5.2.tgz";
        sha1 = "2cb0697d9b1b612b505b1a44face66d48b1d1404";
      };
    }

    {
      name = "append_field___append_field_1.0.0.tgz";
      path = fetchurl {
        name = "append_field___append_field_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/append-field/-/append-field-1.0.0.tgz";
        sha1 = "1e3440e915f0b1203d23748e78edd7b9b5b43e56";
      };
    }

    {
      name = "aproba___aproba_1.2.0.tgz";
      path = fetchurl {
        name = "aproba___aproba_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/aproba/-/aproba-1.2.0.tgz";
        sha1 = "6802e6264efd18c790a1b0d517f0f2627bf2c94a";
      };
    }

    {
      name = "are_we_there_yet___are_we_there_yet_1.1.5.tgz";
      path = fetchurl {
        name = "are_we_there_yet___are_we_there_yet_1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-1.1.5.tgz";
        sha1 = "4b35c2944f062a8bfcda66410760350fe9ddfc21";
      };
    }

    {
      name = "arg___arg_4.1.2.tgz";
      path = fetchurl {
        name = "arg___arg_4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/arg/-/arg-4.1.2.tgz";
        sha1 = "e70c90579e02c63d80e3ad4e31d8bfdb8bd50064";
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
      name = "array_flatten___array_flatten_1.1.1.tgz";
      path = fetchurl {
        name = "array_flatten___array_flatten_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/array-flatten/-/array-flatten-1.1.1.tgz";
        sha1 = "9a5f699051b1e7073328f2a008968b64ea2955d2";
      };
    }

    {
      name = "array_union___array_union_2.1.0.tgz";
      path = fetchurl {
        name = "array_union___array_union_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/array-union/-/array-union-2.1.0.tgz";
        sha1 = "b798420adbeb1de828d84acd8a2e23d3efe85e8d";
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
      name = "asn1___asn1_0.2.3.tgz";
      path = fetchurl {
        name = "asn1___asn1_0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/asn1/-/asn1-0.2.3.tgz";
        sha1 = "dac8787713c9966849fc8180777ebe9c1ddf3b86";
      };
    }

    {
      name = "asn1___asn1_0.2.4.tgz";
      path = fetchurl {
        name = "asn1___asn1_0.2.4.tgz";
        url  = "https://registry.yarnpkg.com/asn1/-/asn1-0.2.4.tgz";
        sha1 = "8d2475dfab553bb33e77b54e59e880bb8ce23136";
      };
    }

    {
      name = "assert_plus___assert_plus_0.1.5.tgz";
      path = fetchurl {
        name = "assert_plus___assert_plus_0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/assert-plus/-/assert-plus-0.1.5.tgz";
        sha1 = "ee74009413002d84cec7219c6ac811812e723160";
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
      name = "assertion_error___assertion_error_1.0.0.tgz";
      path = fetchurl {
        name = "assertion_error___assertion_error_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/assertion-error/-/assertion-error-1.0.0.tgz";
        sha1 = "c7f85438fdd466bc7ca16ab90c81513797a5d23b";
      };
    }

    {
      name = "assertion_error___assertion_error_1.1.0.tgz";
      path = fetchurl {
        name = "assertion_error___assertion_error_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/assertion-error/-/assertion-error-1.1.0.tgz";
        sha1 = "e60b6b0e8f301bd97e5375215bda406c85118c0b";
      };
    }

    {
      name = "async_limiter___async_limiter_1.0.1.tgz";
      path = fetchurl {
        name = "async_limiter___async_limiter_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/async-limiter/-/async-limiter-1.0.1.tgz";
        sha1 = "dd379e94f0db8310b08291f9d64c3209766617fd";
      };
    }

    {
      name = "async_lru___async_lru_1.1.2.tgz";
      path = fetchurl {
        name = "async_lru___async_lru_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/async-lru/-/async-lru-1.1.2.tgz";
        sha1 = "abe831f3a52123c87d44273615e203b1ef04692e";
      };
    }

    {
      name = "async___async_3.1.0.tgz";
      path = fetchurl {
        name = "async___async_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-3.1.0.tgz";
        sha1 = "42b3b12ae1b74927b5217d8c0016baaf62463772";
      };
    }

    {
      name = "async___async_2.6.3.tgz";
      path = fetchurl {
        name = "async___async_2.6.3.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-2.6.3.tgz";
        sha1 = "d72625e2344a3656e3a3ad4fa749fa83299d82ff";
      };
    }

    {
      name = "async___async_0.9.2.tgz";
      path = fetchurl {
        name = "async___async_0.9.2.tgz";
        url  = "https://registry.yarnpkg.com/async/-/async-0.9.2.tgz";
        sha1 = "aea74d5e61c1f899613bf64bda66d4c78f2fd17d";
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
      name = "aws4___aws4_1.9.0.tgz";
      path = fetchurl {
        name = "aws4___aws4_1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/aws4/-/aws4-1.9.0.tgz";
        sha1 = "24390e6ad61386b0a747265754d2a17219de862c";
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
      name = "backoff___backoff_2.5.0.tgz";
      path = fetchurl {
        name = "backoff___backoff_2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/backoff/-/backoff-2.5.0.tgz";
        sha1 = "f616eda9d3e4b66b8ca7fca79f695722c5f8e26f";
      };
    }

    {
      name = "balanced_match___balanced_match_1.0.0.tgz";
      path = fetchurl {
        name = "balanced_match___balanced_match_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.0.tgz";
        sha1 = "89b4d199ab2bee49de164ea02b89ce462d71b767";
      };
    }

    {
      name = "base32.js___base32.js_0.1.0.tgz";
      path = fetchurl {
        name = "base32.js___base32.js_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/base32.js/-/base32.js-0.1.0.tgz";
        sha1 = "b582dec693c2f11e893cf064ee6ac5b6131a2202";
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
      name = "base64id___base64id_2.0.0.tgz";
      path = fetchurl {
        name = "base64id___base64id_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/base64id/-/base64id-2.0.0.tgz";
        sha1 = "2770ac6bc47d312af97a8bf9a634342e0cd25cb6";
      };
    }

    {
      name = "basic_auth___basic_auth_1.1.0.tgz";
      path = fetchurl {
        name = "basic_auth___basic_auth_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/basic-auth/-/basic-auth-1.1.0.tgz";
        sha1 = "45221ee429f7ee1e5035be3f51533f1cdfd29884";
      };
    }

    {
      name = "basic_auth___basic_auth_2.0.1.tgz";
      path = fetchurl {
        name = "basic_auth___basic_auth_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/basic-auth/-/basic-auth-2.0.1.tgz";
        sha1 = "b998279bf47ce38344b4f3cf916d4679bbf51e3a";
      };
    }

    {
      name = "bcrypt_pbkdf___bcrypt_pbkdf_1.0.2.tgz";
      path = fetchurl {
        name = "bcrypt_pbkdf___bcrypt_pbkdf_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz";
        sha1 = "a4301d389b6a43f9b67ff3ca11a3f6637e360e9e";
      };
    }

    {
      name = "bcrypt___bcrypt_3.0.7.tgz";
      path = fetchurl {
        name = "bcrypt___bcrypt_3.0.7.tgz";
        url  = "https://registry.yarnpkg.com/bcrypt/-/bcrypt-3.0.7.tgz";
        sha1 = "1187d29df2e1cde44268152b13e3d4a655a7c7de";
      };
    }

    {
      name = "bencode___bencode_2.0.1.tgz";
      path = fetchurl {
        name = "bencode___bencode_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/bencode/-/bencode-2.0.1.tgz";
        sha1 = "667a6a31c5e038d558608333da6b7c94e836c85b";
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
      name = "binary_extensions___binary_extensions_2.0.0.tgz";
      path = fetchurl {
        name = "binary_extensions___binary_extensions_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.0.0.tgz";
        sha1 = "23c0df14f6a88077f5f986c0d167ec03c3d5537c";
      };
    }

    {
      name = "binary_search___binary_search_1.3.6.tgz";
      path = fetchurl {
        name = "binary_search___binary_search_1.3.6.tgz";
        url  = "https://registry.yarnpkg.com/binary-search/-/binary-search-1.3.6.tgz";
        sha1 = "e32426016a0c5092f0f3598836a1c7da3560565c";
      };
    }

    {
      name = "bindings___bindings_1.3.1.tgz";
      path = fetchurl {
        name = "bindings___bindings_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/bindings/-/bindings-1.3.1.tgz";
        sha1 = "21fc7c6d67c18516ec5aaa2815b145ff77b26ea5";
      };
    }

    {
      name = "bitfield___bitfield_3.0.0.tgz";
      path = fetchurl {
        name = "bitfield___bitfield_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/bitfield/-/bitfield-3.0.0.tgz";
        sha1 = "b2d32c707866d42f016ae9bd8469999a9f51b59c";
      };
    }

    {
      name = "bittorrent_dht___bittorrent_dht_9.0.3.tgz";
      path = fetchurl {
        name = "bittorrent_dht___bittorrent_dht_9.0.3.tgz";
        url  = "https://registry.yarnpkg.com/bittorrent-dht/-/bittorrent-dht-9.0.3.tgz";
        sha1 = "bdcac9383bdc5e2a459eef6418332f3ae182d63f";
      };
    }

    {
      name = "bittorrent_peerid___bittorrent_peerid_1.3.2.tgz";
      path = fetchurl {
        name = "bittorrent_peerid___bittorrent_peerid_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/bittorrent-peerid/-/bittorrent-peerid-1.3.2.tgz";
        sha1 = "aca9ff812ec099c882079bec60b5558a3adb56fa";
      };
    }

    {
      name = "bittorrent_protocol___bittorrent_protocol_3.1.1.tgz";
      path = fetchurl {
        name = "bittorrent_protocol___bittorrent_protocol_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/bittorrent-protocol/-/bittorrent-protocol-3.1.1.tgz";
        sha1 = "2d5a615a5de471bf22934a2bf3f423ad760b8932";
      };
    }

    {
      name = "bittorrent_tracker___bittorrent_tracker_9.14.4.tgz";
      path = fetchurl {
        name = "bittorrent_tracker___bittorrent_tracker_9.14.4.tgz";
        url  = "https://registry.yarnpkg.com/bittorrent-tracker/-/bittorrent-tracker-9.14.4.tgz";
        sha1 = "0d9661560e6fec37689dfc5045142772eac05536";
      };
    }

    {
      name = "bl___bl_3.0.0.tgz";
      path = fetchurl {
        name = "bl___bl_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/bl/-/bl-3.0.0.tgz";
        sha1 = "3611ec00579fd18561754360b21e9f784500ff88";
      };
    }

    {
      name = "blob_to_buffer___blob_to_buffer_1.2.8.tgz";
      path = fetchurl {
        name = "blob_to_buffer___blob_to_buffer_1.2.8.tgz";
        url  = "https://registry.yarnpkg.com/blob-to-buffer/-/blob-to-buffer-1.2.8.tgz";
        sha1 = "78eeeb332f1280ed0ca6fb2b60693a8c6d36903a";
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
      name = "block_stream2___block_stream2_2.0.0.tgz";
      path = fetchurl {
        name = "block_stream2___block_stream2_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/block-stream2/-/block-stream2-2.0.0.tgz";
        sha1 = "680b9d357ca8b9d5637f4ec8a41fb5968029108f";
      };
    }

    {
      name = "bluebird___bluebird_3.5.0.tgz";
      path = fetchurl {
        name = "bluebird___bluebird_3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/bluebird/-/bluebird-3.5.0.tgz";
        sha1 = "791420d7f551eea2897453a8a77653f96606d67c";
      };
    }

    {
      name = "bluebird___bluebird_2.11.0.tgz";
      path = fetchurl {
        name = "bluebird___bluebird_2.11.0.tgz";
        url  = "https://registry.yarnpkg.com/bluebird/-/bluebird-2.11.0.tgz";
        sha1 = "534b9033c022c9579c56ba3b3e5a5caafbb650e1";
      };
    }

    {
      name = "bluebird___bluebird_3.7.2.tgz";
      path = fetchurl {
        name = "bluebird___bluebird_3.7.2.tgz";
        url  = "https://registry.yarnpkg.com/bluebird/-/bluebird-3.7.2.tgz";
        sha1 = "9f229c15be272454ffa973ace0dbee79a1b0c36f";
      };
    }

    {
      name = "bn.js___bn.js_5.1.1.tgz";
      path = fetchurl {
        name = "bn.js___bn.js_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/bn.js/-/bn.js-5.1.1.tgz";
        sha1 = "48efc4031a9c4041b9c99c6941d903463ab62eb5";
      };
    }

    {
      name = "body_parser___body_parser_1.19.0.tgz";
      path = fetchurl {
        name = "body_parser___body_parser_1.19.0.tgz";
        url  = "https://registry.yarnpkg.com/body-parser/-/body-parser-1.19.0.tgz";
        sha1 = "96b2709e57c9c4e09a6fd66a8fd979844f69f08a";
      };
    }

    {
      name = "bowser___bowser_2.8.1.tgz";
      path = fetchurl {
        name = "bowser___bowser_2.8.1.tgz";
        url  = "https://registry.yarnpkg.com/bowser/-/bowser-2.8.1.tgz";
        sha1 = "35b74165e17b80ba8af6aa4736c2861b001fc09e";
      };
    }

    {
      name = "boxen___boxen_1.3.0.tgz";
      path = fetchurl {
        name = "boxen___boxen_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/boxen/-/boxen-1.3.0.tgz";
        sha1 = "55c6c39a8ba58d9c61ad22cd877532deb665a20b";
      };
    }

    {
      name = "brace_expansion___brace_expansion_1.1.11.tgz";
      path = fetchurl {
        name = "brace_expansion___brace_expansion_1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz";
        sha1 = "3c7fcbf529d87226f3d2f52b966ff5271eb441dd";
      };
    }

    {
      name = "braces___braces_3.0.2.tgz";
      path = fetchurl {
        name = "braces___braces_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz";
        sha1 = "3454e1a462ee8d599e236df336cd9ea4f8afe107";
      };
    }

    {
      name = "browser_stdout___browser_stdout_1.3.1.tgz";
      path = fetchurl {
        name = "browser_stdout___browser_stdout_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/browser-stdout/-/browser-stdout-1.3.1.tgz";
        sha1 = "baa559ee14ced73452229bad7326467c61fabd60";
      };
    }

    {
      name = "browserify_package_json___browserify_package_json_1.0.1.tgz";
      path = fetchurl {
        name = "browserify_package_json___browserify_package_json_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/browserify-package-json/-/browserify-package-json-1.0.1.tgz";
        sha1 = "98dde8aa5c561fd6d3fe49bbaa102b74b396fdea";
      };
    }

    {
      name = "buffer_alloc_unsafe___buffer_alloc_unsafe_1.1.0.tgz";
      path = fetchurl {
        name = "buffer_alloc_unsafe___buffer_alloc_unsafe_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz";
        sha1 = "bd7dc26ae2972d0eda253be061dba992349c19f0";
      };
    }

    {
      name = "buffer_alloc___buffer_alloc_1.2.0.tgz";
      path = fetchurl {
        name = "buffer_alloc___buffer_alloc_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-alloc/-/buffer-alloc-1.2.0.tgz";
        sha1 = "890dd90d923a873e08e10e5fd51a57e5b7cce0ec";
      };
    }

    {
      name = "buffer_fill___buffer_fill_1.0.0.tgz";
      path = fetchurl {
        name = "buffer_fill___buffer_fill_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-fill/-/buffer-fill-1.0.0.tgz";
        sha1 = "f8f78b76789888ef39f205cd637f68e702122b2c";
      };
    }

    {
      name = "buffer_from___buffer_from_1.1.1.tgz";
      path = fetchurl {
        name = "buffer_from___buffer_from_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.1.tgz";
        sha1 = "32713bc028f75c02fdb710d7c7bcec1f2c6070ef";
      };
    }

    {
      name = "buffer_writer___buffer_writer_2.0.0.tgz";
      path = fetchurl {
        name = "buffer_writer___buffer_writer_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/buffer-writer/-/buffer-writer-2.0.0.tgz";
        sha1 = "ce7eb81a38f7829db09c873f2fbb792c0c98ec04";
      };
    }

    {
      name = "bufferutil___bufferutil_4.0.1.tgz";
      path = fetchurl {
        name = "bufferutil___bufferutil_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/bufferutil/-/bufferutil-4.0.1.tgz";
        sha1 = "3a177e8e5819a1243fe16b63a199951a7ad8d4a7";
      };
    }

    {
      name = "builtin_modules___builtin_modules_1.1.1.tgz";
      path = fetchurl {
        name = "builtin_modules___builtin_modules_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/builtin-modules/-/builtin-modules-1.1.1.tgz";
        sha1 = "270f076c5a72c02f5b65a47df94c5fe3a278892f";
      };
    }

    {
      name = "bull___bull_3.12.1.tgz";
      path = fetchurl {
        name = "bull___bull_3.12.1.tgz";
        url  = "https://registry.yarnpkg.com/bull/-/bull-3.12.1.tgz";
        sha1 = "ced62d0afca81c9264b44f1b6f39243df5d2e73f";
      };
    }

    {
      name = "bunyan___bunyan_1.8.12.tgz";
      path = fetchurl {
        name = "bunyan___bunyan_1.8.12.tgz";
        url  = "https://registry.yarnpkg.com/bunyan/-/bunyan-1.8.12.tgz";
        sha1 = "f150f0f6748abdd72aeae84f04403be2ef113797";
      };
    }

    {
      name = "busboy___busboy_0.2.14.tgz";
      path = fetchurl {
        name = "busboy___busboy_0.2.14.tgz";
        url  = "https://registry.yarnpkg.com/busboy/-/busboy-0.2.14.tgz";
        sha1 = "6c2a622efcf47c57bbbe1e2a9c37ad36c7925453";
      };
    }

    {
      name = "bytes___bytes_3.1.0.tgz";
      path = fetchurl {
        name = "bytes___bytes_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/bytes/-/bytes-3.1.0.tgz";
        sha1 = "f6cf7933a360e0588fa9fde85651cdc7f805d1f6";
      };
    }

    {
      name = "call_me_maybe___call_me_maybe_1.0.1.tgz";
      path = fetchurl {
        name = "call_me_maybe___call_me_maybe_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/call-me-maybe/-/call-me-maybe-1.0.1.tgz";
        sha1 = "26d208ea89e37b5cbde60250a15f031c16a4d66b";
      };
    }

    {
      name = "caller_callsite___caller_callsite_2.0.0.tgz";
      path = fetchurl {
        name = "caller_callsite___caller_callsite_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/caller-callsite/-/caller-callsite-2.0.0.tgz";
        sha1 = "847e0fce0a223750a9a027c54b33731ad3154134";
      };
    }

    {
      name = "caller_path___caller_path_2.0.0.tgz";
      path = fetchurl {
        name = "caller_path___caller_path_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/caller-path/-/caller-path-2.0.0.tgz";
        sha1 = "468f83044e369ab2010fac5f06ceee15bb2cb1f4";
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
      name = "callsites___callsites_2.0.0.tgz";
      path = fetchurl {
        name = "callsites___callsites_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/callsites/-/callsites-2.0.0.tgz";
        sha1 = "06eb84f00eea413da86affefacbffb36093b3c50";
      };
    }

    {
      name = "camelcase___camelcase_4.1.0.tgz";
      path = fetchurl {
        name = "camelcase___camelcase_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-4.1.0.tgz";
        sha1 = "d545635be1e33c542649c69173e5de6acfae34dd";
      };
    }

    {
      name = "camelcase___camelcase_5.3.1.tgz";
      path = fetchurl {
        name = "camelcase___camelcase_5.3.1.tgz";
        url  = "https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz";
        sha1 = "e3c9b31569e106811df242f715725a1f4c494320";
      };
    }

    {
      name = "camelize___camelize_1.0.0.tgz";
      path = fetchurl {
        name = "camelize___camelize_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/camelize/-/camelize-1.0.0.tgz";
        sha1 = "164a5483e630fa4321e5af07020e531831b2609b";
      };
    }

    {
      name = "canonicalize___canonicalize_1.0.1.tgz";
      path = fetchurl {
        name = "canonicalize___canonicalize_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/canonicalize/-/canonicalize-1.0.1.tgz";
        sha1 = "657b4f3fa38a6ecb97a9e5b7b26d7a19cc6e0da9";
      };
    }

    {
      name = "capture_stack_trace___capture_stack_trace_1.0.1.tgz";
      path = fetchurl {
        name = "capture_stack_trace___capture_stack_trace_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/capture-stack-trace/-/capture-stack-trace-1.0.1.tgz";
        sha1 = "a6c0bbe1f38f3aa0b92238ecb6ff42c344d4135d";
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
      name = "chai_json_schema___chai_json_schema_1.5.1.tgz";
      path = fetchurl {
        name = "chai_json_schema___chai_json_schema_1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/chai-json-schema/-/chai-json-schema-1.5.1.tgz";
        sha1 = "d9ae4c8f8c6e24ff4d402ceddfaa865d1ca107f4";
      };
    }

    {
      name = "chai_xml___chai_xml_0.3.2.tgz";
      path = fetchurl {
        name = "chai_xml___chai_xml_0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/chai-xml/-/chai-xml-0.3.2.tgz";
        sha1 = "61d0776aa8fd936a2178769adcaabf3bfb52b8b1";
      };
    }

    {
      name = "chai___chai_1.10.0.tgz";
      path = fetchurl {
        name = "chai___chai_1.10.0.tgz";
        url  = "https://registry.yarnpkg.com/chai/-/chai-1.10.0.tgz";
        sha1 = "e4031cc87654461a75943e5a35ab46eaf39c1eb9";
      };
    }

    {
      name = "chai___chai_4.2.0.tgz";
      path = fetchurl {
        name = "chai___chai_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/chai/-/chai-4.2.0.tgz";
        sha1 = "760aa72cf20e3795e84b12877ce0e83737aa29e5";
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
      name = "chalk___chalk_2.4.2.tgz";
      path = fetchurl {
        name = "chalk___chalk_2.4.2.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz";
        sha1 = "cd42541677a54333cf541a49108c1432b44c9424";
      };
    }

    {
      name = "chalk___chalk_3.0.0.tgz";
      path = fetchurl {
        name = "chalk___chalk_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/chalk/-/chalk-3.0.0.tgz";
        sha1 = "3f73c2bf526591f574cc492c51e2456349f844e4";
      };
    }

    {
      name = "charenc___charenc_0.0.2.tgz";
      path = fetchurl {
        name = "charenc___charenc_0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/charenc/-/charenc-0.0.2.tgz";
        sha1 = "c0a1d2f3a7092e03774bfa83f14c0fc5790a8667";
      };
    }

    {
      name = "charset_detector___charset_detector_0.0.2.tgz";
      path = fetchurl {
        name = "charset_detector___charset_detector_0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/charset-detector/-/charset-detector-0.0.2.tgz";
        sha1 = "1cd5ddaf56e83259c6ef8e906ccf06f75fe9a1b2";
      };
    }

    {
      name = "check_error___check_error_1.0.2.tgz";
      path = fetchurl {
        name = "check_error___check_error_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/check-error/-/check-error-1.0.2.tgz";
        sha1 = "574d312edd88bb5dd8912e9286dd6c0aed4aac82";
      };
    }

    {
      name = "chokidar___chokidar_3.3.0.tgz";
      path = fetchurl {
        name = "chokidar___chokidar_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/chokidar/-/chokidar-3.3.0.tgz";
        sha1 = "12c0714668c55800f659e262d4962a97faf554a6";
      };
    }

    {
      name = "chokidar___chokidar_3.3.1.tgz";
      path = fetchurl {
        name = "chokidar___chokidar_3.3.1.tgz";
        url  = "https://registry.yarnpkg.com/chokidar/-/chokidar-3.3.1.tgz";
        sha1 = "c84e5b3d18d9a4d77558fef466b1bf16bbeb3450";
      };
    }

    {
      name = "chownr___chownr_1.1.3.tgz";
      path = fetchurl {
        name = "chownr___chownr_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/chownr/-/chownr-1.1.3.tgz";
        sha1 = "42d837d5239688d55f303003a508230fa6727142";
      };
    }

    {
      name = "chrome_dgram___chrome_dgram_3.0.4.tgz";
      path = fetchurl {
        name = "chrome_dgram___chrome_dgram_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/chrome-dgram/-/chrome-dgram-3.0.4.tgz";
        sha1 = "aa785f23d1fc71c8619e8af166db7b9dc21a4f3e";
      };
    }

    {
      name = "chrome_dns___chrome_dns_1.0.1.tgz";
      path = fetchurl {
        name = "chrome_dns___chrome_dns_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/chrome-dns/-/chrome-dns-1.0.1.tgz";
        sha1 = "6870af680a40d2c4b2efc2154a378793f5a4ce4b";
      };
    }

    {
      name = "chrome_net___chrome_net_3.3.3.tgz";
      path = fetchurl {
        name = "chrome_net___chrome_net_3.3.3.tgz";
        url  = "https://registry.yarnpkg.com/chrome-net/-/chrome-net-3.3.3.tgz";
        sha1 = "09b40337d97fa857ac44ee9a2d82a66e43863401";
      };
    }

    {
      name = "chunk_store_stream___chunk_store_stream_4.1.0.tgz";
      path = fetchurl {
        name = "chunk_store_stream___chunk_store_stream_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/chunk-store-stream/-/chunk-store-stream-4.1.0.tgz";
        sha1 = "5e135cfb0c77a02657a27783c985b328ad09ae29";
      };
    }

    {
      name = "ci_info___ci_info_1.6.0.tgz";
      path = fetchurl {
        name = "ci_info___ci_info_1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/ci-info/-/ci-info-1.6.0.tgz";
        sha1 = "2ca20dbb9ceb32d4524a683303313f0304b1e497";
      };
    }

    {
      name = "cidr_regex___cidr_regex_2.0.10.tgz";
      path = fetchurl {
        name = "cidr_regex___cidr_regex_2.0.10.tgz";
        url  = "https://registry.yarnpkg.com/cidr-regex/-/cidr-regex-2.0.10.tgz";
        sha1 = "af13878bd4ad704de77d6dc800799358b3afa70d";
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
      name = "clean_stack___clean_stack_2.2.0.tgz";
      path = fetchurl {
        name = "clean_stack___clean_stack_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz";
        sha1 = "ee8472dbb129e727b31e8a10a427dee9dfe4008b";
      };
    }

    {
      name = "cli_boxes___cli_boxes_1.0.0.tgz";
      path = fetchurl {
        name = "cli_boxes___cli_boxes_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/cli-boxes/-/cli-boxes-1.0.0.tgz";
        sha1 = "4fa917c3e59c94a004cd61f8ee509da651687143";
      };
    }

    {
      name = "cli_cursor___cli_cursor_2.1.0.tgz";
      path = fetchurl {
        name = "cli_cursor___cli_cursor_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-2.1.0.tgz";
        sha1 = "b35dac376479facc3e94747d41d0d0f5238ffcb5";
      };
    }

    {
      name = "cli_truncate___cli_truncate_0.2.1.tgz";
      path = fetchurl {
        name = "cli_truncate___cli_truncate_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-0.2.1.tgz";
        sha1 = "9f15cfbb0705005369216c626ac7d05ab90dd574";
      };
    }

    {
      name = "cliui___cliui_5.0.0.tgz";
      path = fetchurl {
        name = "cliui___cliui_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/cliui/-/cliui-5.0.0.tgz";
        sha1 = "deefcfdb2e800784aa34f46fa08e06851c7bbbc5";
      };
    }

    {
      name = "cliui___cliui_6.0.0.tgz";
      path = fetchurl {
        name = "cliui___cliui_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/cliui/-/cliui-6.0.0.tgz";
        sha1 = "511d702c0c4e41ca156d7d0e96021f23e13225b1";
      };
    }

    {
      name = "cls_bluebird___cls_bluebird_2.1.0.tgz";
      path = fetchurl {
        name = "cls_bluebird___cls_bluebird_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cls-bluebird/-/cls-bluebird-2.1.0.tgz";
        sha1 = "37ef1e080a8ffb55c2f4164f536f1919e7968aee";
      };
    }

    {
      name = "cluster_key_slot___cluster_key_slot_1.1.0.tgz";
      path = fetchurl {
        name = "cluster_key_slot___cluster_key_slot_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cluster-key-slot/-/cluster-key-slot-1.1.0.tgz";
        sha1 = "30474b2a981fb12172695833052bc0d01336d10d";
      };
    }

    {
      name = "co_bluebird___co_bluebird_1.1.0.tgz";
      path = fetchurl {
        name = "co_bluebird___co_bluebird_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/co-bluebird/-/co-bluebird-1.1.0.tgz";
        sha1 = "c8b9f3a9320a7ed30987dcca1a5c3cff59655c7c";
      };
    }

    {
      name = "co_use___co_use_1.1.0.tgz";
      path = fetchurl {
        name = "co_use___co_use_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/co-use/-/co-use-1.1.0.tgz";
        sha1 = "c6bb3cdf10cb735ecaa9daeeda46d725c94a4e62";
      };
    }

    {
      name = "code_point_at___code_point_at_1.1.0.tgz";
      path = fetchurl {
        name = "code_point_at___code_point_at_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz";
        sha1 = "0d070b4d043a5bea33a2f1a40e2edb3d9a4ccf77";
      };
    }

    {
      name = "color_convert___color_convert_1.9.3.tgz";
      path = fetchurl {
        name = "color_convert___color_convert_1.9.3.tgz";
        url  = "https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz";
        sha1 = "bb71850690e1f136567de629d2d5471deda4c1e8";
      };
    }

    {
      name = "color_convert___color_convert_2.0.1.tgz";
      path = fetchurl {
        name = "color_convert___color_convert_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz";
        sha1 = "72d3a68d598c9bdb3af2ad1e84f21d896abd4de3";
      };
    }

    {
      name = "color_name___color_name_1.1.3.tgz";
      path = fetchurl {
        name = "color_name___color_name_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz";
        sha1 = "a7d0558bd89c42f795dd42328f740831ca53bc25";
      };
    }

    {
      name = "color_name___color_name_1.1.4.tgz";
      path = fetchurl {
        name = "color_name___color_name_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz";
        sha1 = "c2a09a87acbde69543de6f63fa3995c826c536a2";
      };
    }

    {
      name = "color_string___color_string_1.5.3.tgz";
      path = fetchurl {
        name = "color_string___color_string_1.5.3.tgz";
        url  = "https://registry.yarnpkg.com/color-string/-/color-string-1.5.3.tgz";
        sha1 = "c9bbc5f01b58b5492f3d6857459cb6590ce204cc";
      };
    }

    {
      name = "color___color_3.0.0.tgz";
      path = fetchurl {
        name = "color___color_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/color/-/color-3.0.0.tgz";
        sha1 = "d920b4328d534a3ac8295d68f7bd4ba6c427be9a";
      };
    }

    {
      name = "color___color_3.1.2.tgz";
      path = fetchurl {
        name = "color___color_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/color/-/color-3.1.2.tgz";
        sha1 = "68148e7f85d41ad7649c5fa8c8106f098d229e10";
      };
    }

    {
      name = "colornames___colornames_1.1.1.tgz";
      path = fetchurl {
        name = "colornames___colornames_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/colornames/-/colornames-1.1.1.tgz";
        sha1 = "f8889030685c7c4ff9e2a559f5077eb76a816f96";
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
      name = "colors___colors_1.4.0.tgz";
      path = fetchurl {
        name = "colors___colors_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/colors/-/colors-1.4.0.tgz";
        sha1 = "c50491479d4c1bdaed2c9ced32cf7c7dc2360f78";
      };
    }

    {
      name = "colorspace___colorspace_1.1.2.tgz";
      path = fetchurl {
        name = "colorspace___colorspace_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/colorspace/-/colorspace-1.1.2.tgz";
        sha1 = "e0128950d082b86a2168580796a0aa5d6c68d8c5";
      };
    }

    {
      name = "combined_stream___combined_stream_1.0.8.tgz";
      path = fetchurl {
        name = "combined_stream___combined_stream_1.0.8.tgz";
        url  = "https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.8.tgz";
        sha1 = "c3d45a8b34fd730631a110a8a2520682b31d5a7f";
      };
    }

    {
      name = "commander___commander_2.20.3.tgz";
      path = fetchurl {
        name = "commander___commander_2.20.3.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz";
        sha1 = "fd485e84c03eb4881c20722ba48035e8531aeb33";
      };
    }

    {
      name = "commander___commander_4.1.0.tgz";
      path = fetchurl {
        name = "commander___commander_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/commander/-/commander-4.1.0.tgz";
        sha1 = "545983a0603fe425bc672d66c9e3c89c42121a83";
      };
    }

    {
      name = "compact2string___compact2string_1.4.1.tgz";
      path = fetchurl {
        name = "compact2string___compact2string_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/compact2string/-/compact2string-1.4.1.tgz";
        sha1 = "8d34929055f8300a13cfc030ad1832e2e53c2e25";
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
      name = "component_emitter___component_emitter_1.3.0.tgz";
      path = fetchurl {
        name = "component_emitter___component_emitter_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.3.0.tgz";
        sha1 = "16e4070fba8ae29b679f2215853ee181ab2eabc0";
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
      name = "concat_map___concat_map_0.0.1.tgz";
      path = fetchurl {
        name = "concat_map___concat_map_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      };
    }

    {
      name = "concat_stream___concat_stream_1.6.2.tgz";
      path = fetchurl {
        name = "concat_stream___concat_stream_1.6.2.tgz";
        url  = "https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz";
        sha1 = "904bdf194cd3122fc675c77fc4ac3d4ff0fd1a34";
      };
    }

    {
      name = "concurrently___concurrently_5.0.2.tgz";
      path = fetchurl {
        name = "concurrently___concurrently_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/concurrently/-/concurrently-5.0.2.tgz";
        sha1 = "4d2911018c0f15ddec34a8e668fc48dced7f3b1e";
      };
    }

    {
      name = "config___config_3.2.4.tgz";
      path = fetchurl {
        name = "config___config_3.2.4.tgz";
        url  = "https://registry.yarnpkg.com/config/-/config-3.2.4.tgz";
        sha1 = "e60a908582991e800852f9cb60fcf424f3274a6c";
      };
    }

    {
      name = "configstore___configstore_3.1.2.tgz";
      path = fetchurl {
        name = "configstore___configstore_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/configstore/-/configstore-3.1.2.tgz";
        sha1 = "c6f25defaeef26df12dd33414b001fe81a543f8f";
      };
    }

    {
      name = "console_control_strings___console_control_strings_1.1.0.tgz";
      path = fetchurl {
        name = "console_control_strings___console_control_strings_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/console-control-strings/-/console-control-strings-1.1.0.tgz";
        sha1 = "3d7cf4464db6446ea644bf4b39507f9851008e8e";
      };
    }

    {
      name = "content_disposition___content_disposition_0.5.3.tgz";
      path = fetchurl {
        name = "content_disposition___content_disposition_0.5.3.tgz";
        url  = "https://registry.yarnpkg.com/content-disposition/-/content-disposition-0.5.3.tgz";
        sha1 = "e130caf7e7279087c5616c2007d0485698984fbd";
      };
    }

    {
      name = "content_security_policy_builder___content_security_policy_builder_2.1.0.tgz";
      path = fetchurl {
        name = "content_security_policy_builder___content_security_policy_builder_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/content-security-policy-builder/-/content-security-policy-builder-2.1.0.tgz";
        sha1 = "0a2364d769a3d7014eec79ff7699804deb8cfcbb";
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
      name = "cookie_parser___cookie_parser_1.4.4.tgz";
      path = fetchurl {
        name = "cookie_parser___cookie_parser_1.4.4.tgz";
        url  = "https://registry.yarnpkg.com/cookie-parser/-/cookie-parser-1.4.4.tgz";
        sha1 = "e6363de4ea98c3def9697b93421c09f30cf5d188";
      };
    }

    {
      name = "cookie_signature___cookie_signature_1.0.6.tgz";
      path = fetchurl {
        name = "cookie_signature___cookie_signature_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/cookie-signature/-/cookie-signature-1.0.6.tgz";
        sha1 = "e303a882b342cc3ee8ca513a79999734dab3ae2c";
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
      name = "cookie___cookie_0.4.0.tgz";
      path = fetchurl {
        name = "cookie___cookie_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/cookie/-/cookie-0.4.0.tgz";
        sha1 = "beb437e7022b3b6d49019d088665303ebe9c14ba";
      };
    }

    {
      name = "cookiejar___cookiejar_2.1.2.tgz";
      path = fetchurl {
        name = "cookiejar___cookiejar_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/cookiejar/-/cookiejar-2.1.2.tgz";
        sha1 = "dd8a235530752f988f9a0844f3fc589e3111125c";
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
      name = "cors___cors_2.8.5.tgz";
      path = fetchurl {
        name = "cors___cors_2.8.5.tgz";
        url  = "https://registry.yarnpkg.com/cors/-/cors-2.8.5.tgz";
        sha1 = "eac11da51592dd86b9f06f6e7ac293b3df875d29";
      };
    }

    {
      name = "cosmiconfig___cosmiconfig_5.2.1.tgz";
      path = fetchurl {
        name = "cosmiconfig___cosmiconfig_5.2.1.tgz";
        url  = "https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-5.2.1.tgz";
        sha1 = "040f726809c591e77a17c0a3626ca45b4f168b1a";
      };
    }

    {
      name = "create_error_class___create_error_class_3.0.2.tgz";
      path = fetchurl {
        name = "create_error_class___create_error_class_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/create-error-class/-/create-error-class-3.0.2.tgz";
        sha1 = "06be7abef947a3f14a30fd610671d401bca8b7b6";
      };
    }

    {
      name = "create_torrent___create_torrent_4.4.1.tgz";
      path = fetchurl {
        name = "create_torrent___create_torrent_4.4.1.tgz";
        url  = "https://registry.yarnpkg.com/create-torrent/-/create-torrent-4.4.1.tgz";
        sha1 = "0f4068ce375ad69d1fe13bc8aad01a42cd69ebc6";
      };
    }

    {
      name = "cron_parser___cron_parser_2.13.0.tgz";
      path = fetchurl {
        name = "cron_parser___cron_parser_2.13.0.tgz";
        url  = "https://registry.yarnpkg.com/cron-parser/-/cron-parser-2.13.0.tgz";
        sha1 = "6f930bb6f2931790d2a9eec83b3ec276e27a6725";
      };
    }

    {
      name = "cross_spawn___cross_spawn_5.1.0.tgz";
      path = fetchurl {
        name = "cross_spawn___cross_spawn_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-5.1.0.tgz";
        sha1 = "e8bd0efee58fcff6f8f94510a0a554bbfa235449";
      };
    }

    {
      name = "cross_spawn___cross_spawn_7.0.1.tgz";
      path = fetchurl {
        name = "cross_spawn___cross_spawn_7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.1.tgz";
        sha1 = "0ab56286e0f7c24e153d04cc2aa027e43a9a5d14";
      };
    }

    {
      name = "crypt___crypt_0.0.2.tgz";
      path = fetchurl {
        name = "crypt___crypt_0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/crypt/-/crypt-0.0.2.tgz";
        sha1 = "88d7ff7ec0dfb86f713dc87bbb42d044d3e6c41b";
      };
    }

    {
      name = "crypto_random_string___crypto_random_string_1.0.0.tgz";
      path = fetchurl {
        name = "crypto_random_string___crypto_random_string_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/crypto-random-string/-/crypto-random-string-1.0.0.tgz";
        sha1 = "a230f64f568310e1498009940790ec99545bca7e";
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
      name = "d___d_1.0.1.tgz";
      path = fetchurl {
        name = "d___d_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/d/-/d-1.0.1.tgz";
        sha1 = "8698095372d58dbee346ffd0c7093f99f8f9eb5a";
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
      name = "dasherize___dasherize_2.0.0.tgz";
      path = fetchurl {
        name = "dasherize___dasherize_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/dasherize/-/dasherize-2.0.0.tgz";
        sha1 = "6d809c9cd0cf7bb8952d80fc84fa13d47ddb1308";
      };
    }

    {
      name = "date_fns___date_fns_1.30.1.tgz";
      path = fetchurl {
        name = "date_fns___date_fns_1.30.1.tgz";
        url  = "https://registry.yarnpkg.com/date-fns/-/date-fns-1.30.1.tgz";
        sha1 = "2e71bf0b119153dbb4cc4e88d9ea5acfb50dc05c";
      };
    }

    {
      name = "date_fns___date_fns_2.8.1.tgz";
      path = fetchurl {
        name = "date_fns___date_fns_2.8.1.tgz";
        url  = "https://registry.yarnpkg.com/date-fns/-/date-fns-2.8.1.tgz";
        sha1 = "2109362ccb6c87c3ca011e9e31f702bc09e4123b";
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
      name = "debug___debug_3.2.6.tgz";
      path = fetchurl {
        name = "debug___debug_3.2.6.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-3.2.6.tgz";
        sha1 = "e83d17de16d8a7efb7717edbe5fb10135eee629b";
      };
    }

    {
      name = "debug___debug_4.1.1.tgz";
      path = fetchurl {
        name = "debug___debug_4.1.1.tgz";
        url  = "https://registry.yarnpkg.com/debug/-/debug-4.1.1.tgz";
        sha1 = "3b72260255109c6b589cee050f1d516139664791";
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
      name = "debuglog___debuglog_1.0.1.tgz";
      path = fetchurl {
        name = "debuglog___debuglog_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/debuglog/-/debuglog-1.0.1.tgz";
        sha1 = "aa24ffb9ac3df9a2351837cfb2d279360cd78492";
      };
    }

    {
      name = "decamelize___decamelize_1.2.0.tgz";
      path = fetchurl {
        name = "decamelize___decamelize_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz";
        sha1 = "f6534d15148269b20352e7bee26f501f9a191290";
      };
    }

    {
      name = "decompress_response___decompress_response_4.2.1.tgz";
      path = fetchurl {
        name = "decompress_response___decompress_response_4.2.1.tgz";
        url  = "https://registry.yarnpkg.com/decompress-response/-/decompress-response-4.2.1.tgz";
        sha1 = "414023cc7a302da25ce2ec82d0d5238ccafd8986";
      };
    }

    {
      name = "dedent___dedent_0.7.0.tgz";
      path = fetchurl {
        name = "dedent___dedent_0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/dedent/-/dedent-0.7.0.tgz";
        sha1 = "2495ddbaf6eb874abb0e1be9df22d2e5a544326c";
      };
    }

    {
      name = "deep_eql___deep_eql_0.1.3.tgz";
      path = fetchurl {
        name = "deep_eql___deep_eql_0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/deep-eql/-/deep-eql-0.1.3.tgz";
        sha1 = "ef558acab8de25206cd713906d74e56930eb69f2";
      };
    }

    {
      name = "deep_eql___deep_eql_3.0.1.tgz";
      path = fetchurl {
        name = "deep_eql___deep_eql_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/deep-eql/-/deep-eql-3.0.1.tgz";
        sha1 = "dfc9404400ad1c8fe023e7da1df1c147c4b444df";
      };
    }

    {
      name = "deep_equal___deep_equal_0.2.2.tgz";
      path = fetchurl {
        name = "deep_equal___deep_equal_0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/deep-equal/-/deep-equal-0.2.2.tgz";
        sha1 = "84b745896f34c684e98f2ce0e42abaf43bba017d";
      };
    }

    {
      name = "deep_extend___deep_extend_0.6.0.tgz";
      path = fetchurl {
        name = "deep_extend___deep_extend_0.6.0.tgz";
        url  = "https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz";
        sha1 = "c4fa7c95404a17a9c3e8ca7e1537312b736330ac";
      };
    }

    {
      name = "deep_object_diff___deep_object_diff_1.1.0.tgz";
      path = fetchurl {
        name = "deep_object_diff___deep_object_diff_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/deep-object-diff/-/deep-object-diff-1.1.0.tgz";
        sha1 = "d6fabf476c2ed1751fc94d5ca693d2ed8c18bc5a";
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
      name = "del___del_5.1.0.tgz";
      path = fetchurl {
        name = "del___del_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/del/-/del-5.1.0.tgz";
        sha1 = "d9487c94e367410e6eff2925ee58c0c84a75b3a7";
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
      name = "denque___denque_1.4.1.tgz";
      path = fetchurl {
        name = "denque___denque_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/denque/-/denque-1.4.1.tgz";
        sha1 = "6744ff7641c148c3f8a69c307e51235c1f4a37cf";
      };
    }

    {
      name = "depd___depd_2.0.0.tgz";
      path = fetchurl {
        name = "depd___depd_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/depd/-/depd-2.0.0.tgz";
        sha1 = "b696163cc757560d09cf22cc8fad1571b79e76df";
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
      name = "detect_libc___detect_libc_1.0.3.tgz";
      path = fetchurl {
        name = "detect_libc___detect_libc_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/detect-libc/-/detect-libc-1.0.3.tgz";
        sha1 = "fa137c4bd698edf55cd5cd02ac559f91a4c4ba9b";
      };
    }

    {
      name = "diagnostics___diagnostics_1.1.1.tgz";
      path = fetchurl {
        name = "diagnostics___diagnostics_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/diagnostics/-/diagnostics-1.1.1.tgz";
        sha1 = "cab6ac33df70c9d9a727490ae43ac995a769b22a";
      };
    }

    {
      name = "dicer___dicer_0.2.5.tgz";
      path = fetchurl {
        name = "dicer___dicer_0.2.5.tgz";
        url  = "https://registry.yarnpkg.com/dicer/-/dicer-0.2.5.tgz";
        sha1 = "5996c086bb33218c812c090bddc09cd12facb70f";
      };
    }

    {
      name = "diff___diff_3.5.0.tgz";
      path = fetchurl {
        name = "diff___diff_3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/diff/-/diff-3.5.0.tgz";
        sha1 = "800c0dd1e0a8bfbc95835c202ad220fe317e5a12";
      };
    }

    {
      name = "diff___diff_4.0.1.tgz";
      path = fetchurl {
        name = "diff___diff_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/diff/-/diff-4.0.1.tgz";
        sha1 = "0c667cb467ebbb5cea7f14f135cc2dba7780a8ff";
      };
    }

    {
      name = "dir_glob___dir_glob_3.0.1.tgz";
      path = fetchurl {
        name = "dir_glob___dir_glob_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/dir-glob/-/dir-glob-3.0.1.tgz";
        sha1 = "56dbf73d992a4a93ba1584f4534063fd2e41717f";
      };
    }

    {
      name = "dns_prefetch_control___dns_prefetch_control_0.2.0.tgz";
      path = fetchurl {
        name = "dns_prefetch_control___dns_prefetch_control_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/dns-prefetch-control/-/dns-prefetch-control-0.2.0.tgz";
        sha1 = "73988161841f3dcc81f47686d539a2c702c88624";
      };
    }

    {
      name = "doctrine___doctrine_0.7.2.tgz";
      path = fetchurl {
        name = "doctrine___doctrine_0.7.2.tgz";
        url  = "https://registry.yarnpkg.com/doctrine/-/doctrine-0.7.2.tgz";
        sha1 = "7cb860359ba3be90e040b26b729ce4bfa654c523";
      };
    }

    {
      name = "dont_sniff_mimetype___dont_sniff_mimetype_1.1.0.tgz";
      path = fetchurl {
        name = "dont_sniff_mimetype___dont_sniff_mimetype_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/dont-sniff-mimetype/-/dont-sniff-mimetype-1.1.0.tgz";
        sha1 = "c7d0427f8bcb095762751252af59d148b0a623b2";
      };
    }

    {
      name = "dot_prop___dot_prop_4.2.0.tgz";
      path = fetchurl {
        name = "dot_prop___dot_prop_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/dot-prop/-/dot-prop-4.2.0.tgz";
        sha1 = "1f19e0c2e1aa0e32797c49799f2837ac6af69c57";
      };
    }

    {
      name = "dottie___dottie_2.0.2.tgz";
      path = fetchurl {
        name = "dottie___dottie_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/dottie/-/dottie-2.0.2.tgz";
        sha1 = "cc91c0726ce3a054ebf11c55fbc92a7f266dd154";
      };
    }

    {
      name = "double_ended_queue___double_ended_queue_2.1.0_0.tgz";
      path = fetchurl {
        name = "double_ended_queue___double_ended_queue_2.1.0_0.tgz";
        url  = "https://registry.yarnpkg.com/double-ended-queue/-/double-ended-queue-2.1.0-0.tgz";
        sha1 = "103d3527fd31528f40188130c841efdd78264e5c";
      };
    }

    {
      name = "dtrace_provider___dtrace_provider_0.8.8.tgz";
      path = fetchurl {
        name = "dtrace_provider___dtrace_provider_0.8.8.tgz";
        url  = "https://registry.yarnpkg.com/dtrace-provider/-/dtrace-provider-0.8.8.tgz";
        sha1 = "2996d5490c37e1347be263b423ed7b297fb0d97e";
      };
    }

    {
      name = "duplexer3___duplexer3_0.1.4.tgz";
      path = fetchurl {
        name = "duplexer3___duplexer3_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/duplexer3/-/duplexer3-0.1.4.tgz";
        sha1 = "ee01dd1cac0ed3cbc7fdbea37dc0a8f1ce002ce2";
      };
    }

    {
      name = "duplexify___duplexify_3.7.1.tgz";
      path = fetchurl {
        name = "duplexify___duplexify_3.7.1.tgz";
        url  = "https://registry.yarnpkg.com/duplexify/-/duplexify-3.7.1.tgz";
        sha1 = "2a4df5317f6ccfd91f86d6fd25d8d8a103b88309";
      };
    }

    {
      name = "ecc_jsbn___ecc_jsbn_0.1.2.tgz";
      path = fetchurl {
        name = "ecc_jsbn___ecc_jsbn_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz";
        sha1 = "3a83a904e54353287874c564b7549386849a98c9";
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
      name = "elegant_spinner___elegant_spinner_1.0.1.tgz";
      path = fetchurl {
        name = "elegant_spinner___elegant_spinner_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/elegant-spinner/-/elegant-spinner-1.0.1.tgz";
        sha1 = "db043521c95d7e303fd8f345bedc3349cfb0729e";
      };
    }

    {
      name = "emoji_regex___emoji_regex_7.0.3.tgz";
      path = fetchurl {
        name = "emoji_regex___emoji_regex_7.0.3.tgz";
        url  = "https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-7.0.3.tgz";
        sha1 = "933a04052860c85e83c122479c4748a8e4c72156";
      };
    }

    {
      name = "emoji_regex___emoji_regex_8.0.0.tgz";
      path = fetchurl {
        name = "emoji_regex___emoji_regex_8.0.0.tgz";
        url  = "https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz";
        sha1 = "e818fd69ce5ccfcb404594f842963bf53164cc37";
      };
    }

    {
      name = "enabled___enabled_1.0.2.tgz";
      path = fetchurl {
        name = "enabled___enabled_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/enabled/-/enabled-1.0.2.tgz";
        sha1 = "965f6513d2c2d1c5f4652b64a2e3396467fc2f93";
      };
    }

    {
      name = "encodeurl___encodeurl_1.0.2.tgz";
      path = fetchurl {
        name = "encodeurl___encodeurl_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz";
        sha1 = "ad3ff4c86ec2d029322f5a02c3a9a606c95b3f59";
      };
    }

    {
      name = "end_of_stream___end_of_stream_1.4.4.tgz";
      path = fetchurl {
        name = "end_of_stream___end_of_stream_1.4.4.tgz";
        url  = "https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz";
        sha1 = "5ae64a5f45057baf3626ec14da0ca5e4b2431eb0";
      };
    }

    {
      name = "engine.io_client___engine.io_client_3.3.2.tgz";
      path = fetchurl {
        name = "engine.io_client___engine.io_client_3.3.2.tgz";
        url  = "https://registry.yarnpkg.com/engine.io-client/-/engine.io-client-3.3.2.tgz";
        sha1 = "04e068798d75beda14375a264bb3d742d7bc33aa";
      };
    }

    {
      name = "engine.io_client___engine.io_client_3.4.0.tgz";
      path = fetchurl {
        name = "engine.io_client___engine.io_client_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/engine.io-client/-/engine.io-client-3.4.0.tgz";
        sha1 = "82a642b42862a9b3f7a188f41776b2deab643700";
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
      name = "engine.io_parser___engine.io_parser_2.2.0.tgz";
      path = fetchurl {
        name = "engine.io_parser___engine.io_parser_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/engine.io-parser/-/engine.io-parser-2.2.0.tgz";
        sha1 = "312c4894f57d52a02b420868da7b5c1c84af80ed";
      };
    }

    {
      name = "engine.io___engine.io_3.3.2.tgz";
      path = fetchurl {
        name = "engine.io___engine.io_3.3.2.tgz";
        url  = "https://registry.yarnpkg.com/engine.io/-/engine.io-3.3.2.tgz";
        sha1 = "18cbc8b6f36e9461c5c0f81df2b830de16058a59";
      };
    }

    {
      name = "engine.io___engine.io_3.4.0.tgz";
      path = fetchurl {
        name = "engine.io___engine.io_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/engine.io/-/engine.io-3.4.0.tgz";
        sha1 = "3a962cc4535928c252759a00f98519cb46c53ff3";
      };
    }

    {
      name = "env_variable___env_variable_0.0.5.tgz";
      path = fetchurl {
        name = "env_variable___env_variable_0.0.5.tgz";
        url  = "https://registry.yarnpkg.com/env-variable/-/env-variable-0.0.5.tgz";
        sha1 = "913dd830bef11e96a039c038d4130604eba37f88";
      };
    }

    {
      name = "error_ex___error_ex_1.3.2.tgz";
      path = fetchurl {
        name = "error_ex___error_ex_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz";
        sha1 = "b4ac40648107fdcdcfae242f428bea8a14d4f1bf";
      };
    }

    {
      name = "es_abstract___es_abstract_1.17.0.tgz";
      path = fetchurl {
        name = "es_abstract___es_abstract_1.17.0.tgz";
        url  = "https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.17.0.tgz";
        sha1 = "f42a517d0036a5591dbb2c463591dc8bb50309b1";
      };
    }

    {
      name = "es_to_primitive___es_to_primitive_1.2.1.tgz";
      path = fetchurl {
        name = "es_to_primitive___es_to_primitive_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz";
        sha1 = "e55cd4c9cdc188bcefb03b366c736323fc5c898a";
      };
    }

    {
      name = "es5_ext___es5_ext_0.10.53.tgz";
      path = fetchurl {
        name = "es5_ext___es5_ext_0.10.53.tgz";
        url  = "https://registry.yarnpkg.com/es5-ext/-/es5-ext-0.10.53.tgz";
        sha1 = "93c5a3acfdbef275220ad72644ad02ee18368de1";
      };
    }

    {
      name = "es6_iterator___es6_iterator_2.0.3.tgz";
      path = fetchurl {
        name = "es6_iterator___es6_iterator_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/es6-iterator/-/es6-iterator-2.0.3.tgz";
        sha1 = "a7de889141a05a94b0854403b2d0a0fbfa98f3b7";
      };
    }

    {
      name = "es6_promisify___es6_promisify_6.0.2.tgz";
      path = fetchurl {
        name = "es6_promisify___es6_promisify_6.0.2.tgz";
        url  = "https://registry.yarnpkg.com/es6-promisify/-/es6-promisify-6.0.2.tgz";
        sha1 = "525c23725b8510f5f1f2feb5a1fbad93a93e29b4";
      };
    }

    {
      name = "es6_symbol___es6_symbol_3.1.3.tgz";
      path = fetchurl {
        name = "es6_symbol___es6_symbol_3.1.3.tgz";
        url  = "https://registry.yarnpkg.com/es6-symbol/-/es6-symbol-3.1.3.tgz";
        sha1 = "bad5d3c1bcdac28269f4cb331e431c78ac705d18";
      };
    }

    {
      name = "es6_weak_map___es6_weak_map_2.0.3.tgz";
      path = fetchurl {
        name = "es6_weak_map___es6_weak_map_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/es6-weak-map/-/es6-weak-map-2.0.3.tgz";
        sha1 = "b6da1f16cc2cc0d9be43e6bdbfc5e7dfcdf31d53";
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
      name = "esprima___esprima_4.0.1.tgz";
      path = fetchurl {
        name = "esprima___esprima_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz";
        sha1 = "13b04cdb3e6c5d19df91ab6987a8695619b0aa71";
      };
    }

    {
      name = "esutils___esutils_1.1.6.tgz";
      path = fetchurl {
        name = "esutils___esutils_1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/esutils/-/esutils-1.1.6.tgz";
        sha1 = "c01ccaa9ae4b897c6d0c3e210ae52f3c7a844375";
      };
    }

    {
      name = "esutils___esutils_2.0.3.tgz";
      path = fetchurl {
        name = "esutils___esutils_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz";
        sha1 = "74d2eb4de0b8da1293711910d50775b9b710ef64";
      };
    }

    {
      name = "etag___etag_1.8.1.tgz";
      path = fetchurl {
        name = "etag___etag_1.8.1.tgz";
        url  = "https://registry.yarnpkg.com/etag/-/etag-1.8.1.tgz";
        sha1 = "41ae2eeb65efa62268aebfea83ac7d79299b0887";
      };
    }

    {
      name = "event_emitter___event_emitter_0.3.5.tgz";
      path = fetchurl {
        name = "event_emitter___event_emitter_0.3.5.tgz";
        url  = "https://registry.yarnpkg.com/event-emitter/-/event-emitter-0.3.5.tgz";
        sha1 = "df8c69eef1647923c7157b9ce83840610b02cc39";
      };
    }

    {
      name = "execa___execa_0.7.0.tgz";
      path = fetchurl {
        name = "execa___execa_0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-0.7.0.tgz";
        sha1 = "944becd34cc41ee32a63a9faf27ad5a65fc59777";
      };
    }

    {
      name = "execa___execa_2.1.0.tgz";
      path = fetchurl {
        name = "execa___execa_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-2.1.0.tgz";
        sha1 = "e5d3ecd837d2a60ec50f3da78fd39767747bbe99";
      };
    }

    {
      name = "execa___execa_3.2.0.tgz";
      path = fetchurl {
        name = "execa___execa_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/execa/-/execa-3.2.0.tgz";
        sha1 = "18326b79c7ab7fbd6610fd900c1b9e95fa48f90a";
      };
    }

    {
      name = "expand_template___expand_template_2.0.3.tgz";
      path = fetchurl {
        name = "expand_template___expand_template_2.0.3.tgz";
        url  = "https://registry.yarnpkg.com/expand-template/-/expand-template-2.0.3.tgz";
        sha1 = "6e14b3fcee0f3a6340ecb57d2e8918692052a47c";
      };
    }

    {
      name = "expect_ct___expect_ct_0.2.0.tgz";
      path = fetchurl {
        name = "expect_ct___expect_ct_0.2.0.tgz";
        url  = "https://registry.yarnpkg.com/expect-ct/-/expect-ct-0.2.0.tgz";
        sha1 = "3a54741b6ed34cc7a93305c605f63cd268a54a62";
      };
    }

    {
      name = "express_oauth_server___express_oauth_server_2.0.0.tgz";
      path = fetchurl {
        name = "express_oauth_server___express_oauth_server_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/express-oauth-server/-/express-oauth-server-2.0.0.tgz";
        sha1 = "57b08665c1201532f52c4c02f19709238b99a48d";
      };
    }

    {
      name = "express_rate_limit___express_rate_limit_4.0.4.tgz";
      path = fetchurl {
        name = "express_rate_limit___express_rate_limit_4.0.4.tgz";
        url  = "https://registry.yarnpkg.com/express-rate-limit/-/express-rate-limit-4.0.4.tgz";
        sha1 = "a495338ae9e58c856b66d1346ec0d86f43ba2e43";
      };
    }

    {
      name = "express_validator___express_validator_6.3.1.tgz";
      path = fetchurl {
        name = "express_validator___express_validator_6.3.1.tgz";
        url  = "https://registry.yarnpkg.com/express-validator/-/express-validator-6.3.1.tgz";
        sha1 = "5ad6ca3ce6141f33638608d006d26c217500f375";
      };
    }

    {
      name = "express___express_4.17.1.tgz";
      path = fetchurl {
        name = "express___express_4.17.1.tgz";
        url  = "https://registry.yarnpkg.com/express/-/express-4.17.1.tgz";
        sha1 = "4491fc38605cf51f8629d39c2b5d026f98a4c134";
      };
    }

    {
      name = "ext___ext_1.4.0.tgz";
      path = fetchurl {
        name = "ext___ext_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/ext/-/ext-1.4.0.tgz";
        sha1 = "89ae7a07158f79d35517882904324077e4379244";
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
      name = "extsprintf___extsprintf_1.2.0.tgz";
      path = fetchurl {
        name = "extsprintf___extsprintf_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.2.0.tgz";
        sha1 = "5ad946c22f5b32ba7f8cd7426711c6e8a3fc2529";
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
      name = "extsprintf___extsprintf_1.4.0.tgz";
      path = fetchurl {
        name = "extsprintf___extsprintf_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/extsprintf/-/extsprintf-1.4.0.tgz";
        sha1 = "e2689f8f356fad62cca65a3a91c5df5f9551692f";
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
      name = "fast_deep_equal___fast_deep_equal_2.0.1.tgz";
      path = fetchurl {
        name = "fast_deep_equal___fast_deep_equal_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-2.0.1.tgz";
        sha1 = "7b05218ddf9667bf7f370bf7fdb2cb15fdd0aa49";
      };
    }

    {
      name = "fast_glob___fast_glob_3.1.1.tgz";
      path = fetchurl {
        name = "fast_glob___fast_glob_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.1.1.tgz";
        sha1 = "87ee30e9e9f3eb40d6f254a7997655da753d7c82";
      };
    }

    {
      name = "fast_json_stable_stringify___fast_json_stable_stringify_2.1.0.tgz";
      path = fetchurl {
        name = "fast_json_stable_stringify___fast_json_stable_stringify_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz";
        sha1 = "874bf69c6f404c2b5d99c481341399fd55892633";
      };
    }

    {
      name = "fast_safe_stringify___fast_safe_stringify_2.0.7.tgz";
      path = fetchurl {
        name = "fast_safe_stringify___fast_safe_stringify_2.0.7.tgz";
        url  = "https://registry.yarnpkg.com/fast-safe-stringify/-/fast-safe-stringify-2.0.7.tgz";
        sha1 = "124aa885899261f68aedb42a7c080de9da608743";
      };
    }

    {
      name = "fastq___fastq_1.6.0.tgz";
      path = fetchurl {
        name = "fastq___fastq_1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/fastq/-/fastq-1.6.0.tgz";
        sha1 = "4ec8a38f4ac25f21492673adb7eae9cfef47d1c2";
      };
    }

    {
      name = "feature_policy___feature_policy_0.3.0.tgz";
      path = fetchurl {
        name = "feature_policy___feature_policy_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/feature-policy/-/feature-policy-0.3.0.tgz";
        sha1 = "7430e8e54a40da01156ca30aaec1a381ce536069";
      };
    }

    {
      name = "fecha___fecha_2.3.3.tgz";
      path = fetchurl {
        name = "fecha___fecha_2.3.3.tgz";
        url  = "https://registry.yarnpkg.com/fecha/-/fecha-2.3.3.tgz";
        sha1 = "948e74157df1a32fd1b12c3a3c3cdcb6ec9d96cd";
      };
    }

    {
      name = "figures___figures_1.7.0.tgz";
      path = fetchurl {
        name = "figures___figures_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/figures/-/figures-1.7.0.tgz";
        sha1 = "cbe1e3affcf1cd44b80cadfed28dc793a9701d2e";
      };
    }

    {
      name = "figures___figures_2.0.0.tgz";
      path = fetchurl {
        name = "figures___figures_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/figures/-/figures-2.0.0.tgz";
        sha1 = "3ab1a2d2a62c8bfb431a0c94cb797a2fce27c962";
      };
    }

    {
      name = "filestream___filestream_5.0.0.tgz";
      path = fetchurl {
        name = "filestream___filestream_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/filestream/-/filestream-5.0.0.tgz";
        sha1 = "79015f3bae95ad0f47ef818694846f085087b92e";
      };
    }

    {
      name = "fill_range___fill_range_7.0.1.tgz";
      path = fetchurl {
        name = "fill_range___fill_range_7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz";
        sha1 = "1919a6a7c75fe38b2c7c77e5198535da9acdda40";
      };
    }

    {
      name = "finalhandler___finalhandler_1.1.2.tgz";
      path = fetchurl {
        name = "finalhandler___finalhandler_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/finalhandler/-/finalhandler-1.1.2.tgz";
        sha1 = "b7e7d000ffd11938d0fdb053506f6ebabe9f587d";
      };
    }

    {
      name = "find_up___find_up_3.0.0.tgz";
      path = fetchurl {
        name = "find_up___find_up_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-3.0.0.tgz";
        sha1 = "49169f1d7993430646da61ecc5ae355c21c97b73";
      };
    }

    {
      name = "find_up___find_up_4.1.0.tgz";
      path = fetchurl {
        name = "find_up___find_up_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz";
        sha1 = "97afe7d6cdc0bc5928584b7c8d7b16e8a9aa5d19";
      };
    }

    {
      name = "flat___flat_4.1.0.tgz";
      path = fetchurl {
        name = "flat___flat_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/flat/-/flat-4.1.0.tgz";
        sha1 = "090bec8b05e39cba309747f1d588f04dbaf98db2";
      };
    }

    {
      name = "flat___flat_5.0.0.tgz";
      path = fetchurl {
        name = "flat___flat_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/flat/-/flat-5.0.0.tgz";
        sha1 = "dab7d71d60413becb0ac2de9bf4304495e3af6af";
      };
    }

    {
      name = "fluent_ffmpeg___fluent_ffmpeg_2.1.2.tgz";
      path = fetchurl {
        name = "fluent_ffmpeg___fluent_ffmpeg_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/fluent-ffmpeg/-/fluent-ffmpeg-2.1.2.tgz";
        sha1 = "c952de2240f812ebda0aa8006d7776ee2acf7d74";
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
      name = "form_data___form_data_2.5.1.tgz";
      path = fetchurl {
        name = "form_data___form_data_2.5.1.tgz";
        url  = "https://registry.yarnpkg.com/form-data/-/form-data-2.5.1.tgz";
        sha1 = "f2cbec57b5e59e23716e128fe44d4e5dd23895f4";
      };
    }

    {
      name = "form_data___form_data_2.3.3.tgz";
      path = fetchurl {
        name = "form_data___form_data_2.3.3.tgz";
        url  = "https://registry.yarnpkg.com/form-data/-/form-data-2.3.3.tgz";
        sha1 = "dcce52c05f644f298c6a7ab936bd724ceffbf3a6";
      };
    }

    {
      name = "formidable___formidable_1.2.1.tgz";
      path = fetchurl {
        name = "formidable___formidable_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/formidable/-/formidable-1.2.1.tgz";
        sha1 = "70fb7ca0290ee6ff961090415f4b3df3d2082659";
      };
    }

    {
      name = "forwarded___forwarded_0.1.2.tgz";
      path = fetchurl {
        name = "forwarded___forwarded_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/forwarded/-/forwarded-0.1.2.tgz";
        sha1 = "98c23dab1175657b8c0573e8ceccd91b0ff18c84";
      };
    }

    {
      name = "frameguard___frameguard_3.1.0.tgz";
      path = fetchurl {
        name = "frameguard___frameguard_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/frameguard/-/frameguard-3.1.0.tgz";
        sha1 = "bd1442cca1d67dc346a6751559b6d04502103a22";
      };
    }

    {
      name = "freelist___freelist_1.0.3.tgz";
      path = fetchurl {
        name = "freelist___freelist_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/freelist/-/freelist-1.0.3.tgz";
        sha1 = "006775509f3935701784d3ed2fc9f12c9df1bab2";
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
      name = "fs_chunk_store___fs_chunk_store_2.0.1.tgz";
      path = fetchurl {
        name = "fs_chunk_store___fs_chunk_store_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/fs-chunk-store/-/fs-chunk-store-2.0.1.tgz";
        sha1 = "2eb94755d9d46515acc54095d1998c29e121cf99";
      };
    }

    {
      name = "fs_constants___fs_constants_1.0.0.tgz";
      path = fetchurl {
        name = "fs_constants___fs_constants_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-constants/-/fs-constants-1.0.0.tgz";
        sha1 = "6be0de9be998ce16af8afc24497b9ee9b7ccd9ad";
      };
    }

    {
      name = "fs_extra___fs_extra_8.1.0.tgz";
      path = fetchurl {
        name = "fs_extra___fs_extra_8.1.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-extra/-/fs-extra-8.1.0.tgz";
        sha1 = "49d43c45a88cd9677668cb7be1b46efdb8d2e1c0";
      };
    }

    {
      name = "fs_minipass___fs_minipass_1.2.7.tgz";
      path = fetchurl {
        name = "fs_minipass___fs_minipass_1.2.7.tgz";
        url  = "https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-1.2.7.tgz";
        sha1 = "ccff8570841e7fe4265693da88936c55aed7f7c7";
      };
    }

    {
      name = "fs_minipass___fs_minipass_2.0.0.tgz";
      path = fetchurl {
        name = "fs_minipass___fs_minipass_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-2.0.0.tgz";
        sha1 = "a6415edab02fae4b9e9230bc87ee2e4472003cd1";
      };
    }

    {
      name = "fs.realpath___fs.realpath_1.0.0.tgz";
      path = fetchurl {
        name = "fs.realpath___fs.realpath_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz";
        sha1 = "1504ad2523158caa40db4a2787cb01411994ea4f";
      };
    }

    {
      name = "fsevents___fsevents_2.1.2.tgz";
      path = fetchurl {
        name = "fsevents___fsevents_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/fsevents/-/fsevents-2.1.2.tgz";
        sha1 = "4c0a1fb34bc68e543b4b82a9ec392bfbda840805";
      };
    }

    {
      name = "function_bind___function_bind_1.1.1.tgz";
      path = fetchurl {
        name = "function_bind___function_bind_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz";
        sha1 = "a56899d3ea3c9bab874bb9773b7c5ede92f4895d";
      };
    }

    {
      name = "gauge___gauge_2.7.4.tgz";
      path = fetchurl {
        name = "gauge___gauge_2.7.4.tgz";
        url  = "https://registry.yarnpkg.com/gauge/-/gauge-2.7.4.tgz";
        sha1 = "2c03405c7538c39d7eb37b317022e325fb018bf7";
      };
    }

    {
      name = "get_browser_rtc___get_browser_rtc_1.0.2.tgz";
      path = fetchurl {
        name = "get_browser_rtc___get_browser_rtc_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/get-browser-rtc/-/get-browser-rtc-1.0.2.tgz";
        sha1 = "bbcd40c8451a7ed4ef5c373b8169a409dd1d11d9";
      };
    }

    {
      name = "get_caller_file___get_caller_file_2.0.5.tgz";
      path = fetchurl {
        name = "get_caller_file___get_caller_file_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz";
        sha1 = "4f94412a82db32f36e3b0b9741f8a97feb031f7e";
      };
    }

    {
      name = "get_func_name___get_func_name_2.0.0.tgz";
      path = fetchurl {
        name = "get_func_name___get_func_name_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/get-func-name/-/get-func-name-2.0.0.tgz";
        sha1 = "ead774abee72e20409433a066366023dd6887a41";
      };
    }

    {
      name = "get_own_enumerable_property_symbols___get_own_enumerable_property_symbols_3.0.2.tgz";
      path = fetchurl {
        name = "get_own_enumerable_property_symbols___get_own_enumerable_property_symbols_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/get-own-enumerable-property-symbols/-/get-own-enumerable-property-symbols-3.0.2.tgz";
        sha1 = "b5fde77f22cbe35f390b4e089922c50bce6ef664";
      };
    }

    {
      name = "get_port___get_port_5.1.0.tgz";
      path = fetchurl {
        name = "get_port___get_port_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/get-port/-/get-port-5.1.0.tgz";
        sha1 = "a8f6510d0000f07d5c65653a4b0ae648fe832683";
      };
    }

    {
      name = "get_stdin___get_stdin_7.0.0.tgz";
      path = fetchurl {
        name = "get_stdin___get_stdin_7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/get-stdin/-/get-stdin-7.0.0.tgz";
        sha1 = "8d5de98f15171a125c5e516643c7a6d0ea8a96f6";
      };
    }

    {
      name = "get_stream___get_stream_3.0.0.tgz";
      path = fetchurl {
        name = "get_stream___get_stream_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-3.0.0.tgz";
        sha1 = "8e943d1358dc37555054ecbe2edb05aa174ede14";
      };
    }

    {
      name = "get_stream___get_stream_5.1.0.tgz";
      path = fetchurl {
        name = "get_stream___get_stream_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/get-stream/-/get-stream-5.1.0.tgz";
        sha1 = "01203cdc92597f9b909067c3e656cc1f4d3c4dc9";
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
      name = "github_from_package___github_from_package_0.0.0.tgz";
      path = fetchurl {
        name = "github_from_package___github_from_package_0.0.0.tgz";
        url  = "https://registry.yarnpkg.com/github-from-package/-/github-from-package-0.0.0.tgz";
        sha1 = "97fb5d96bfde8973313f20e8288ef9a167fa64ce";
      };
    }

    {
      name = "glob_parent___glob_parent_5.1.0.tgz";
      path = fetchurl {
        name = "glob_parent___glob_parent_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.0.tgz";
        sha1 = "5f4c1d1e748d30cd73ad2944b3577a81b081e8c2";
      };
    }

    {
      name = "glob___glob_7.1.2.tgz";
      path = fetchurl {
        name = "glob___glob_7.1.2.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.1.2.tgz";
        sha1 = "c19c9df9a028702d678612384a6552404c636d15";
      };
    }

    {
      name = "glob___glob_7.1.3.tgz";
      path = fetchurl {
        name = "glob___glob_7.1.3.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.1.3.tgz";
        sha1 = "3960832d3f1574108342dafd3a67b332c0969df1";
      };
    }

    {
      name = "glob___glob_6.0.4.tgz";
      path = fetchurl {
        name = "glob___glob_6.0.4.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-6.0.4.tgz";
        sha1 = "0f08860f6a155127b2fadd4f9ce24b1aab6e4d22";
      };
    }

    {
      name = "glob___glob_7.1.6.tgz";
      path = fetchurl {
        name = "glob___glob_7.1.6.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.1.6.tgz";
        sha1 = "141f33b81a7c2492e125594307480c46679278a6";
      };
    }

    {
      name = "global_dirs___global_dirs_0.1.1.tgz";
      path = fetchurl {
        name = "global_dirs___global_dirs_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/global-dirs/-/global-dirs-0.1.1.tgz";
        sha1 = "b319c0dd4607f353f3be9cca4c72fc148c49f445";
      };
    }

    {
      name = "globby___globby_10.0.2.tgz";
      path = fetchurl {
        name = "globby___globby_10.0.2.tgz";
        url  = "https://registry.yarnpkg.com/globby/-/globby-10.0.2.tgz";
        sha1 = "277593e745acaa4646c3ab411289ec47a0392543";
      };
    }

    {
      name = "got___got_6.7.1.tgz";
      path = fetchurl {
        name = "got___got_6.7.1.tgz";
        url  = "https://registry.yarnpkg.com/got/-/got-6.7.1.tgz";
        sha1 = "240cd05785a9a18e561dc1b44b41c763ef1e8db0";
      };
    }

    {
      name = "graceful_fs___graceful_fs_4.2.3.tgz";
      path = fetchurl {
        name = "graceful_fs___graceful_fs_4.2.3.tgz";
        url  = "https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.3.tgz";
        sha1 = "4a12ff1b60376ef09862c2093edd908328be8423";
      };
    }

    {
      name = "growl___growl_1.10.5.tgz";
      path = fetchurl {
        name = "growl___growl_1.10.5.tgz";
        url  = "https://registry.yarnpkg.com/growl/-/growl-1.10.5.tgz";
        sha1 = "f2735dc2283674fa67478b10181059355c369e5e";
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
      name = "har_validator___har_validator_5.1.3.tgz";
      path = fetchurl {
        name = "har_validator___har_validator_5.1.3.tgz";
        url  = "https://registry.yarnpkg.com/har-validator/-/har-validator-5.1.3.tgz";
        sha1 = "1ef89ebd3e4996557675eed9893110dc350fa080";
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
      name = "has_flag___has_flag_3.0.0.tgz";
      path = fetchurl {
        name = "has_flag___has_flag_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz";
        sha1 = "b5d454dc2199ae225699f3467e5a07f3b955bafd";
      };
    }

    {
      name = "has_flag___has_flag_4.0.0.tgz";
      path = fetchurl {
        name = "has_flag___has_flag_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz";
        sha1 = "944771fd9c81c81265c4d6941860da06bb59479b";
      };
    }

    {
      name = "has_symbols___has_symbols_1.0.1.tgz";
      path = fetchurl {
        name = "has_symbols___has_symbols_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.1.tgz";
        sha1 = "9f5214758a44196c406d9bd76cebf81ec2dd31e8";
      };
    }

    {
      name = "has_unicode___has_unicode_2.0.1.tgz";
      path = fetchurl {
        name = "has_unicode___has_unicode_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/has-unicode/-/has-unicode-2.0.1.tgz";
        sha1 = "e0e6fe6a28cf51138855e086d1691e771de2a8b9";
      };
    }

    {
      name = "has___has_1.0.3.tgz";
      path = fetchurl {
        name = "has___has_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/has/-/has-1.0.3.tgz";
        sha1 = "722d7cbfc1f6aa8241f16dd814e011e1f41e8796";
      };
    }

    {
      name = "hashish___hashish_0.0.4.tgz";
      path = fetchurl {
        name = "hashish___hashish_0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/hashish/-/hashish-0.0.4.tgz";
        sha1 = "6d60bc6ffaf711b6afd60e426d077988014e6554";
      };
    }

    {
      name = "he___he_1.2.0.tgz";
      path = fetchurl {
        name = "he___he_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/he/-/he-1.2.0.tgz";
        sha1 = "84ae65fa7eafb165fddb61566ae14baf05664f0f";
      };
    }

    {
      name = "helmet_crossdomain___helmet_crossdomain_0.4.0.tgz";
      path = fetchurl {
        name = "helmet_crossdomain___helmet_crossdomain_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/helmet-crossdomain/-/helmet-crossdomain-0.4.0.tgz";
        sha1 = "5f1fe5a836d0325f1da0a78eaa5fd8429078894e";
      };
    }

    {
      name = "helmet_csp___helmet_csp_2.9.4.tgz";
      path = fetchurl {
        name = "helmet_csp___helmet_csp_2.9.4.tgz";
        url  = "https://registry.yarnpkg.com/helmet-csp/-/helmet-csp-2.9.4.tgz";
        sha1 = "801382bac98f2f88706dc5c89d95c7e31af3a4a9";
      };
    }

    {
      name = "helmet___helmet_3.21.2.tgz";
      path = fetchurl {
        name = "helmet___helmet_3.21.2.tgz";
        url  = "https://registry.yarnpkg.com/helmet/-/helmet-3.21.2.tgz";
        sha1 = "7e2a19d5f6d898a77b5d2858e8e4bb2cda59f19f";
      };
    }

    {
      name = "hh_mm_ss___hh_mm_ss_1.2.0.tgz";
      path = fetchurl {
        name = "hh_mm_ss___hh_mm_ss_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/hh-mm-ss/-/hh-mm-ss-1.2.0.tgz";
        sha1 = "6d0f0b8280824a634cb1d1f20e0bc7bc8b689948";
      };
    }

    {
      name = "hide_powered_by___hide_powered_by_1.1.0.tgz";
      path = fetchurl {
        name = "hide_powered_by___hide_powered_by_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/hide-powered-by/-/hide-powered-by-1.1.0.tgz";
        sha1 = "be3ea9cab4bdb16f8744be873755ca663383fa7a";
      };
    }

    {
      name = "hosted_git_info___hosted_git_info_2.8.5.tgz";
      path = fetchurl {
        name = "hosted_git_info___hosted_git_info_2.8.5.tgz";
        url  = "https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.5.tgz";
        sha1 = "759cfcf2c4d156ade59b0b2dfabddc42a6b9c70c";
      };
    }

    {
      name = "hpkp___hpkp_2.0.0.tgz";
      path = fetchurl {
        name = "hpkp___hpkp_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/hpkp/-/hpkp-2.0.0.tgz";
        sha1 = "10e142264e76215a5d30c44ec43de64dee6d1672";
      };
    }

    {
      name = "hsts___hsts_2.2.0.tgz";
      path = fetchurl {
        name = "hsts___hsts_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/hsts/-/hsts-2.2.0.tgz";
        sha1 = "09119d42f7a8587035d027dda4522366fe75d964";
      };
    }

    {
      name = "http_errors___http_errors_1.7.2.tgz";
      path = fetchurl {
        name = "http_errors___http_errors_1.7.2.tgz";
        url  = "https://registry.yarnpkg.com/http-errors/-/http-errors-1.7.2.tgz";
        sha1 = "4f5029cf13239f31036e5b2e55292bcfbcc85c8f";
      };
    }

    {
      name = "http_errors___http_errors_1.7.3.tgz";
      path = fetchurl {
        name = "http_errors___http_errors_1.7.3.tgz";
        url  = "https://registry.yarnpkg.com/http-errors/-/http-errors-1.7.3.tgz";
        sha1 = "6c619e4f9c60308c38519498c14fbb10aacebb06";
      };
    }

    {
      name = "https___codeload.github.com_feross_http_node_tar.gz_342ef8624495343ffd050bd0808b3750cf0e3974";
      path = fetchurl {
        name = "https___codeload.github.com_feross_http_node_tar.gz_342ef8624495343ffd050bd0808b3750cf0e3974";
        url  = "https://codeload.github.com/feross/http-node/tar.gz/342ef8624495343ffd050bd0808b3750cf0e3974";
        sha1 = "33fa312d37f0000b17acdb1a5086565400419a13";
      };
    }

    {
      name = "http_parser_js___http_parser_js_0.4.13.tgz";
      path = fetchurl {
        name = "http_parser_js___http_parser_js_0.4.13.tgz";
        url  = "https://registry.yarnpkg.com/http-parser-js/-/http-parser-js-0.4.13.tgz";
        sha1 = "3bd6d6fde6e3172c9334c3b33b6c193d80fe1137";
      };
    }

    {
      name = "http_signature___http_signature_1.3.1.tgz";
      path = fetchurl {
        name = "http_signature___http_signature_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/http-signature/-/http-signature-1.3.1.tgz";
        sha1 = "739fe2f8897ba84798e3e54b699a9008a8724ff9";
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
      name = "human_signals___human_signals_1.1.1.tgz";
      path = fetchurl {
        name = "human_signals___human_signals_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/human-signals/-/human-signals-1.1.1.tgz";
        sha1 = "c5b1cd14f50aeae09ab6c59fe63ba3395fe4dfa3";
      };
    }

    {
      name = "i___i_0.3.6.tgz";
      path = fetchurl {
        name = "i___i_0.3.6.tgz";
        url  = "https://registry.yarnpkg.com/i/-/i-0.3.6.tgz";
        sha1 = "d96c92732076f072711b6b10fd7d4f65ad8ee23d";
      };
    }

    {
      name = "iconv_lite___iconv_lite_0.4.24.tgz";
      path = fetchurl {
        name = "iconv_lite___iconv_lite_0.4.24.tgz";
        url  = "https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz";
        sha1 = "2022b4b25fbddc21d2f524974a474aafe733908b";
      };
    }

    {
      name = "ienoopen___ienoopen_1.1.0.tgz";
      path = fetchurl {
        name = "ienoopen___ienoopen_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ienoopen/-/ienoopen-1.1.0.tgz";
        sha1 = "411e5d530c982287dbdc3bb31e7a9c9e32630974";
      };
    }

    {
      name = "ignore_by_default___ignore_by_default_1.0.1.tgz";
      path = fetchurl {
        name = "ignore_by_default___ignore_by_default_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ignore-by-default/-/ignore-by-default-1.0.1.tgz";
        sha1 = "48ca6d72f6c6a3af00a9ad4ae6876be3889e2b09";
      };
    }

    {
      name = "ignore_walk___ignore_walk_3.0.3.tgz";
      path = fetchurl {
        name = "ignore_walk___ignore_walk_3.0.3.tgz";
        url  = "https://registry.yarnpkg.com/ignore-walk/-/ignore-walk-3.0.3.tgz";
        sha1 = "017e2447184bfeade7c238e4aefdd1e8f95b1e37";
      };
    }

    {
      name = "ignore___ignore_5.1.4.tgz";
      path = fetchurl {
        name = "ignore___ignore_5.1.4.tgz";
        url  = "https://registry.yarnpkg.com/ignore/-/ignore-5.1.4.tgz";
        sha1 = "84b7b3dbe64552b6ef0eca99f6743dbec6d97adf";
      };
    }

    {
      name = "immediate_chunk_store___immediate_chunk_store_2.1.0.tgz";
      path = fetchurl {
        name = "immediate_chunk_store___immediate_chunk_store_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/immediate-chunk-store/-/immediate-chunk-store-2.1.0.tgz";
        sha1 = "3dbd3b5cc77182526188a8da47e38488a6627336";
      };
    }

    {
      name = "import_fresh___import_fresh_2.0.0.tgz";
      path = fetchurl {
        name = "import_fresh___import_fresh_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/import-fresh/-/import-fresh-2.0.0.tgz";
        sha1 = "d81355c15612d386c61f9ddd3922d4304822a546";
      };
    }

    {
      name = "import_lazy___import_lazy_2.1.0.tgz";
      path = fetchurl {
        name = "import_lazy___import_lazy_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/import-lazy/-/import-lazy-2.1.0.tgz";
        sha1 = "05698e3d45c88e8d7e9d92cb0584e77f096f3e43";
      };
    }

    {
      name = "imurmurhash___imurmurhash_0.1.4.tgz";
      path = fetchurl {
        name = "imurmurhash___imurmurhash_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz";
        sha1 = "9218b9b2b928a238b13dc4fb6b6d576f231453ea";
      };
    }

    {
      name = "indent_string___indent_string_3.2.0.tgz";
      path = fetchurl {
        name = "indent_string___indent_string_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/indent-string/-/indent-string-3.2.0.tgz";
        sha1 = "4a5fd6d27cc332f37e5419a504dbb837105c9289";
      };
    }

    {
      name = "indent_string___indent_string_4.0.0.tgz";
      path = fetchurl {
        name = "indent_string___indent_string_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz";
        sha1 = "624f8f4497d619b2d9768531d58f4122854d7251";
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
      name = "inflection___inflection_1.12.0.tgz";
      path = fetchurl {
        name = "inflection___inflection_1.12.0.tgz";
        url  = "https://registry.yarnpkg.com/inflection/-/inflection-1.12.0.tgz";
        sha1 = "a200935656d6f5f6bc4dc7502e1aecb703228416";
      };
    }

    {
      name = "inflight___inflight_1.0.6.tgz";
      path = fetchurl {
        name = "inflight___inflight_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz";
        sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
      };
    }

    {
      name = "inherits___inherits_2.0.4.tgz";
      path = fetchurl {
        name = "inherits___inherits_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz";
        sha1 = "0fa2c64f932917c3433a0ded55363aae37416b7c";
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
      name = "ini___ini_1.3.5.tgz";
      path = fetchurl {
        name = "ini___ini_1.3.5.tgz";
        url  = "https://registry.yarnpkg.com/ini/-/ini-1.3.5.tgz";
        sha1 = "eee25f56db1c9ec6085e0c22778083f596abf927";
      };
    }

    {
      name = "ioredis___ioredis_4.14.1.tgz";
      path = fetchurl {
        name = "ioredis___ioredis_4.14.1.tgz";
        url  = "https://registry.yarnpkg.com/ioredis/-/ioredis-4.14.1.tgz";
        sha1 = "b73ded95fcf220f106d33125a92ef6213aa31318";
      };
    }

    {
      name = "ip_anonymize___ip_anonymize_0.1.0.tgz";
      path = fetchurl {
        name = "ip_anonymize___ip_anonymize_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ip-anonymize/-/ip-anonymize-0.1.0.tgz";
        sha1 = "5ead504d01871c5c28189a25382f852036b57f7e";
      };
    }

    {
      name = "ip_regex___ip_regex_2.1.0.tgz";
      path = fetchurl {
        name = "ip_regex___ip_regex_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/ip-regex/-/ip-regex-2.1.0.tgz";
        sha1 = "fa78bf5d2e6913c911ce9f819ee5146bb6d844e9";
      };
    }

    {
      name = "ip_set___ip_set_1.0.2.tgz";
      path = fetchurl {
        name = "ip_set___ip_set_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/ip-set/-/ip-set-1.0.2.tgz";
        sha1 = "be4f119f82c124836455993dfcd554639c7007de";
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
      name = "ipaddr.js___ipaddr.js_1.9.0.tgz";
      path = fetchurl {
        name = "ipaddr.js___ipaddr.js_1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/ipaddr.js/-/ipaddr.js-1.9.0.tgz";
        sha1 = "37df74e430a0e47550fe54a2defe30d8acd95f65";
      };
    }

    {
      name = "ipaddr.js___ipaddr.js_1.9.1.tgz";
      path = fetchurl {
        name = "ipaddr.js___ipaddr.js_1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/ipaddr.js/-/ipaddr.js-1.9.1.tgz";
        sha1 = "bff38543eeb8984825079ff3a2a8e6cbd46781b3";
      };
    }

    {
      name = "ipv6_normalize___ipv6_normalize_1.0.1.tgz";
      path = fetchurl {
        name = "ipv6_normalize___ipv6_normalize_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ipv6-normalize/-/ipv6-normalize-1.0.1.tgz";
        sha1 = "1b3258290d365fa83239e89907dde4592e7620a8";
      };
    }

    {
      name = "is_arrayish___is_arrayish_0.2.1.tgz";
      path = fetchurl {
        name = "is_arrayish___is_arrayish_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz";
        sha1 = "77c99840527aa8ecb1a8ba697b80645a7a926a9d";
      };
    }

    {
      name = "is_arrayish___is_arrayish_0.3.2.tgz";
      path = fetchurl {
        name = "is_arrayish___is_arrayish_0.3.2.tgz";
        url  = "https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.3.2.tgz";
        sha1 = "4574a2ae56f7ab206896fb431eaeed066fdf8f03";
      };
    }

    {
      name = "is_ascii___is_ascii_1.0.0.tgz";
      path = fetchurl {
        name = "is_ascii___is_ascii_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-ascii/-/is-ascii-1.0.0.tgz";
        sha1 = "f02ad0259a0921cd199ff21ce1b09e0f6b4e3929";
      };
    }

    {
      name = "is_binary_path___is_binary_path_2.1.0.tgz";
      path = fetchurl {
        name = "is_binary_path___is_binary_path_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz";
        sha1 = "ea1f7f3b80f064236e83470f86c09c254fb45b09";
      };
    }

    {
      name = "is_bluebird___is_bluebird_1.0.2.tgz";
      path = fetchurl {
        name = "is_bluebird___is_bluebird_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-bluebird/-/is-bluebird-1.0.2.tgz";
        sha1 = "096439060f4aa411abee19143a84d6a55346d6e2";
      };
    }

    {
      name = "is_buffer___is_buffer_1.1.6.tgz";
      path = fetchurl {
        name = "is_buffer___is_buffer_1.1.6.tgz";
        url  = "https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz";
        sha1 = "efaa2ea9daa0d7ab2ea13a97b2b8ad51fefbe8be";
      };
    }

    {
      name = "is_buffer___is_buffer_2.0.4.tgz";
      path = fetchurl {
        name = "is_buffer___is_buffer_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/is-buffer/-/is-buffer-2.0.4.tgz";
        sha1 = "3e572f23c8411a5cfd9557c849e3665e0b290623";
      };
    }

    {
      name = "is_callable___is_callable_1.1.5.tgz";
      path = fetchurl {
        name = "is_callable___is_callable_1.1.5.tgz";
        url  = "https://registry.yarnpkg.com/is-callable/-/is-callable-1.1.5.tgz";
        sha1 = "f7e46b596890456db74e7f6e976cb3273d06faab";
      };
    }

    {
      name = "is_ci___is_ci_1.2.1.tgz";
      path = fetchurl {
        name = "is_ci___is_ci_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/is-ci/-/is-ci-1.2.1.tgz";
        sha1 = "e3779c8ee17fccf428488f6e281187f2e632841c";
      };
    }

    {
      name = "is_cidr___is_cidr_3.1.0.tgz";
      path = fetchurl {
        name = "is_cidr___is_cidr_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-cidr/-/is-cidr-3.1.0.tgz";
        sha1 = "72e233d8e1c4cd1d3f11713fcce3eba7b0e3476f";
      };
    }

    {
      name = "is_date_object___is_date_object_1.0.2.tgz";
      path = fetchurl {
        name = "is_date_object___is_date_object_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.2.tgz";
        sha1 = "bda736f2cd8fd06d32844e7743bfa7494c3bfd7e";
      };
    }

    {
      name = "is_directory___is_directory_0.3.1.tgz";
      path = fetchurl {
        name = "is_directory___is_directory_0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/is-directory/-/is-directory-0.3.1.tgz";
        sha1 = "61339b6f2475fc772fd9c9d83f5c8575dc154ae1";
      };
    }

    {
      name = "is_extglob___is_extglob_2.1.1.tgz";
      path = fetchurl {
        name = "is_extglob___is_extglob_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz";
        sha1 = "a88c02535791f02ed37c76a1b9ea9773c833f8c2";
      };
    }

    {
      name = "is_file___is_file_1.0.0.tgz";
      path = fetchurl {
        name = "is_file___is_file_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-file/-/is-file-1.0.0.tgz";
        sha1 = "28a44cfbd9d3db193045f22b65fce8edf9620596";
      };
    }

    {
      name = "is_fullwidth_code_point___is_fullwidth_code_point_1.0.0.tgz";
      path = fetchurl {
        name = "is_fullwidth_code_point___is_fullwidth_code_point_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz";
        sha1 = "ef9e31386f031a7f0d643af82fde50c457ef00cb";
      };
    }

    {
      name = "is_fullwidth_code_point___is_fullwidth_code_point_2.0.0.tgz";
      path = fetchurl {
        name = "is_fullwidth_code_point___is_fullwidth_code_point_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz";
        sha1 = "a3b30a5c4f199183167aaab93beefae3ddfb654f";
      };
    }

    {
      name = "is_fullwidth_code_point___is_fullwidth_code_point_3.0.0.tgz";
      path = fetchurl {
        name = "is_fullwidth_code_point___is_fullwidth_code_point_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz";
        sha1 = "f116f8064fe90b3f7844a38997c0b75051269f1d";
      };
    }

    {
      name = "is_generator___is_generator_1.0.3.tgz";
      path = fetchurl {
        name = "is_generator___is_generator_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/is-generator/-/is-generator-1.0.3.tgz";
        sha1 = "c14c21057ed36e328db80347966c693f886389f3";
      };
    }

    {
      name = "is_glob___is_glob_4.0.1.tgz";
      path = fetchurl {
        name = "is_glob___is_glob_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.1.tgz";
        sha1 = "7567dbe9f2f5e2467bc77ab83c4a29482407a5dc";
      };
    }

    {
      name = "is_installed_globally___is_installed_globally_0.1.0.tgz";
      path = fetchurl {
        name = "is_installed_globally___is_installed_globally_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-installed-globally/-/is-installed-globally-0.1.0.tgz";
        sha1 = "0dfd98f5a9111716dd535dda6492f67bf3d25a80";
      };
    }

    {
      name = "is_nan___is_nan_1.3.0.tgz";
      path = fetchurl {
        name = "is_nan___is_nan_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/is-nan/-/is-nan-1.3.0.tgz";
        sha1 = "85d1f5482f7051c2019f5673ccebdb06f3b0db03";
      };
    }

    {
      name = "is_npm___is_npm_1.0.0.tgz";
      path = fetchurl {
        name = "is_npm___is_npm_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-npm/-/is-npm-1.0.0.tgz";
        sha1 = "f2fb63a65e4905b406c86072765a1a4dc793b9f4";
      };
    }

    {
      name = "is_number___is_number_7.0.0.tgz";
      path = fetchurl {
        name = "is_number___is_number_7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz";
        sha1 = "7535345b896734d5f80c4d06c50955527a14f12b";
      };
    }

    {
      name = "is_obj___is_obj_1.0.1.tgz";
      path = fetchurl {
        name = "is_obj___is_obj_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-obj/-/is-obj-1.0.1.tgz";
        sha1 = "3e4729ac1f5fde025cd7d83a896dab9f4f67db0f";
      };
    }

    {
      name = "is_observable___is_observable_1.1.0.tgz";
      path = fetchurl {
        name = "is_observable___is_observable_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-observable/-/is-observable-1.1.0.tgz";
        sha1 = "b3e986c8f44de950867cab5403f5a3465005975e";
      };
    }

    {
      name = "is_path_cwd___is_path_cwd_2.2.0.tgz";
      path = fetchurl {
        name = "is_path_cwd___is_path_cwd_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-2.2.0.tgz";
        sha1 = "67d43b82664a7b5191fd9119127eb300048a9fdb";
      };
    }

    {
      name = "is_path_inside___is_path_inside_1.0.1.tgz";
      path = fetchurl {
        name = "is_path_inside___is_path_inside_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-1.0.1.tgz";
        sha1 = "8ef5b7de50437a3fdca6b4e865ef7aa55cb48036";
      };
    }

    {
      name = "is_path_inside___is_path_inside_3.0.2.tgz";
      path = fetchurl {
        name = "is_path_inside___is_path_inside_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-3.0.2.tgz";
        sha1 = "f5220fc82a3e233757291dddc9c5877f2a1f3017";
      };
    }

    {
      name = "is_promise___is_promise_2.1.0.tgz";
      path = fetchurl {
        name = "is_promise___is_promise_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-promise/-/is-promise-2.1.0.tgz";
        sha1 = "79a2a9ece7f096e80f36d2b2f3bc16c1ff4bf3fa";
      };
    }

    {
      name = "is_redirect___is_redirect_1.0.0.tgz";
      path = fetchurl {
        name = "is_redirect___is_redirect_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-redirect/-/is-redirect-1.0.0.tgz";
        sha1 = "1d03dded53bd8db0f30c26e4f95d36fc7c87dc24";
      };
    }

    {
      name = "is_regex___is_regex_1.0.5.tgz";
      path = fetchurl {
        name = "is_regex___is_regex_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/is-regex/-/is-regex-1.0.5.tgz";
        sha1 = "39d589a358bf18967f726967120b8fc1aed74eae";
      };
    }

    {
      name = "is_regexp___is_regexp_1.0.0.tgz";
      path = fetchurl {
        name = "is_regexp___is_regexp_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-regexp/-/is-regexp-1.0.0.tgz";
        sha1 = "fd2d883545c46bac5a633e7b9a09e87fa2cb5069";
      };
    }

    {
      name = "is_retry_allowed___is_retry_allowed_1.2.0.tgz";
      path = fetchurl {
        name = "is_retry_allowed___is_retry_allowed_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/is-retry-allowed/-/is-retry-allowed-1.2.0.tgz";
        sha1 = "d778488bd0a4666a3be8a1482b9f2baafedea8b4";
      };
    }

    {
      name = "is_stream___is_stream_1.1.0.tgz";
      path = fetchurl {
        name = "is_stream___is_stream_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-stream/-/is-stream-1.1.0.tgz";
        sha1 = "12d4a3dd4e68e0b79ceb8dbc84173ae80d91ca44";
      };
    }

    {
      name = "is_stream___is_stream_2.0.0.tgz";
      path = fetchurl {
        name = "is_stream___is_stream_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.0.tgz";
        sha1 = "bde9c32680d6fae04129d6ac9d921ce7815f78e3";
      };
    }

    {
      name = "is_symbol___is_symbol_1.0.3.tgz";
      path = fetchurl {
        name = "is_symbol___is_symbol_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.3.tgz";
        sha1 = "38e1014b9e6329be0de9d24a414fd7441ec61937";
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
      name = "is_wsl___is_wsl_1.1.0.tgz";
      path = fetchurl {
        name = "is_wsl___is_wsl_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/is-wsl/-/is-wsl-1.1.0.tgz";
        sha1 = "1f16e4aa22b04d1336b66188a66af3c600c3a66d";
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
      name = "isexe___isexe_2.0.0.tgz";
      path = fetchurl {
        name = "isexe___isexe_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz";
        sha1 = "e8fbf374dc556ff8947a10dcb0572d633f2cfa10";
      };
    }

    {
      name = "iso_639_3___iso_639_3_1.2.0.tgz";
      path = fetchurl {
        name = "iso_639_3___iso_639_3_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/iso-639-3/-/iso-639-3-1.2.0.tgz";
        sha1 = "eee1f5e6ca2bbb33e3ecc910857c1c12e8b295be";
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
      name = "js_tokens___js_tokens_4.0.0.tgz";
      path = fetchurl {
        name = "js_tokens___js_tokens_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz";
        sha1 = "19203fb59991df98e3a287050d4647cdeaf32499";
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
      name = "json_parse_better_errors___json_parse_better_errors_1.0.2.tgz";
      path = fetchurl {
        name = "json_parse_better_errors___json_parse_better_errors_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz";
        sha1 = "bb867cfb3450e69107c131d1c514bab3dc8bcaa9";
      };
    }

    {
      name = "json_schema_ref_parser___json_schema_ref_parser_7.1.3.tgz";
      path = fetchurl {
        name = "json_schema_ref_parser___json_schema_ref_parser_7.1.3.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-ref-parser/-/json-schema-ref-parser-7.1.3.tgz";
        sha1 = "21468cd180b2f1939ce93fe291f743b441e97d49";
      };
    }

    {
      name = "json_schema_traverse___json_schema_traverse_0.4.1.tgz";
      path = fetchurl {
        name = "json_schema_traverse___json_schema_traverse_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz";
        sha1 = "69f6a87d9513ab8bb8fe63bdb0979c448e684660";
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
      name = "json5___json5_1.0.1.tgz";
      path = fetchurl {
        name = "json5___json5_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/json5/-/json5-1.0.1.tgz";
        sha1 = "779fb0018604fa854eacbf6252180d83543e3dbe";
      };
    }

    {
      name = "jsonfile___jsonfile_4.0.0.tgz";
      path = fetchurl {
        name = "jsonfile___jsonfile_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz";
        sha1 = "8771aae0799b64076b76640fca058f9c10e33ecb";
      };
    }

    {
      name = "jsonld___jsonld_2.0.1.tgz";
      path = fetchurl {
        name = "jsonld___jsonld_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/jsonld/-/jsonld-2.0.1.tgz";
        sha1 = "c08760fb00f429496b45f5c9984bf9be408d3980";
      };
    }

    {
      name = "jsonpointer.js___jsonpointer.js_0.4.0.tgz";
      path = fetchurl {
        name = "jsonpointer.js___jsonpointer.js_0.4.0.tgz";
        url  = "https://registry.yarnpkg.com/jsonpointer.js/-/jsonpointer.js-0.4.0.tgz";
        sha1 = "002cb123f767aafdeb0196132ce5c4f9941ccaba";
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
      name = "junk___junk_3.1.0.tgz";
      path = fetchurl {
        name = "junk___junk_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/junk/-/junk-3.1.0.tgz";
        sha1 = "31499098d902b7e98c5d9b9c80f43457a88abfa1";
      };
    }

    {
      name = "k_bucket___k_bucket_5.0.0.tgz";
      path = fetchurl {
        name = "k_bucket___k_bucket_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/k-bucket/-/k-bucket-5.0.0.tgz";
        sha1 = "ef7a401fcd4c37cd31dceaa6ae4440ca91055e01";
      };
    }

    {
      name = "k_rpc_socket___k_rpc_socket_1.11.1.tgz";
      path = fetchurl {
        name = "k_rpc_socket___k_rpc_socket_1.11.1.tgz";
        url  = "https://registry.yarnpkg.com/k-rpc-socket/-/k-rpc-socket-1.11.1.tgz";
        sha1 = "f14b4b240a716c6cad7b6434b21716dbd7c7b0e8";
      };
    }

    {
      name = "k_rpc___k_rpc_5.1.0.tgz";
      path = fetchurl {
        name = "k_rpc___k_rpc_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/k-rpc/-/k-rpc-5.1.0.tgz";
        sha1 = "af2052de2e84994d55da3032175da5dad8640174";
      };
    }

    {
      name = "kuler___kuler_1.0.1.tgz";
      path = fetchurl {
        name = "kuler___kuler_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/kuler/-/kuler-1.0.1.tgz";
        sha1 = "ef7c784f36c9fb6e16dd3150d152677b2b0228a6";
      };
    }

    {
      name = "last_one_wins___last_one_wins_1.0.4.tgz";
      path = fetchurl {
        name = "last_one_wins___last_one_wins_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/last-one-wins/-/last-one-wins-1.0.4.tgz";
        sha1 = "c1bfd0cbcb46790ec9156b8d1aee8fcb86cda22a";
      };
    }

    {
      name = "latest_version___latest_version_3.1.0.tgz";
      path = fetchurl {
        name = "latest_version___latest_version_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/latest-version/-/latest-version-3.1.0.tgz";
        sha1 = "a205383fea322b33b5ae3b18abee0dc2f356ee15";
      };
    }

    {
      name = "ldap_filter___ldap_filter_0.2.2.tgz";
      path = fetchurl {
        name = "ldap_filter___ldap_filter_0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/ldap-filter/-/ldap-filter-0.2.2.tgz";
        sha1 = "f2b842be0b86da3352798505b31ebcae590d77d0";
      };
    }

    {
      name = "ldapjs___ldapjs_1.0.2.tgz";
      path = fetchurl {
        name = "ldapjs___ldapjs_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/ldapjs/-/ldapjs-1.0.2.tgz";
        sha1 = "544ff7032b7b83c68f0701328d9297aa694340f9";
      };
    }

    {
      name = "libxmljs___libxmljs_0.19.7.tgz";
      path = fetchurl {
        name = "libxmljs___libxmljs_0.19.7.tgz";
        url  = "https://registry.yarnpkg.com/libxmljs/-/libxmljs-0.19.7.tgz";
        sha1 = "96c2151b0b73f33dd29917edec82902587004e5a";
      };
    }

    {
      name = "lint_staged___lint_staged_9.5.0.tgz";
      path = fetchurl {
        name = "lint_staged___lint_staged_9.5.0.tgz";
        url  = "https://registry.yarnpkg.com/lint-staged/-/lint-staged-9.5.0.tgz";
        sha1 = "290ec605252af646d9b74d73a0fa118362b05a33";
      };
    }

    {
      name = "listr_silent_renderer___listr_silent_renderer_1.1.1.tgz";
      path = fetchurl {
        name = "listr_silent_renderer___listr_silent_renderer_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/listr-silent-renderer/-/listr-silent-renderer-1.1.1.tgz";
        sha1 = "924b5a3757153770bf1a8e3fbf74b8bbf3f9242e";
      };
    }

    {
      name = "listr_update_renderer___listr_update_renderer_0.5.0.tgz";
      path = fetchurl {
        name = "listr_update_renderer___listr_update_renderer_0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/listr-update-renderer/-/listr-update-renderer-0.5.0.tgz";
        sha1 = "4ea8368548a7b8aecb7e06d8c95cb45ae2ede6a2";
      };
    }

    {
      name = "listr_verbose_renderer___listr_verbose_renderer_0.5.0.tgz";
      path = fetchurl {
        name = "listr_verbose_renderer___listr_verbose_renderer_0.5.0.tgz";
        url  = "https://registry.yarnpkg.com/listr-verbose-renderer/-/listr-verbose-renderer-0.5.0.tgz";
        sha1 = "f1132167535ea4c1261102b9f28dac7cba1e03db";
      };
    }

    {
      name = "listr___listr_0.14.3.tgz";
      path = fetchurl {
        name = "listr___listr_0.14.3.tgz";
        url  = "https://registry.yarnpkg.com/listr/-/listr-0.14.3.tgz";
        sha1 = "2fea909604e434be464c50bddba0d496928fa586";
      };
    }

    {
      name = "load_ip_set___load_ip_set_2.1.0.tgz";
      path = fetchurl {
        name = "load_ip_set___load_ip_set_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/load-ip-set/-/load-ip-set-2.1.0.tgz";
        sha1 = "2d50b737cae41de4e413d213991d4083a3e1784b";
      };
    }

    {
      name = "locate_path___locate_path_3.0.0.tgz";
      path = fetchurl {
        name = "locate_path___locate_path_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-3.0.0.tgz";
        sha1 = "dbec3b3ab759758071b58fe59fc41871af21400e";
      };
    }

    {
      name = "locate_path___locate_path_5.0.0.tgz";
      path = fetchurl {
        name = "locate_path___locate_path_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz";
        sha1 = "1afba396afd676a6d42504d0a67a3a7eb9f62aa0";
      };
    }

    {
      name = "lodash.defaults___lodash.defaults_4.2.0.tgz";
      path = fetchurl {
        name = "lodash.defaults___lodash.defaults_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.defaults/-/lodash.defaults-4.2.0.tgz";
        sha1 = "d09178716ffea4dde9e5fb7b37f6f0802274580c";
      };
    }

    {
      name = "lodash.flatten___lodash.flatten_4.4.0.tgz";
      path = fetchurl {
        name = "lodash.flatten___lodash.flatten_4.4.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.flatten/-/lodash.flatten-4.4.0.tgz";
        sha1 = "f31c22225a9632d2bbf8e4addbef240aa765a61f";
      };
    }

    {
      name = "lodash.get___lodash.get_4.4.2.tgz";
      path = fetchurl {
        name = "lodash.get___lodash.get_4.4.2.tgz";
        url  = "https://registry.yarnpkg.com/lodash.get/-/lodash.get-4.4.2.tgz";
        sha1 = "2d177f652fa31e939b4438d5341499dfa3825e99";
      };
    }

    {
      name = "lodash.isequal___lodash.isequal_4.5.0.tgz";
      path = fetchurl {
        name = "lodash.isequal___lodash.isequal_4.5.0.tgz";
        url  = "https://registry.yarnpkg.com/lodash.isequal/-/lodash.isequal-4.5.0.tgz";
        sha1 = "415c4478f2bcc30120c22ce10ed3226f7d3e18e0";
      };
    }

    {
      name = "lodash___lodash_4.17.4.tgz";
      path = fetchurl {
        name = "lodash___lodash_4.17.4.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.4.tgz";
        sha1 = "78203a4d1c328ae1d86dca6460e369b57f4055ae";
      };
    }

    {
      name = "lodash___lodash_4.17.15.tgz";
      path = fetchurl {
        name = "lodash___lodash_4.17.15.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.15.tgz";
        sha1 = "b447f6670a0455bbfeedd11392eff330ea097548";
      };
    }

    {
      name = "log_symbols___log_symbols_2.2.0.tgz";
      path = fetchurl {
        name = "log_symbols___log_symbols_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/log-symbols/-/log-symbols-2.2.0.tgz";
        sha1 = "5740e1c5d6f0dfda4ad9323b5332107ef6b4c40a";
      };
    }

    {
      name = "log_symbols___log_symbols_1.0.2.tgz";
      path = fetchurl {
        name = "log_symbols___log_symbols_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/log-symbols/-/log-symbols-1.0.2.tgz";
        sha1 = "376ff7b58ea3086a0f09facc74617eca501e1a18";
      };
    }

    {
      name = "log_symbols___log_symbols_3.0.0.tgz";
      path = fetchurl {
        name = "log_symbols___log_symbols_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/log-symbols/-/log-symbols-3.0.0.tgz";
        sha1 = "f3a08516a5dea893336a7dee14d18a1cfdab77c4";
      };
    }

    {
      name = "log_update___log_update_2.3.0.tgz";
      path = fetchurl {
        name = "log_update___log_update_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/log-update/-/log-update-2.3.0.tgz";
        sha1 = "88328fd7d1ce7938b29283746f0b1bc126b24708";
      };
    }

    {
      name = "logform___logform_2.1.2.tgz";
      path = fetchurl {
        name = "logform___logform_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/logform/-/logform-2.1.2.tgz";
        sha1 = "957155ebeb67a13164069825ce67ddb5bb2dd360";
      };
    }

    {
      name = "lowercase_keys___lowercase_keys_1.0.1.tgz";
      path = fetchurl {
        name = "lowercase_keys___lowercase_keys_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-1.0.1.tgz";
        sha1 = "6f9e30b47084d971a7c820ff15a6c5167b74c26f";
      };
    }

    {
      name = "lru_cache___lru_cache_4.1.5.tgz";
      path = fetchurl {
        name = "lru_cache___lru_cache_4.1.5.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-4.1.5.tgz";
        sha1 = "8bbe50ea85bed59bc9e33dcab8235ee9bcf443cd";
      };
    }

    {
      name = "lru_cache___lru_cache_5.1.1.tgz";
      path = fetchurl {
        name = "lru_cache___lru_cache_5.1.1.tgz";
        url  = "https://registry.yarnpkg.com/lru-cache/-/lru-cache-5.1.1.tgz";
        sha1 = "1da27e6710271947695daf6848e847f01d84b920";
      };
    }

    {
      name = "lru_queue___lru_queue_0.1.0.tgz";
      path = fetchurl {
        name = "lru_queue___lru_queue_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/lru-queue/-/lru-queue-0.1.0.tgz";
        sha1 = "2738bd9f0d3cf4f84490c5736c48699ac632cda3";
      };
    }

    {
      name = "lru___lru_3.1.0.tgz";
      path = fetchurl {
        name = "lru___lru_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/lru/-/lru-3.1.0.tgz";
        sha1 = "ea7fb8546d83733396a13091d76cfeb4c06837d5";
      };
    }

    {
      name = "magnet_uri___magnet_uri_5.2.4.tgz";
      path = fetchurl {
        name = "magnet_uri___magnet_uri_5.2.4.tgz";
        url  = "https://registry.yarnpkg.com/magnet-uri/-/magnet-uri-5.2.4.tgz";
        sha1 = "7afe5b736af04445aff744c93a890a3710077688";
      };
    }

    {
      name = "maildev___maildev_1.1.0.tgz";
      path = fetchurl {
        name = "maildev___maildev_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/maildev/-/maildev-1.1.0.tgz";
        sha1 = "8b6977f244373be00112c942ae15dd32f5c225c9";
      };
    }

    {
      name = "mailparser_mit___mailparser_mit_1.0.0.tgz";
      path = fetchurl {
        name = "mailparser_mit___mailparser_mit_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/mailparser-mit/-/mailparser-mit-1.0.0.tgz";
        sha1 = "19df8436c2a02e1d34a03ec518a2eb065e0a94a4";
      };
    }

    {
      name = "make_dir___make_dir_1.3.0.tgz";
      path = fetchurl {
        name = "make_dir___make_dir_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/make-dir/-/make-dir-1.3.0.tgz";
        sha1 = "79c1033b80515bd6d24ec9933e860ca75ee27f0c";
      };
    }

    {
      name = "make_error___make_error_1.3.5.tgz";
      path = fetchurl {
        name = "make_error___make_error_1.3.5.tgz";
        url  = "https://registry.yarnpkg.com/make-error/-/make-error-1.3.5.tgz";
        sha1 = "efe4e81f6db28cadd605c70f29c831b58ef776c8";
      };
    }

    {
      name = "marked_man___marked_man_0.7.0.tgz";
      path = fetchurl {
        name = "marked_man___marked_man_0.7.0.tgz";
        url  = "https://registry.yarnpkg.com/marked-man/-/marked-man-0.7.0.tgz";
        sha1 = "220ba01d275d16f1a98e4e7fc3c5eac0630c68e4";
      };
    }

    {
      name = "marked___marked_0.8.0.tgz";
      path = fetchurl {
        name = "marked___marked_0.8.0.tgz";
        url  = "https://registry.yarnpkg.com/marked/-/marked-0.8.0.tgz";
        sha1 = "ec5c0c9b93878dc52dd54be8d0e524097bd81a99";
      };
    }

    {
      name = "md5___md5_2.2.1.tgz";
      path = fetchurl {
        name = "md5___md5_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/md5/-/md5-2.2.1.tgz";
        sha1 = "53ab38d5fe3c8891ba465329ea23fac0540126f9";
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
      name = "mediasource___mediasource_2.3.0.tgz";
      path = fetchurl {
        name = "mediasource___mediasource_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/mediasource/-/mediasource-2.3.0.tgz";
        sha1 = "4c7b49e7ea4fb88f1cc181d8fcf0d94649271dc6";
      };
    }

    {
      name = "memoizee___memoizee_0.4.14.tgz";
      path = fetchurl {
        name = "memoizee___memoizee_0.4.14.tgz";
        url  = "https://registry.yarnpkg.com/memoizee/-/memoizee-0.4.14.tgz";
        sha1 = "07a00f204699f9a95c2d9e77218271c7cd610d57";
      };
    }

    {
      name = "memory_chunk_store___memory_chunk_store_1.3.0.tgz";
      path = fetchurl {
        name = "memory_chunk_store___memory_chunk_store_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/memory-chunk-store/-/memory-chunk-store-1.3.0.tgz";
        sha1 = "ae99e7e3b58b52db43d49d94722930d39459d0c4";
      };
    }

    {
      name = "merge_descriptors___merge_descriptors_1.0.1.tgz";
      path = fetchurl {
        name = "merge_descriptors___merge_descriptors_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/merge-descriptors/-/merge-descriptors-1.0.1.tgz";
        sha1 = "b00aaa556dd8b44568150ec9d1b953f3f90cbb61";
      };
    }

    {
      name = "merge_stream___merge_stream_2.0.0.tgz";
      path = fetchurl {
        name = "merge_stream___merge_stream_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz";
        sha1 = "52823629a14dd00c9770fb6ad47dc6310f2c1f60";
      };
    }

    {
      name = "merge2___merge2_1.3.0.tgz";
      path = fetchurl {
        name = "merge2___merge2_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/merge2/-/merge2-1.3.0.tgz";
        sha1 = "5b366ee83b2f1582c48f87e47cf1a9352103ca81";
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
      name = "micromatch___micromatch_4.0.2.tgz";
      path = fetchurl {
        name = "micromatch___micromatch_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.2.tgz";
        sha1 = "4fcb0999bf9fbc2fcbdd212f6d629b9a56c39259";
      };
    }

    {
      name = "mime_db___mime_db_1.43.0.tgz";
      path = fetchurl {
        name = "mime_db___mime_db_1.43.0.tgz";
        url  = "https://registry.yarnpkg.com/mime-db/-/mime-db-1.43.0.tgz";
        sha1 = "0a12e0502650e473d735535050e7c8f4eb4fae58";
      };
    }

    {
      name = "mime_types___mime_types_2.1.26.tgz";
      path = fetchurl {
        name = "mime_types___mime_types_2.1.26.tgz";
        url  = "https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.26.tgz";
        sha1 = "9c921fc09b7e149a65dfdc0da4d20997200b0a06";
      };
    }

    {
      name = "mime___mime_1.6.0.tgz";
      path = fetchurl {
        name = "mime___mime_1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/mime/-/mime-1.6.0.tgz";
        sha1 = "32cd9e5c64553bd58d19a568af452acff04981b1";
      };
    }

    {
      name = "mime___mime_2.4.4.tgz";
      path = fetchurl {
        name = "mime___mime_2.4.4.tgz";
        url  = "https://registry.yarnpkg.com/mime/-/mime-2.4.4.tgz";
        sha1 = "bd7b91135fc6b01cde3e9bae33d659b63d8857e5";
      };
    }

    {
      name = "mimic_fn___mimic_fn_1.2.0.tgz";
      path = fetchurl {
        name = "mimic_fn___mimic_fn_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-1.2.0.tgz";
        sha1 = "820c86a39334640e99516928bd03fca88057d022";
      };
    }

    {
      name = "mimic_fn___mimic_fn_2.1.0.tgz";
      path = fetchurl {
        name = "mimic_fn___mimic_fn_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz";
        sha1 = "7ed2c2ccccaf84d3ffcb7a69b57711fc2083401b";
      };
    }

    {
      name = "mimic_response___mimic_response_2.0.0.tgz";
      path = fetchurl {
        name = "mimic_response___mimic_response_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/mimic-response/-/mimic-response-2.0.0.tgz";
        sha1 = "996a51c60adf12cb8a87d7fb8ef24c2f3d5ebb46";
      };
    }

    {
      name = "minimatch___minimatch_3.0.4.tgz";
      path = fetchurl {
        name = "minimatch___minimatch_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz";
        sha1 = "5166e286457f03306064be5497e8dbb0c3d32083";
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
      name = "minimist___minimist_1.2.0.tgz";
      path = fetchurl {
        name = "minimist___minimist_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-1.2.0.tgz";
        sha1 = "a35008b20f41383eec1fb914f4cd5df79a264284";
      };
    }

    {
      name = "minipass___minipass_2.9.0.tgz";
      path = fetchurl {
        name = "minipass___minipass_2.9.0.tgz";
        url  = "https://registry.yarnpkg.com/minipass/-/minipass-2.9.0.tgz";
        sha1 = "e713762e7d3e32fed803115cf93e04bca9fcc9a6";
      };
    }

    {
      name = "minipass___minipass_3.1.1.tgz";
      path = fetchurl {
        name = "minipass___minipass_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/minipass/-/minipass-3.1.1.tgz";
        sha1 = "7607ce778472a185ad6d89082aa2070f79cedcd5";
      };
    }

    {
      name = "minizlib___minizlib_1.3.3.tgz";
      path = fetchurl {
        name = "minizlib___minizlib_1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/minizlib/-/minizlib-1.3.3.tgz";
        sha1 = "2290de96818a34c29551c8a8d301216bd65a861d";
      };
    }

    {
      name = "minizlib___minizlib_2.1.0.tgz";
      path = fetchurl {
        name = "minizlib___minizlib_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/minizlib/-/minizlib-2.1.0.tgz";
        sha1 = "fd52c645301ef09a63a2c209697c294c6ce02cf3";
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
      name = "mocha_parallel_tests___mocha_parallel_tests_2.2.2.tgz";
      path = fetchurl {
        name = "mocha_parallel_tests___mocha_parallel_tests_2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/mocha-parallel-tests/-/mocha-parallel-tests-2.2.2.tgz";
        sha1 = "4a45dcf77961def902eb8fec387268c0431e61ea";
      };
    }

    {
      name = "mocha___mocha_7.0.0.tgz";
      path = fetchurl {
        name = "mocha___mocha_7.0.0.tgz";
        url  = "https://registry.yarnpkg.com/mocha/-/mocha-7.0.0.tgz";
        sha1 = "c60d14bf3de9601f549b3ff5be657eb8381c54bf";
      };
    }

    {
      name = "moment_timezone___moment_timezone_0.5.27.tgz";
      path = fetchurl {
        name = "moment_timezone___moment_timezone_0.5.27.tgz";
        url  = "https://registry.yarnpkg.com/moment-timezone/-/moment-timezone-0.5.27.tgz";
        sha1 = "73adec8139b6fe30452e78f210f27b1f346b8877";
      };
    }

    {
      name = "moment___moment_2.24.0.tgz";
      path = fetchurl {
        name = "moment___moment_2.24.0.tgz";
        url  = "https://registry.yarnpkg.com/moment/-/moment-2.24.0.tgz";
        sha1 = "0d055d53f5052aa653c9f6eb68bb5d12bf5c2b5b";
      };
    }

    {
      name = "morgan___morgan_1.9.1.tgz";
      path = fetchurl {
        name = "morgan___morgan_1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/morgan/-/morgan-1.9.1.tgz";
        sha1 = "0a8d16734a1d9afbc824b99df87e738e58e2da59";
      };
    }

    {
      name = "mp4_box_encoding___mp4_box_encoding_1.4.1.tgz";
      path = fetchurl {
        name = "mp4_box_encoding___mp4_box_encoding_1.4.1.tgz";
        url  = "https://registry.yarnpkg.com/mp4-box-encoding/-/mp4-box-encoding-1.4.1.tgz";
        sha1 = "19b31804c896bc1adf1c21b497bcf951aa3b9098";
      };
    }

    {
      name = "mp4_stream___mp4_stream_3.1.0.tgz";
      path = fetchurl {
        name = "mp4_stream___mp4_stream_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/mp4-stream/-/mp4-stream-3.1.0.tgz";
        sha1 = "7a0800b50759b28fa4757cdb4ab6a49517543cd7";
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
      name = "ms___ms_2.1.2.tgz";
      path = fetchurl {
        name = "ms___ms_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz";
        sha1 = "d09d1f357b443f493382a8eb3ccd183872ae6009";
      };
    }

    {
      name = "multer___multer_1.4.2.tgz";
      path = fetchurl {
        name = "multer___multer_1.4.2.tgz";
        url  = "https://registry.yarnpkg.com/multer/-/multer-1.4.2.tgz";
        sha1 = "2f1f4d12dbaeeba74cb37e623f234bf4d3d2057a";
      };
    }

    {
      name = "multistream___multistream_4.0.0.tgz";
      path = fetchurl {
        name = "multistream___multistream_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/multistream/-/multistream-4.0.0.tgz";
        sha1 = "c771b6d17d169138b6abcb15f0061170e3c09cea";
      };
    }

    {
      name = "mute_stream___mute_stream_0.0.8.tgz";
      path = fetchurl {
        name = "mute_stream___mute_stream_0.0.8.tgz";
        url  = "https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.8.tgz";
        sha1 = "1630c42b2251ff81e2a283de96a5497ea92e5e0d";
      };
    }

    {
      name = "mv___mv_2.1.1.tgz";
      path = fetchurl {
        name = "mv___mv_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/mv/-/mv-2.1.1.tgz";
        sha1 = "ae6ce0d6f6d5e0a4f7d893798d03c1ea9559b6a2";
      };
    }

    {
      name = "nan___nan_2.14.0.tgz";
      path = fetchurl {
        name = "nan___nan_2.14.0.tgz";
        url  = "https://registry.yarnpkg.com/nan/-/nan-2.14.0.tgz";
        sha1 = "7818f722027b2459a86f0295d434d1fc2336c52c";
      };
    }

    {
      name = "napi_build_utils___napi_build_utils_1.0.1.tgz";
      path = fetchurl {
        name = "napi_build_utils___napi_build_utils_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/napi-build-utils/-/napi-build-utils-1.0.1.tgz";
        sha1 = "1381a0f92c39d66bf19852e7873432fc2123e508";
      };
    }

    {
      name = "ncp___ncp_1.0.1.tgz";
      path = fetchurl {
        name = "ncp___ncp_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ncp/-/ncp-1.0.1.tgz";
        sha1 = "d15367e5cb87432ba117d2bf80fdf45aecfb4246";
      };
    }

    {
      name = "ncp___ncp_2.0.0.tgz";
      path = fetchurl {
        name = "ncp___ncp_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ncp/-/ncp-2.0.0.tgz";
        sha1 = "195a21d6c46e361d2fb1281ba38b91e9df7bdbb3";
      };
    }

    {
      name = "needle___needle_2.4.0.tgz";
      path = fetchurl {
        name = "needle___needle_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/needle/-/needle-2.4.0.tgz";
        sha1 = "6833e74975c444642590e15a750288c5f939b57c";
      };
    }

    {
      name = "negotiator___negotiator_0.6.2.tgz";
      path = fetchurl {
        name = "negotiator___negotiator_0.6.2.tgz";
        url  = "https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.2.tgz";
        sha1 = "feacf7ccf525a77ae9634436a64883ffeca346fb";
      };
    }

    {
      name = "netmask___netmask_1.0.6.tgz";
      path = fetchurl {
        name = "netmask___netmask_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/netmask/-/netmask-1.0.6.tgz";
        sha1 = "20297e89d86f6f6400f250d9f4f6b4c1945fcd35";
      };
    }

    {
      name = "next_event___next_event_1.0.0.tgz";
      path = fetchurl {
        name = "next_event___next_event_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/next-event/-/next-event-1.0.0.tgz";
        sha1 = "e7778acde2e55802e0ad1879c39cf6f75eda61d8";
      };
    }

    {
      name = "next_tick___next_tick_1.0.0.tgz";
      path = fetchurl {
        name = "next_tick___next_tick_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/next-tick/-/next-tick-1.0.0.tgz";
        sha1 = "ca86d1fe8828169b0120208e3dc8424b9db8342c";
      };
    }

    {
      name = "nocache___nocache_2.1.0.tgz";
      path = fetchurl {
        name = "nocache___nocache_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/nocache/-/nocache-2.1.0.tgz";
        sha1 = "120c9ffec43b5729b1d5de88cd71aa75a0ba491f";
      };
    }

    {
      name = "node_abi___node_abi_2.13.0.tgz";
      path = fetchurl {
        name = "node_abi___node_abi_2.13.0.tgz";
        url  = "https://registry.yarnpkg.com/node-abi/-/node-abi-2.13.0.tgz";
        sha1 = "e2f2ec444d0aca3ea1b3874b6de41d1665828f63";
      };
    }

    {
      name = "node_environment_flags___node_environment_flags_1.0.6.tgz";
      path = fetchurl {
        name = "node_environment_flags___node_environment_flags_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/node-environment-flags/-/node-environment-flags-1.0.6.tgz";
        sha1 = "a30ac13621f6f7d674260a54dede048c3982c088";
      };
    }

    {
      name = "node_forge___node_forge_0.8.5.tgz";
      path = fetchurl {
        name = "node_forge___node_forge_0.8.5.tgz";
        url  = "https://registry.yarnpkg.com/node-forge/-/node-forge-0.8.5.tgz";
        sha1 = "57906f07614dc72762c84cef442f427c0e1b86ee";
      };
    }

    {
      name = "node_gyp_build___node_gyp_build_3.7.0.tgz";
      path = fetchurl {
        name = "node_gyp_build___node_gyp_build_3.7.0.tgz";
        url  = "https://registry.yarnpkg.com/node-gyp-build/-/node-gyp-build-3.7.0.tgz";
        sha1 = "daa77a4f547b9aed3e2aac779eaf151afd60ec8d";
      };
    }

    {
      name = "node_pre_gyp___node_pre_gyp_0.13.0.tgz";
      path = fetchurl {
        name = "node_pre_gyp___node_pre_gyp_0.13.0.tgz";
        url  = "https://registry.yarnpkg.com/node-pre-gyp/-/node-pre-gyp-0.13.0.tgz";
        sha1 = "df9ab7b68dd6498137717838e4f92a33fc9daa42";
      };
    }

    {
      name = "node_pre_gyp___node_pre_gyp_0.11.0.tgz";
      path = fetchurl {
        name = "node_pre_gyp___node_pre_gyp_0.11.0.tgz";
        url  = "https://registry.yarnpkg.com/node-pre-gyp/-/node-pre-gyp-0.11.0.tgz";
        sha1 = "db1f33215272f692cd38f03238e3e9b47c5dd054";
      };
    }

    {
      name = "nodemailer___nodemailer_5.0.0.tgz";
      path = fetchurl {
        name = "nodemailer___nodemailer_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/nodemailer/-/nodemailer-5.0.0.tgz";
        sha1 = "bcb409eca613114e85de42646d0ce7f1fa70b716";
      };
    }

    {
      name = "nodemailer___nodemailer_3.1.8.tgz";
      path = fetchurl {
        name = "nodemailer___nodemailer_3.1.8.tgz";
        url  = "https://registry.yarnpkg.com/nodemailer/-/nodemailer-3.1.8.tgz";
        sha1 = "febfaccb4bd273678473a309c6cb4b4a2f3c48e3";
      };
    }

    {
      name = "nodemailer___nodemailer_6.4.2.tgz";
      path = fetchurl {
        name = "nodemailer___nodemailer_6.4.2.tgz";
        url  = "https://registry.yarnpkg.com/nodemailer/-/nodemailer-6.4.2.tgz";
        sha1 = "7147550e32cdc37453380ab78d2074533966090a";
      };
    }

    {
      name = "nodemon___nodemon_2.0.2.tgz";
      path = fetchurl {
        name = "nodemon___nodemon_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/nodemon/-/nodemon-2.0.2.tgz";
        sha1 = "9c7efeaaf9b8259295a97e5d4585ba8f0cbe50b0";
      };
    }

    {
      name = "noop_logger___noop_logger_0.1.1.tgz";
      path = fetchurl {
        name = "noop_logger___noop_logger_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/noop-logger/-/noop-logger-0.1.1.tgz";
        sha1 = "94a2b1633c4f1317553007d8966fd0e841b6a4c2";
      };
    }

    {
      name = "nopt___nopt_4.0.1.tgz";
      path = fetchurl {
        name = "nopt___nopt_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/nopt/-/nopt-4.0.1.tgz";
        sha1 = "d0d4685afd5415193c8c7505602d0d17cd64474d";
      };
    }

    {
      name = "nopt___nopt_1.0.10.tgz";
      path = fetchurl {
        name = "nopt___nopt_1.0.10.tgz";
        url  = "https://registry.yarnpkg.com/nopt/-/nopt-1.0.10.tgz";
        sha1 = "6ddd21bd2a31417b92727dd585f8a6f37608ebee";
      };
    }

    {
      name = "normalize_package_data___normalize_package_data_2.5.0.tgz";
      path = fetchurl {
        name = "normalize_package_data___normalize_package_data_2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz";
        sha1 = "e66db1838b200c1dfc233225d12cb36520e234a8";
      };
    }

    {
      name = "normalize_path___normalize_path_3.0.0.tgz";
      path = fetchurl {
        name = "normalize_path___normalize_path_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz";
        sha1 = "0dcd69ff23a1c9b11fd0978316644a0388216a65";
      };
    }

    {
      name = "npm_bundled___npm_bundled_1.1.1.tgz";
      path = fetchurl {
        name = "npm_bundled___npm_bundled_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/npm-bundled/-/npm-bundled-1.1.1.tgz";
        sha1 = "1edd570865a94cdb1bc8220775e29466c9fb234b";
      };
    }

    {
      name = "npm_normalize_package_bin___npm_normalize_package_bin_1.0.1.tgz";
      path = fetchurl {
        name = "npm_normalize_package_bin___npm_normalize_package_bin_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/npm-normalize-package-bin/-/npm-normalize-package-bin-1.0.1.tgz";
        sha1 = "6e79a41f23fd235c0623218228da7d9c23b8f6e2";
      };
    }

    {
      name = "npm_packlist___npm_packlist_1.4.7.tgz";
      path = fetchurl {
        name = "npm_packlist___npm_packlist_1.4.7.tgz";
        url  = "https://registry.yarnpkg.com/npm-packlist/-/npm-packlist-1.4.7.tgz";
        sha1 = "9e954365a06b80b18111ea900945af4f88ed4848";
      };
    }

    {
      name = "npm_run_path___npm_run_path_2.0.2.tgz";
      path = fetchurl {
        name = "npm_run_path___npm_run_path_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-2.0.2.tgz";
        sha1 = "35a9232dfa35d7067b4cb2ddf2357b1871536c5f";
      };
    }

    {
      name = "npm_run_path___npm_run_path_3.1.0.tgz";
      path = fetchurl {
        name = "npm_run_path___npm_run_path_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-3.1.0.tgz";
        sha1 = "7f91be317f6a466efed3c9f2980ad8a4ee8b0fa5";
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
      name = "npmlog___npmlog_4.1.2.tgz";
      path = fetchurl {
        name = "npmlog___npmlog_4.1.2.tgz";
        url  = "https://registry.yarnpkg.com/npmlog/-/npmlog-4.1.2.tgz";
        sha1 = "08a7f2a8bf734604779a9efa4ad5cc717abb954b";
      };
    }

    {
      name = "number_is_nan___number_is_nan_1.0.1.tgz";
      path = fetchurl {
        name = "number_is_nan___number_is_nan_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz";
        sha1 = "097b602b53422a522c1afb8790318336941a011d";
      };
    }

    {
      name = "oauth_sign___oauth_sign_0.9.0.tgz";
      path = fetchurl {
        name = "oauth_sign___oauth_sign_0.9.0.tgz";
        url  = "https://registry.yarnpkg.com/oauth-sign/-/oauth-sign-0.9.0.tgz";
        sha1 = "47a7b016baa68b5fa0ecf3dee08a85c679ac6455";
      };
    }

    {
      name = "oauth2_server___oauth2_server_3.0.0.tgz";
      path = fetchurl {
        name = "oauth2_server___oauth2_server_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/oauth2-server/-/oauth2-server-3.0.0.tgz";
        sha1 = "c46276b74c3d28634d59ee981f76b58a6459cc28";
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
      name = "object_component___object_component_0.0.3.tgz";
      path = fetchurl {
        name = "object_component___object_component_0.0.3.tgz";
        url  = "https://registry.yarnpkg.com/object-component/-/object-component-0.0.3.tgz";
        sha1 = "f0c69aa50efc95b866c186f400a33769cb2f1291";
      };
    }

    {
      name = "object_inspect___object_inspect_1.7.0.tgz";
      path = fetchurl {
        name = "object_inspect___object_inspect_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.7.0.tgz";
        sha1 = "f4f6bd181ad77f006b5ece60bd0b6f398ff74a67";
      };
    }

    {
      name = "object_keys___object_keys_1.1.1.tgz";
      path = fetchurl {
        name = "object_keys___object_keys_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz";
        sha1 = "1c47f272df277f3b1daf061677d9c82e2322c60e";
      };
    }

    {
      name = "object.assign___object.assign_4.1.0.tgz";
      path = fetchurl {
        name = "object.assign___object.assign_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.0.tgz";
        sha1 = "968bf1100d7956bb3ca086f006f846b3bc4008da";
      };
    }

    {
      name = "object.getownpropertydescriptors___object.getownpropertydescriptors_2.1.0.tgz";
      path = fetchurl {
        name = "object.getownpropertydescriptors___object.getownpropertydescriptors_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/object.getownpropertydescriptors/-/object.getownpropertydescriptors-2.1.0.tgz";
        sha1 = "369bf1f9592d8ab89d712dced5cb81c7c5352649";
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
      name = "on_headers___on_headers_1.0.2.tgz";
      path = fetchurl {
        name = "on_headers___on_headers_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/on-headers/-/on-headers-1.0.2.tgz";
        sha1 = "772b0ae6aaa525c399e489adfad90c403eb3c28f";
      };
    }

    {
      name = "once___once_1.4.0.tgz";
      path = fetchurl {
        name = "once___once_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/once/-/once-1.4.0.tgz";
        sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
      };
    }

    {
      name = "one_time___one_time_0.0.4.tgz";
      path = fetchurl {
        name = "one_time___one_time_0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/one-time/-/one-time-0.0.4.tgz";
        sha1 = "f8cdf77884826fe4dff93e3a9cc37b1e4480742e";
      };
    }

    {
      name = "onetime___onetime_2.0.1.tgz";
      path = fetchurl {
        name = "onetime___onetime_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/onetime/-/onetime-2.0.1.tgz";
        sha1 = "067428230fd67443b2794b22bba528b6867962d4";
      };
    }

    {
      name = "onetime___onetime_5.1.0.tgz";
      path = fetchurl {
        name = "onetime___onetime_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/onetime/-/onetime-5.1.0.tgz";
        sha1 = "fff0f3c91617fe62bb50189636e99ac8a6df7be5";
      };
    }

    {
      name = "ono___ono_6.0.1.tgz";
      path = fetchurl {
        name = "ono___ono_6.0.1.tgz";
        url  = "https://registry.yarnpkg.com/ono/-/ono-6.0.1.tgz";
        sha1 = "1bc14ffb8af1e5db3f7397f75b88e4a2d64bbd71";
      };
    }

    {
      name = "openapi_schemas___openapi_schemas_1.0.3.tgz";
      path = fetchurl {
        name = "openapi_schemas___openapi_schemas_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/openapi-schemas/-/openapi-schemas-1.0.3.tgz";
        sha1 = "0fa2f19e44ce8a1cdab9c9f616df4babe1aa026b";
      };
    }

    {
      name = "openapi_types___openapi_types_1.3.5.tgz";
      path = fetchurl {
        name = "openapi_types___openapi_types_1.3.5.tgz";
        url  = "https://registry.yarnpkg.com/openapi-types/-/openapi-types-1.3.5.tgz";
        sha1 = "6718cfbc857fe6c6f1471f65b32bdebb9c10ce40";
      };
    }

    {
      name = "opn___opn_6.0.0.tgz";
      path = fetchurl {
        name = "opn___opn_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/opn/-/opn-6.0.0.tgz";
        sha1 = "3c5b0db676d5f97da1233d1ed42d182bc5a27d2d";
      };
    }

    {
      name = "os_homedir___os_homedir_1.0.2.tgz";
      path = fetchurl {
        name = "os_homedir___os_homedir_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/os-homedir/-/os-homedir-1.0.2.tgz";
        sha1 = "ffbc4988336e0e833de0c168c7ef152121aa7fb3";
      };
    }

    {
      name = "os_tmpdir___os_tmpdir_1.0.2.tgz";
      path = fetchurl {
        name = "os_tmpdir___os_tmpdir_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz";
        sha1 = "bbe67406c79aa85c5cfec766fe5734555dfa1274";
      };
    }

    {
      name = "osenv___osenv_0.1.5.tgz";
      path = fetchurl {
        name = "osenv___osenv_0.1.5.tgz";
        url  = "https://registry.yarnpkg.com/osenv/-/osenv-0.1.5.tgz";
        sha1 = "85cdfafaeb28e8677f416e287592b5f3f49ea410";
      };
    }

    {
      name = "p_finally___p_finally_1.0.0.tgz";
      path = fetchurl {
        name = "p_finally___p_finally_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-finally/-/p-finally-1.0.0.tgz";
        sha1 = "3fbcfb15b899a44123b34b6dcc18b724336a2cae";
      };
    }

    {
      name = "p_finally___p_finally_2.0.1.tgz";
      path = fetchurl {
        name = "p_finally___p_finally_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/p-finally/-/p-finally-2.0.1.tgz";
        sha1 = "bd6fcaa9c559a096b680806f4d657b3f0f240561";
      };
    }

    {
      name = "p_limit___p_limit_2.2.2.tgz";
      path = fetchurl {
        name = "p_limit___p_limit_2.2.2.tgz";
        url  = "https://registry.yarnpkg.com/p-limit/-/p-limit-2.2.2.tgz";
        sha1 = "61279b67721f5287aa1c13a9a7fbbc48c9291b1e";
      };
    }

    {
      name = "p_locate___p_locate_3.0.0.tgz";
      path = fetchurl {
        name = "p_locate___p_locate_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-locate/-/p-locate-3.0.0.tgz";
        sha1 = "322d69a05c0264b25997d9f40cd8a891ab0064a4";
      };
    }

    {
      name = "p_locate___p_locate_4.1.0.tgz";
      path = fetchurl {
        name = "p_locate___p_locate_4.1.0.tgz";
        url  = "https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz";
        sha1 = "a3428bb7088b3a60292f66919278b7c297ad4f07";
      };
    }

    {
      name = "p_map___p_map_2.1.0.tgz";
      path = fetchurl {
        name = "p_map___p_map_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/p-map/-/p-map-2.1.0.tgz";
        sha1 = "310928feef9c9ecc65b68b17693018a665cea175";
      };
    }

    {
      name = "p_map___p_map_3.0.0.tgz";
      path = fetchurl {
        name = "p_map___p_map_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-map/-/p-map-3.0.0.tgz";
        sha1 = "d704d9af8a2ba684e2600d9a215983d4141a979d";
      };
    }

    {
      name = "p_timeout___p_timeout_3.2.0.tgz";
      path = fetchurl {
        name = "p_timeout___p_timeout_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/p-timeout/-/p-timeout-3.2.0.tgz";
        sha1 = "c7e17abc971d2a7962ef83626b35d635acf23dfe";
      };
    }

    {
      name = "p_try___p_try_2.2.0.tgz";
      path = fetchurl {
        name = "p_try___p_try_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz";
        sha1 = "cb2868540e313d61de58fafbe35ce9004d5540e6";
      };
    }

    {
      name = "package_json_versionify___package_json_versionify_1.0.4.tgz";
      path = fetchurl {
        name = "package_json_versionify___package_json_versionify_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/package-json-versionify/-/package-json-versionify-1.0.4.tgz";
        sha1 = "5860587a944873a6b7e6d26e8e51ffb22315bf17";
      };
    }

    {
      name = "package_json___package_json_4.0.1.tgz";
      path = fetchurl {
        name = "package_json___package_json_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/package-json/-/package-json-4.0.1.tgz";
        sha1 = "8869a0401253661c4c4ca3da6c2121ed555f5eed";
      };
    }

    {
      name = "packet_reader___packet_reader_1.0.0.tgz";
      path = fetchurl {
        name = "packet_reader___packet_reader_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/packet-reader/-/packet-reader-1.0.0.tgz";
        sha1 = "9238e5480dedabacfe1fe3f2771063f164157d74";
      };
    }

    {
      name = "parse_json___parse_json_4.0.0.tgz";
      path = fetchurl {
        name = "parse_json___parse_json_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/parse-json/-/parse-json-4.0.0.tgz";
        sha1 = "be35f5425be1f7f6c747184f98a788cb99477ee0";
      };
    }

    {
      name = "parse_numeric_range___parse_numeric_range_0.0.2.tgz";
      path = fetchurl {
        name = "parse_numeric_range___parse_numeric_range_0.0.2.tgz";
        url  = "https://registry.yarnpkg.com/parse-numeric-range/-/parse-numeric-range-0.0.2.tgz";
        sha1 = "b4f09d413c7adbcd987f6e9233c7b4b210c938e4";
      };
    }

    {
      name = "parse_torrent___parse_torrent_7.0.1.tgz";
      path = fetchurl {
        name = "parse_torrent___parse_torrent_7.0.1.tgz";
        url  = "https://registry.yarnpkg.com/parse-torrent/-/parse-torrent-7.0.1.tgz";
        sha1 = "669c51a95363550055c7de0957741d6a05575daf";
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
      name = "parseurl___parseurl_1.3.3.tgz";
      path = fetchurl {
        name = "parseurl___parseurl_1.3.3.tgz";
        url  = "https://registry.yarnpkg.com/parseurl/-/parseurl-1.3.3.tgz";
        sha1 = "9da19e7bee8d12dff0513ed5b76957793bc2e8d4";
      };
    }

    {
      name = "password_generator___password_generator_2.2.3.tgz";
      path = fetchurl {
        name = "password_generator___password_generator_2.2.3.tgz";
        url  = "https://registry.yarnpkg.com/password-generator/-/password-generator-2.2.3.tgz";
        sha1 = "e94149f1e4eb58fb3565e8d7b692034ec1ebdbc8";
      };
    }

    {
      name = "path_exists___path_exists_3.0.0.tgz";
      path = fetchurl {
        name = "path_exists___path_exists_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz";
        sha1 = "ce0ebeaa5f78cb18925ea7d810d7b59b010fd515";
      };
    }

    {
      name = "path_exists___path_exists_4.0.0.tgz";
      path = fetchurl {
        name = "path_exists___path_exists_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz";
        sha1 = "513bdbe2d3b95d7762e8c1137efa195c6c61b5b3";
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
      name = "path_is_inside___path_is_inside_1.0.2.tgz";
      path = fetchurl {
        name = "path_is_inside___path_is_inside_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/path-is-inside/-/path-is-inside-1.0.2.tgz";
        sha1 = "365417dede44430d1c11af61027facf074bdfc53";
      };
    }

    {
      name = "path_key___path_key_2.0.1.tgz";
      path = fetchurl {
        name = "path_key___path_key_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz";
        sha1 = "411cadb574c5a140d3a4b1910d40d80cc9f40b40";
      };
    }

    {
      name = "path_key___path_key_3.1.1.tgz";
      path = fetchurl {
        name = "path_key___path_key_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz";
        sha1 = "581f6ade658cbba65a0d3380de7753295054f375";
      };
    }

    {
      name = "path_parse___path_parse_1.0.6.tgz";
      path = fetchurl {
        name = "path_parse___path_parse_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.6.tgz";
        sha1 = "d62dbb5679405d72c4737ec58600e9ddcf06d24c";
      };
    }

    {
      name = "path_to_regexp___path_to_regexp_0.1.7.tgz";
      path = fetchurl {
        name = "path_to_regexp___path_to_regexp_0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-0.1.7.tgz";
        sha1 = "df604178005f522f15eb4490e7247a1bfaa67f8c";
      };
    }

    {
      name = "path_type___path_type_4.0.0.tgz";
      path = fetchurl {
        name = "path_type___path_type_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz";
        sha1 = "84ed01c0a7ba380afe09d90a8c180dcd9d03043b";
      };
    }

    {
      name = "pathval___pathval_1.1.0.tgz";
      path = fetchurl {
        name = "pathval___pathval_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/pathval/-/pathval-1.1.0.tgz";
        sha1 = "b942e6d4bde653005ef6b71361def8727d0645e0";
      };
    }

    {
      name = "peek_stream___peek_stream_1.1.3.tgz";
      path = fetchurl {
        name = "peek_stream___peek_stream_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/peek-stream/-/peek-stream-1.1.3.tgz";
        sha1 = "3b35d84b7ccbbd262fff31dc10da56856ead6d67";
      };
    }

    {
      name = "pem___pem_1.14.3.tgz";
      path = fetchurl {
        name = "pem___pem_1.14.3.tgz";
        url  = "https://registry.yarnpkg.com/pem/-/pem-1.14.3.tgz";
        sha1 = "347e5a5c194a5f7612b88083e45042fcc4fb4901";
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
      name = "pfeed___pfeed_1.1.11.tgz";
      path = fetchurl {
        name = "pfeed___pfeed_1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/pfeed/-/pfeed-1.1.11.tgz";
        sha1 = "a52f6b18aa01dfd3c8ff3c7189c456dc1b66d28f";
      };
    }

    {
      name = "pg_connection_string___pg_connection_string_0.1.3.tgz";
      path = fetchurl {
        name = "pg_connection_string___pg_connection_string_0.1.3.tgz";
        url  = "https://registry.yarnpkg.com/pg-connection-string/-/pg-connection-string-0.1.3.tgz";
        sha1 = "da1847b20940e42ee1492beaf65d49d91b245df7";
      };
    }

    {
      name = "pg_int8___pg_int8_1.0.1.tgz";
      path = fetchurl {
        name = "pg_int8___pg_int8_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/pg-int8/-/pg-int8-1.0.1.tgz";
        sha1 = "943bd463bf5b71b4170115f80f8efc9a0c0eb78c";
      };
    }

    {
      name = "pg_packet_stream___pg_packet_stream_1.1.0.tgz";
      path = fetchurl {
        name = "pg_packet_stream___pg_packet_stream_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/pg-packet-stream/-/pg-packet-stream-1.1.0.tgz";
        sha1 = "e45c3ae678b901a2873af1e17b92d787962ef914";
      };
    }

    {
      name = "pg_pool___pg_pool_2.0.9.tgz";
      path = fetchurl {
        name = "pg_pool___pg_pool_2.0.9.tgz";
        url  = "https://registry.yarnpkg.com/pg-pool/-/pg-pool-2.0.9.tgz";
        sha1 = "7ed69a27e204f99e9804a851404db6aa908a6dea";
      };
    }

    {
      name = "pg_types___pg_types_2.2.0.tgz";
      path = fetchurl {
        name = "pg_types___pg_types_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/pg-types/-/pg-types-2.2.0.tgz";
        sha1 = "2d0250d636454f7cfa3b6ae0382fdfa8063254a3";
      };
    }

    {
      name = "pg___pg_7.17.0.tgz";
      path = fetchurl {
        name = "pg___pg_7.17.0.tgz";
        url  = "https://registry.yarnpkg.com/pg/-/pg-7.17.0.tgz";
        sha1 = "1fcf82238dcbebea63e192c944345c25c86992fc";
      };
    }

    {
      name = "pgpass___pgpass_1.0.2.tgz";
      path = fetchurl {
        name = "pgpass___pgpass_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pgpass/-/pgpass-1.0.2.tgz";
        sha1 = "2a7bb41b6065b67907e91da1b07c1847c877b306";
      };
    }

    {
      name = "picomatch___picomatch_2.2.1.tgz";
      path = fetchurl {
        name = "picomatch___picomatch_2.2.1.tgz";
        url  = "https://registry.yarnpkg.com/picomatch/-/picomatch-2.2.1.tgz";
        sha1 = "21bac888b6ed8601f831ce7816e335bc779f0a4a";
      };
    }

    {
      name = "piece_length___piece_length_2.0.1.tgz";
      path = fetchurl {
        name = "piece_length___piece_length_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/piece-length/-/piece-length-2.0.1.tgz";
        sha1 = "dbed4e78976955f34466d0a65304d0cb21914ac9";
      };
    }

    {
      name = "pify___pify_3.0.0.tgz";
      path = fetchurl {
        name = "pify___pify_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz";
        sha1 = "e5a4acd2c101fdf3d9a4d07f0dbc4db49dd28176";
      };
    }

    {
      name = "pkginfo___pkginfo_0.3.1.tgz";
      path = fetchurl {
        name = "pkginfo___pkginfo_0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/pkginfo/-/pkginfo-0.3.1.tgz";
        sha1 = "5b29f6a81f70717142e09e765bbeab97b4f81e21";
      };
    }

    {
      name = "pkginfo___pkginfo_0.4.1.tgz";
      path = fetchurl {
        name = "pkginfo___pkginfo_0.4.1.tgz";
        url  = "https://registry.yarnpkg.com/pkginfo/-/pkginfo-0.4.1.tgz";
        sha1 = "b5418ef0439de5425fc4995042dced14fb2a84ff";
      };
    }

    {
      name = "please_upgrade_node___please_upgrade_node_3.2.0.tgz";
      path = fetchurl {
        name = "please_upgrade_node___please_upgrade_node_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/please-upgrade-node/-/please-upgrade-node-3.2.0.tgz";
        sha1 = "aeddd3f994c933e4ad98b99d9a556efa0e2fe942";
      };
    }

    {
      name = "postgres_array___postgres_array_2.0.0.tgz";
      path = fetchurl {
        name = "postgres_array___postgres_array_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/postgres-array/-/postgres-array-2.0.0.tgz";
        sha1 = "48f8fce054fbc69671999329b8834b772652d82e";
      };
    }

    {
      name = "postgres_bytea___postgres_bytea_1.0.0.tgz";
      path = fetchurl {
        name = "postgres_bytea___postgres_bytea_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/postgres-bytea/-/postgres-bytea-1.0.0.tgz";
        sha1 = "027b533c0aa890e26d172d47cf9ccecc521acd35";
      };
    }

    {
      name = "postgres_date___postgres_date_1.0.4.tgz";
      path = fetchurl {
        name = "postgres_date___postgres_date_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/postgres-date/-/postgres-date-1.0.4.tgz";
        sha1 = "1c2728d62ef1bff49abdd35c1f86d4bdf118a728";
      };
    }

    {
      name = "postgres_interval___postgres_interval_1.2.0.tgz";
      path = fetchurl {
        name = "postgres_interval___postgres_interval_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/postgres-interval/-/postgres-interval-1.2.0.tgz";
        sha1 = "b460c82cb1587507788819a06aa0fffdb3544695";
      };
    }

    {
      name = "prebuild_install___prebuild_install_5.3.3.tgz";
      path = fetchurl {
        name = "prebuild_install___prebuild_install_5.3.3.tgz";
        url  = "https://registry.yarnpkg.com/prebuild-install/-/prebuild-install-5.3.3.tgz";
        sha1 = "ef4052baac60d465f5ba6bf003c9c1de79b9da8e";
      };
    }

    {
      name = "precond___precond_0.2.3.tgz";
      path = fetchurl {
        name = "precond___precond_0.2.3.tgz";
        url  = "https://registry.yarnpkg.com/precond/-/precond-0.2.3.tgz";
        sha1 = "aa9591bcaa24923f1e0f4849d240f47efc1075ac";
      };
    }

    {
      name = "prepend_http___prepend_http_1.0.4.tgz";
      path = fetchurl {
        name = "prepend_http___prepend_http_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/prepend-http/-/prepend-http-1.0.4.tgz";
        sha1 = "d4f4562b0ce3696e41ac52d0e002e57a635dc6dc";
      };
    }

    {
      name = "process_nextick_args___process_nextick_args_2.0.1.tgz";
      path = fetchurl {
        name = "process_nextick_args___process_nextick_args_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz";
        sha1 = "7820d9b16120cc55ca9ae7792680ae7dba6d7fe2";
      };
    }

    {
      name = "promise.prototype.finally___promise.prototype.finally_3.1.2.tgz";
      path = fetchurl {
        name = "promise.prototype.finally___promise.prototype.finally_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/promise.prototype.finally/-/promise.prototype.finally-3.1.2.tgz";
        sha1 = "b8af89160c9c673cefe3b4c4435b53cfd0287067";
      };
    }

    {
      name = "promisify_any___promisify_any_2.0.1.tgz";
      path = fetchurl {
        name = "promisify_any___promisify_any_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/promisify-any/-/promisify-any-2.0.1.tgz";
        sha1 = "403e00a8813f175242ab50fe33a69f8eece47305";
      };
    }

    {
      name = "prompt___prompt_1.0.0.tgz";
      path = fetchurl {
        name = "prompt___prompt_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/prompt/-/prompt-1.0.0.tgz";
        sha1 = "8e57123c396ab988897fb327fd3aedc3e735e4fe";
      };
    }

    {
      name = "proxy_addr___proxy_addr_2.0.5.tgz";
      path = fetchurl {
        name = "proxy_addr___proxy_addr_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/proxy-addr/-/proxy-addr-2.0.5.tgz";
        sha1 = "34cbd64a2d81f4b1fd21e76f9f06c8a45299ee34";
      };
    }

    {
      name = "pseudomap___pseudomap_1.0.2.tgz";
      path = fetchurl {
        name = "pseudomap___pseudomap_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/pseudomap/-/pseudomap-1.0.2.tgz";
        sha1 = "f052a28da70e618917ef0a8ac34c1ae5a68286b3";
      };
    }

    {
      name = "psl___psl_1.7.0.tgz";
      path = fetchurl {
        name = "psl___psl_1.7.0.tgz";
        url  = "https://registry.yarnpkg.com/psl/-/psl-1.7.0.tgz";
        sha1 = "f1c4c47a8ef97167dea5d6bbf4816d736e884a3c";
      };
    }

    {
      name = "pstree.remy___pstree.remy_1.1.7.tgz";
      path = fetchurl {
        name = "pstree.remy___pstree.remy_1.1.7.tgz";
        url  = "https://registry.yarnpkg.com/pstree.remy/-/pstree.remy-1.1.7.tgz";
        sha1 = "c76963a28047ed61542dc361aa26ee55a7fa15f3";
      };
    }

    {
      name = "pump___pump_2.0.1.tgz";
      path = fetchurl {
        name = "pump___pump_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/pump/-/pump-2.0.1.tgz";
        sha1 = "12399add6e4cf7526d973cbc8b5ce2e2908b3909";
      };
    }

    {
      name = "pump___pump_3.0.0.tgz";
      path = fetchurl {
        name = "pump___pump_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz";
        sha1 = "b4a2116815bde2f4e1ea602354e8c75565107a64";
      };
    }

    {
      name = "pumpify___pumpify_1.5.1.tgz";
      path = fetchurl {
        name = "pumpify___pumpify_1.5.1.tgz";
        url  = "https://registry.yarnpkg.com/pumpify/-/pumpify-1.5.1.tgz";
        sha1 = "36513be246ab27570b1a374a5ce278bfd74370ce";
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
      name = "punycode___punycode_2.1.1.tgz";
      path = fetchurl {
        name = "punycode___punycode_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/punycode/-/punycode-2.1.1.tgz";
        sha1 = "b58b010ac40c22c5657616c8d2c2c02c7bf479ec";
      };
    }

    {
      name = "qs___qs_6.7.0.tgz";
      path = fetchurl {
        name = "qs___qs_6.7.0.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.7.0.tgz";
        sha1 = "41dc1a015e3d581f1621776be31afb2876a9b1bc";
      };
    }

    {
      name = "qs___qs_6.9.1.tgz";
      path = fetchurl {
        name = "qs___qs_6.9.1.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.9.1.tgz";
        sha1 = "20082c65cb78223635ab1a9eaca8875a29bf8ec9";
      };
    }

    {
      name = "qs___qs_6.5.2.tgz";
      path = fetchurl {
        name = "qs___qs_6.5.2.tgz";
        url  = "https://registry.yarnpkg.com/qs/-/qs-6.5.2.tgz";
        sha1 = "cb3ae806e8740444584ef154ce8ee98d403f3e36";
      };
    }

    {
      name = "queue_microtask___queue_microtask_1.1.2.tgz";
      path = fetchurl {
        name = "queue_microtask___queue_microtask_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/queue-microtask/-/queue-microtask-1.1.2.tgz";
        sha1 = "139bf8186db0c545017ec66c2664ac646d5c571e";
      };
    }

    {
      name = "random_access_file___random_access_file_2.1.3.tgz";
      path = fetchurl {
        name = "random_access_file___random_access_file_2.1.3.tgz";
        url  = "https://registry.yarnpkg.com/random-access-file/-/random-access-file-2.1.3.tgz";
        sha1 = "642c4b29e39c7dd91609a2e912f174d70fd4f82a";
      };
    }

    {
      name = "random_access_storage___random_access_storage_1.4.0.tgz";
      path = fetchurl {
        name = "random_access_storage___random_access_storage_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/random-access-storage/-/random-access-storage-1.4.0.tgz";
        sha1 = "cbe5b5ccfb38680aac7b78a050d9f0a5ef36841f";
      };
    }

    {
      name = "random_iterate___random_iterate_1.0.1.tgz";
      path = fetchurl {
        name = "random_iterate___random_iterate_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/random-iterate/-/random-iterate-1.0.1.tgz";
        sha1 = "f7d97d92dee6665ec5f6da08c7f963cad4b2ac99";
      };
    }

    {
      name = "randombytes___randombytes_2.1.0.tgz";
      path = fetchurl {
        name = "randombytes___randombytes_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz";
        sha1 = "df6f84372f0270dc65cdf6291349ab7a473d4f2a";
      };
    }

    {
      name = "range_parser___range_parser_1.2.1.tgz";
      path = fetchurl {
        name = "range_parser___range_parser_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/range-parser/-/range-parser-1.2.1.tgz";
        sha1 = "3cf37023d199e1c24d1a55b84800c2f3e6468031";
      };
    }

    {
      name = "range_slice_stream___range_slice_stream_2.0.0.tgz";
      path = fetchurl {
        name = "range_slice_stream___range_slice_stream_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/range-slice-stream/-/range-slice-stream-2.0.0.tgz";
        sha1 = "1f25fc7a2cacf9ccd140c46f9cf670a1a7fe3ce6";
      };
    }

    {
      name = "raw_body___raw_body_2.4.0.tgz";
      path = fetchurl {
        name = "raw_body___raw_body_2.4.0.tgz";
        url  = "https://registry.yarnpkg.com/raw-body/-/raw-body-2.4.0.tgz";
        sha1 = "a1ce6fb9c9bc356ca52e89256ab59059e13d0332";
      };
    }

    {
      name = "rc___rc_1.2.8.tgz";
      path = fetchurl {
        name = "rc___rc_1.2.8.tgz";
        url  = "https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz";
        sha1 = "cd924bf5200a075b83c188cd6b9e211b7fc0d3ed";
      };
    }

    {
      name = "rdf_canonize___rdf_canonize_1.0.3.tgz";
      path = fetchurl {
        name = "rdf_canonize___rdf_canonize_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/rdf-canonize/-/rdf-canonize-1.0.3.tgz";
        sha1 = "71dc56bb808a39d12e3ca17674c15f881cad648a";
      };
    }

    {
      name = "read_pkg___read_pkg_4.0.1.tgz";
      path = fetchurl {
        name = "read_pkg___read_pkg_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/read-pkg/-/read-pkg-4.0.1.tgz";
        sha1 = "963625378f3e1c4d48c85872b5a6ec7d5d093237";
      };
    }

    {
      name = "read___read_1.0.7.tgz";
      path = fetchurl {
        name = "read___read_1.0.7.tgz";
        url  = "https://registry.yarnpkg.com/read/-/read-1.0.7.tgz";
        sha1 = "b3da19bd052431a97671d44a42634adf710b40c4";
      };
    }

    {
      name = "readable_stream___readable_stream_1.1.14.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_1.1.14.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.1.14.tgz";
        sha1 = "7cf4c54ef648e3813084c636dd2079e166c081d9";
      };
    }

    {
      name = "readable_stream___readable_stream_1.0.34.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_1.0.34.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-1.0.34.tgz";
        sha1 = "125820e34bc842d2f2aaafafe4c2916ee32c157c";
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
      name = "readable_stream___readable_stream_3.4.0.tgz";
      path = fetchurl {
        name = "readable_stream___readable_stream_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.4.0.tgz";
        sha1 = "a51c26754658e0a3c21dbf59163bd45ba6f447fc";
      };
    }

    {
      name = "readable_wrap___readable_wrap_1.0.0.tgz";
      path = fetchurl {
        name = "readable_wrap___readable_wrap_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/readable-wrap/-/readable-wrap-1.0.0.tgz";
        sha1 = "3b5a211c631e12303a54991c806c17e7ae206bff";
      };
    }

    {
      name = "readdirp___readdirp_3.2.0.tgz";
      path = fetchurl {
        name = "readdirp___readdirp_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/readdirp/-/readdirp-3.2.0.tgz";
        sha1 = "c30c33352b12c96dfb4b895421a49fd5a9593839";
      };
    }

    {
      name = "readdirp___readdirp_3.3.0.tgz";
      path = fetchurl {
        name = "readdirp___readdirp_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/readdirp/-/readdirp-3.3.0.tgz";
        sha1 = "984458d13a1e42e2e9f5841b129e162f369aff17";
      };
    }

    {
      name = "record_cache___record_cache_1.1.0.tgz";
      path = fetchurl {
        name = "record_cache___record_cache_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/record-cache/-/record-cache-1.1.0.tgz";
        sha1 = "f8a467a691a469584b26e88d36b18afdb3932037";
      };
    }

    {
      name = "redis_commands___redis_commands_1.5.0.tgz";
      path = fetchurl {
        name = "redis_commands___redis_commands_1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/redis-commands/-/redis-commands-1.5.0.tgz";
        sha1 = "80d2e20698fe688f227127ff9e5164a7dd17e785";
      };
    }

    {
      name = "redis_errors___redis_errors_1.2.0.tgz";
      path = fetchurl {
        name = "redis_errors___redis_errors_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/redis-errors/-/redis-errors-1.2.0.tgz";
        sha1 = "eb62d2adb15e4eaf4610c04afe1529384250abad";
      };
    }

    {
      name = "redis_parser___redis_parser_2.6.0.tgz";
      path = fetchurl {
        name = "redis_parser___redis_parser_2.6.0.tgz";
        url  = "https://registry.yarnpkg.com/redis-parser/-/redis-parser-2.6.0.tgz";
        sha1 = "52ed09dacac108f1a631c07e9b69941e7a19504b";
      };
    }

    {
      name = "redis_parser___redis_parser_3.0.0.tgz";
      path = fetchurl {
        name = "redis_parser___redis_parser_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/redis-parser/-/redis-parser-3.0.0.tgz";
        sha1 = "b66d828cdcafe6b4b8a428a7def4c6bcac31c8b4";
      };
    }

    {
      name = "redis___redis_2.8.0.tgz";
      path = fetchurl {
        name = "redis___redis_2.8.0.tgz";
        url  = "https://registry.yarnpkg.com/redis/-/redis-2.8.0.tgz";
        sha1 = "202288e3f58c49f6079d97af7a10e1303ae14b02";
      };
    }

    {
      name = "referrer_policy___referrer_policy_1.2.0.tgz";
      path = fetchurl {
        name = "referrer_policy___referrer_policy_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/referrer-policy/-/referrer-policy-1.2.0.tgz";
        sha1 = "b99cfb8b57090dc454895ef897a4cc35ef67a98e";
      };
    }

    {
      name = "reflect_metadata___reflect_metadata_0.1.13.tgz";
      path = fetchurl {
        name = "reflect_metadata___reflect_metadata_0.1.13.tgz";
        url  = "https://registry.yarnpkg.com/reflect-metadata/-/reflect-metadata-0.1.13.tgz";
        sha1 = "67ae3ca57c972a2aa1642b10fe363fe32d49dc08";
      };
    }

    {
      name = "registry_auth_token___registry_auth_token_3.4.0.tgz";
      path = fetchurl {
        name = "registry_auth_token___registry_auth_token_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/registry-auth-token/-/registry-auth-token-3.4.0.tgz";
        sha1 = "d7446815433f5d5ed6431cd5dca21048f66b397e";
      };
    }

    {
      name = "registry_url___registry_url_3.1.0.tgz";
      path = fetchurl {
        name = "registry_url___registry_url_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/registry-url/-/registry-url-3.1.0.tgz";
        sha1 = "3d4ef870f73dde1d77f0cf9a381432444e174942";
      };
    }

    {
      name = "render_media___render_media_3.4.0.tgz";
      path = fetchurl {
        name = "render_media___render_media_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/render-media/-/render-media-3.4.0.tgz";
        sha1 = "3e19cff3dc06da3b7431dda5aad4912e6dee60d8";
      };
    }

    {
      name = "request___request_2.88.0.tgz";
      path = fetchurl {
        name = "request___request_2.88.0.tgz";
        url  = "https://registry.yarnpkg.com/request/-/request-2.88.0.tgz";
        sha1 = "9c2fca4f7d35b592efe57c7f0a55e81052124fef";
      };
    }

    {
      name = "require_directory___require_directory_2.1.1.tgz";
      path = fetchurl {
        name = "require_directory___require_directory_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz";
        sha1 = "8c64ad5fd30dab1c976e2344ffe7f792a6a6df42";
      };
    }

    {
      name = "require_main_filename___require_main_filename_2.0.0.tgz";
      path = fetchurl {
        name = "require_main_filename___require_main_filename_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-2.0.0.tgz";
        sha1 = "d0b329ecc7cc0f61649f62215be69af54aa8989b";
      };
    }

    {
      name = "resolve_from___resolve_from_2.0.0.tgz";
      path = fetchurl {
        name = "resolve_from___resolve_from_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-from/-/resolve-from-2.0.0.tgz";
        sha1 = "9480ab20e94ffa1d9e80a804c7ea147611966b57";
      };
    }

    {
      name = "resolve_from___resolve_from_3.0.0.tgz";
      path = fetchurl {
        name = "resolve_from___resolve_from_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-from/-/resolve-from-3.0.0.tgz";
        sha1 = "b22c7af7d9d6881bc8b6e653335eebcb0a188748";
      };
    }

    {
      name = "resolve_pkg___resolve_pkg_1.0.0.tgz";
      path = fetchurl {
        name = "resolve_pkg___resolve_pkg_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/resolve-pkg/-/resolve-pkg-1.0.0.tgz";
        sha1 = "e19a15e78aca2e124461dc92b2e3943ef93494d9";
      };
    }

    {
      name = "resolve___resolve_1.14.2.tgz";
      path = fetchurl {
        name = "resolve___resolve_1.14.2.tgz";
        url  = "https://registry.yarnpkg.com/resolve/-/resolve-1.14.2.tgz";
        sha1 = "dbf31d0fa98b1f29aa5169783b9c290cb865fea2";
      };
    }

    {
      name = "restore_cursor___restore_cursor_2.0.0.tgz";
      path = fetchurl {
        name = "restore_cursor___restore_cursor_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-2.0.0.tgz";
        sha1 = "9f7ee287f82fd326d4fd162923d62129eee0dfaf";
      };
    }

    {
      name = "retry_as_promised___retry_as_promised_3.2.0.tgz";
      path = fetchurl {
        name = "retry_as_promised___retry_as_promised_3.2.0.tgz";
        url  = "https://registry.yarnpkg.com/retry-as-promised/-/retry-as-promised-3.2.0.tgz";
        sha1 = "769f63d536bec4783549db0777cb56dadd9d8543";
      };
    }

    {
      name = "reusify___reusify_1.0.4.tgz";
      path = fetchurl {
        name = "reusify___reusify_1.0.4.tgz";
        url  = "https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz";
        sha1 = "90da382b1e126efc02146e90845a88db12925d76";
      };
    }

    {
      name = "revalidator___revalidator_0.1.8.tgz";
      path = fetchurl {
        name = "revalidator___revalidator_0.1.8.tgz";
        url  = "https://registry.yarnpkg.com/revalidator/-/revalidator-0.1.8.tgz";
        sha1 = "fece61bfa0c1b52a206bd6b18198184bdd523a3b";
      };
    }

    {
      name = "rimraf___rimraf_2.7.1.tgz";
      path = fetchurl {
        name = "rimraf___rimraf_2.7.1.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz";
        sha1 = "35797f13a7fdadc566142c29d4f07ccad483e3ec";
      };
    }

    {
      name = "rimraf___rimraf_3.0.0.tgz";
      path = fetchurl {
        name = "rimraf___rimraf_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.0.tgz";
        sha1 = "614176d4b3010b75e5c390eb0ee96f6dc0cebb9b";
      };
    }

    {
      name = "rimraf___rimraf_2.4.5.tgz";
      path = fetchurl {
        name = "rimraf___rimraf_2.4.5.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-2.4.5.tgz";
        sha1 = "ee710ce5d93a8fdb856fb5ea8ff0e2d75934b2da";
      };
    }

    {
      name = "run_parallel_limit___run_parallel_limit_1.0.5.tgz";
      path = fetchurl {
        name = "run_parallel_limit___run_parallel_limit_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/run-parallel-limit/-/run-parallel-limit-1.0.5.tgz";
        sha1 = "c29a4fd17b4df358cb52a8a697811a63c984f1b7";
      };
    }

    {
      name = "run_parallel___run_parallel_1.1.9.tgz";
      path = fetchurl {
        name = "run_parallel___run_parallel_1.1.9.tgz";
        url  = "https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.1.9.tgz";
        sha1 = "c9dd3a7cf9f4b2c4b6244e173a6ed866e61dd679";
      };
    }

    {
      name = "run_series___run_series_1.1.8.tgz";
      path = fetchurl {
        name = "run_series___run_series_1.1.8.tgz";
        url  = "https://registry.yarnpkg.com/run-series/-/run-series-1.1.8.tgz";
        sha1 = "2c4558f49221e01cd6371ff4e0a1e203e460fc36";
      };
    }

    {
      name = "rusha___rusha_0.8.13.tgz";
      path = fetchurl {
        name = "rusha___rusha_0.8.13.tgz";
        url  = "https://registry.yarnpkg.com/rusha/-/rusha-0.8.13.tgz";
        sha1 = "9a084e7b860b17bff3015b92c67a6a336191513a";
      };
    }

    {
      name = "rxjs___rxjs_6.5.4.tgz";
      path = fetchurl {
        name = "rxjs___rxjs_6.5.4.tgz";
        url  = "https://registry.yarnpkg.com/rxjs/-/rxjs-6.5.4.tgz";
        sha1 = "e0777fe0d184cec7872df147f303572d414e211c";
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
      name = "safe_buffer___safe_buffer_5.2.0.tgz";
      path = fetchurl {
        name = "safe_buffer___safe_buffer_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.0.tgz";
        sha1 = "b74daec49b1148f88c64b68d49b1e815c1f2f519";
      };
    }

    {
      name = "safe_json_stringify___safe_json_stringify_1.2.0.tgz";
      path = fetchurl {
        name = "safe_json_stringify___safe_json_stringify_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/safe-json-stringify/-/safe-json-stringify-1.2.0.tgz";
        sha1 = "356e44bc98f1f93ce45df14bcd7c01cda86e0afd";
      };
    }

    {
      name = "safer_buffer___safer_buffer_2.1.2.tgz";
      path = fetchurl {
        name = "safer_buffer___safer_buffer_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz";
        sha1 = "44fa161b0187b9549dd84bb91802f9bd8385cd6a";
      };
    }

    {
      name = "sax___sax_1.2.4.tgz";
      path = fetchurl {
        name = "sax___sax_1.2.4.tgz";
        url  = "https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz";
        sha1 = "2816234e2378bddc4e5354fab5caa895df7100d9";
      };
    }

    {
      name = "scripty___scripty_1.9.1.tgz";
      path = fetchurl {
        name = "scripty___scripty_1.9.1.tgz";
        url  = "https://registry.yarnpkg.com/scripty/-/scripty-1.9.1.tgz";
        sha1 = "538d12ad816b564584b4b787800f6567bb97c84a";
      };
    }

    {
      name = "semver_compare___semver_compare_1.0.0.tgz";
      path = fetchurl {
        name = "semver_compare___semver_compare_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz";
        sha1 = "0dee216a1c941ab37e9efb1788f6afc5ff5537fc";
      };
    }

    {
      name = "semver_diff___semver_diff_2.1.0.tgz";
      path = fetchurl {
        name = "semver_diff___semver_diff_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/semver-diff/-/semver-diff-2.1.0.tgz";
        sha1 = "4bbb8437c8d37e4b0cf1a68fd726ec6d645d6d36";
      };
    }

    {
      name = "semver___semver_5.7.1.tgz";
      path = fetchurl {
        name = "semver___semver_5.7.1.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz";
        sha1 = "a954f931aeba508d307bbf069eff0c01c96116f7";
      };
    }

    {
      name = "semver___semver_4.3.2.tgz";
      path = fetchurl {
        name = "semver___semver_4.3.2.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-4.3.2.tgz";
        sha1 = "c7a07158a80bedd052355b770d82d6640f803be7";
      };
    }

    {
      name = "semver___semver_6.3.0.tgz";
      path = fetchurl {
        name = "semver___semver_6.3.0.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz";
        sha1 = "ee0a64c8af5e8ceea67687b133761e1becbd1d3d";
      };
    }

    {
      name = "send___send_0.17.1.tgz";
      path = fetchurl {
        name = "send___send_0.17.1.tgz";
        url  = "https://registry.yarnpkg.com/send/-/send-0.17.1.tgz";
        sha1 = "c1d8b059f7900f7466dd4938bdc44e11ddb376c8";
      };
    }

    {
      name = "sequelize_pool___sequelize_pool_2.3.0.tgz";
      path = fetchurl {
        name = "sequelize_pool___sequelize_pool_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/sequelize-pool/-/sequelize-pool-2.3.0.tgz";
        sha1 = "64f1fe8744228172c474f530604b6133be64993d";
      };
    }

    {
      name = "sequelize_typescript___sequelize_typescript_1.1.0.tgz";
      path = fetchurl {
        name = "sequelize_typescript___sequelize_typescript_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/sequelize-typescript/-/sequelize-typescript-1.1.0.tgz";
        sha1 = "d5c2945e7fbfe55a934917b27d84589858d79123";
      };
    }

    {
      name = "sequelize___sequelize_5.21.3.tgz";
      path = fetchurl {
        name = "sequelize___sequelize_5.21.3.tgz";
        url  = "https://registry.yarnpkg.com/sequelize/-/sequelize-5.21.3.tgz";
        sha1 = "f8a6fa0245f8995d70849e4da00c2c7c9aa9f569";
      };
    }

    {
      name = "serve_static___serve_static_1.14.1.tgz";
      path = fetchurl {
        name = "serve_static___serve_static_1.14.1.tgz";
        url  = "https://registry.yarnpkg.com/serve-static/-/serve-static-1.14.1.tgz";
        sha1 = "666e636dc4f010f7ef29970a88a674320898b2f9";
      };
    }

    {
      name = "set_blocking___set_blocking_2.0.0.tgz";
      path = fetchurl {
        name = "set_blocking___set_blocking_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz";
        sha1 = "045f9782d011ae9a6803ddd382b24392b3d890f7";
      };
    }

    {
      name = "setprototypeof___setprototypeof_1.1.1.tgz";
      path = fetchurl {
        name = "setprototypeof___setprototypeof_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.1.1.tgz";
        sha1 = "7e95acb24aa92f5885e0abef5ba131330d4ae683";
      };
    }

    {
      name = "sharp___sharp_0.23.4.tgz";
      path = fetchurl {
        name = "sharp___sharp_0.23.4.tgz";
        url  = "https://registry.yarnpkg.com/sharp/-/sharp-0.23.4.tgz";
        sha1 = "ca36067cb6ff7067fa6c77b01651cb9a890f8eb3";
      };
    }

    {
      name = "shebang_command___shebang_command_1.2.0.tgz";
      path = fetchurl {
        name = "shebang_command___shebang_command_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz";
        sha1 = "44aac65b695b03398968c39f363fee5deafdf1ea";
      };
    }

    {
      name = "shebang_command___shebang_command_2.0.0.tgz";
      path = fetchurl {
        name = "shebang_command___shebang_command_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz";
        sha1 = "ccd0af4f8835fbdc265b82461aaf0c36663f34ea";
      };
    }

    {
      name = "shebang_regex___shebang_regex_1.0.0.tgz";
      path = fetchurl {
        name = "shebang_regex___shebang_regex_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz";
        sha1 = "da42f49740c0b42db2ca9728571cb190c98efea3";
      };
    }

    {
      name = "shebang_regex___shebang_regex_3.0.0.tgz";
      path = fetchurl {
        name = "shebang_regex___shebang_regex_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz";
        sha1 = "ae16f1644d873ecad843b0307b143362d4c42172";
      };
    }

    {
      name = "shimmer___shimmer_1.2.1.tgz";
      path = fetchurl {
        name = "shimmer___shimmer_1.2.1.tgz";
        url  = "https://registry.yarnpkg.com/shimmer/-/shimmer-1.2.1.tgz";
        sha1 = "610859f7de327b587efebf501fb43117f9aff337";
      };
    }

    {
      name = "signal_exit___signal_exit_3.0.2.tgz";
      path = fetchurl {
        name = "signal_exit___signal_exit_3.0.2.tgz";
        url  = "https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.2.tgz";
        sha1 = "b5fdc08f1287ea1178628e415e25132b73646c6d";
      };
    }

    {
      name = "simple_concat___simple_concat_1.0.0.tgz";
      path = fetchurl {
        name = "simple_concat___simple_concat_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/simple-concat/-/simple-concat-1.0.0.tgz";
        sha1 = "7344cbb8b6e26fb27d66b2fc86f9f6d5997521c6";
      };
    }

    {
      name = "simple_get___simple_get_3.1.0.tgz";
      path = fetchurl {
        name = "simple_get___simple_get_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/simple-get/-/simple-get-3.1.0.tgz";
        sha1 = "b45be062435e50d159540b576202ceec40b9c6b3";
      };
    }

    {
      name = "simple_peer___simple_peer_9.6.2.tgz";
      path = fetchurl {
        name = "simple_peer___simple_peer_9.6.2.tgz";
        url  = "https://registry.yarnpkg.com/simple-peer/-/simple-peer-9.6.2.tgz";
        sha1 = "42418e77cf8f9184e4fa22ef1017b195c2bf84d7";
      };
    }

    {
      name = "simple_sha1___simple_sha1_3.0.1.tgz";
      path = fetchurl {
        name = "simple_sha1___simple_sha1_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/simple-sha1/-/simple-sha1-3.0.1.tgz";
        sha1 = "b34c3c978d74ac4baf99b6555c1e6736e0d6e700";
      };
    }

    {
      name = "simple_swizzle___simple_swizzle_0.2.2.tgz";
      path = fetchurl {
        name = "simple_swizzle___simple_swizzle_0.2.2.tgz";
        url  = "https://registry.yarnpkg.com/simple-swizzle/-/simple-swizzle-0.2.2.tgz";
        sha1 = "a4da6b635ffcccca33f70d17cb92592de95e557a";
      };
    }

    {
      name = "simple_websocket___simple_websocket_8.1.1.tgz";
      path = fetchurl {
        name = "simple_websocket___simple_websocket_8.1.1.tgz";
        url  = "https://registry.yarnpkg.com/simple-websocket/-/simple-websocket-8.1.1.tgz";
        sha1 = "4fd68cb1301c1253b2607cfe0950a8be37e6116a";
      };
    }

    {
      name = "sitemap___sitemap_5.1.0.tgz";
      path = fetchurl {
        name = "sitemap___sitemap_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/sitemap/-/sitemap-5.1.0.tgz";
        sha1 = "60c88915e20f8cd0dcd5906dac8f2ec4c0d8de68";
      };
    }

    {
      name = "slash___slash_3.0.0.tgz";
      path = fetchurl {
        name = "slash___slash_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/slash/-/slash-3.0.0.tgz";
        sha1 = "6539be870c165adbd5240220dbe361f1bc4d4634";
      };
    }

    {
      name = "slice_ansi___slice_ansi_0.0.4.tgz";
      path = fetchurl {
        name = "slice_ansi___slice_ansi_0.0.4.tgz";
        url  = "https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-0.0.4.tgz";
        sha1 = "edbf8903f66f7ce2f8eafd6ceed65e264c831b35";
      };
    }

    {
      name = "smtp_connection___smtp_connection_4.0.2.tgz";
      path = fetchurl {
        name = "smtp_connection___smtp_connection_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/smtp-connection/-/smtp-connection-4.0.2.tgz";
        sha1 = "d9dd68d38569f3ad9265473670d09d8f3ea518db";
      };
    }

    {
      name = "smtp_server___smtp_server_3.5.0.tgz";
      path = fetchurl {
        name = "smtp_server___smtp_server_3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/smtp-server/-/smtp-server-3.5.0.tgz";
        sha1 = "eb2e7bd52f26b4136b9dfc2c9fa0ba70e18cdc81";
      };
    }

    {
      name = "socket.io_adapter___socket.io_adapter_1.1.2.tgz";
      path = fetchurl {
        name = "socket.io_adapter___socket.io_adapter_1.1.2.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-adapter/-/socket.io-adapter-1.1.2.tgz";
        sha1 = "ab3f0d6f66b8fc7fca3959ab5991f82221789be9";
      };
    }

    {
      name = "socket.io_client___socket.io_client_2.2.0.tgz";
      path = fetchurl {
        name = "socket.io_client___socket.io_client_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-client/-/socket.io-client-2.2.0.tgz";
        sha1 = "84e73ee3c43d5020ccc1a258faeeb9aec2723af7";
      };
    }

    {
      name = "socket.io_client___socket.io_client_2.3.0.tgz";
      path = fetchurl {
        name = "socket.io_client___socket.io_client_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-client/-/socket.io-client-2.3.0.tgz";
        sha1 = "14d5ba2e00b9bcd145ae443ab96b3f86cbcc1bb4";
      };
    }

    {
      name = "socket.io_parser___socket.io_parser_3.3.0.tgz";
      path = fetchurl {
        name = "socket.io_parser___socket.io_parser_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-parser/-/socket.io-parser-3.3.0.tgz";
        sha1 = "2b52a96a509fdf31440ba40fed6094c7d4f1262f";
      };
    }

    {
      name = "socket.io_parser___socket.io_parser_3.4.0.tgz";
      path = fetchurl {
        name = "socket.io_parser___socket.io_parser_3.4.0.tgz";
        url  = "https://registry.yarnpkg.com/socket.io-parser/-/socket.io-parser-3.4.0.tgz";
        sha1 = "370bb4a151df2f77ce3345ff55a7072cc6e9565a";
      };
    }

    {
      name = "socket.io___socket.io_2.2.0.tgz";
      path = fetchurl {
        name = "socket.io___socket.io_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/socket.io/-/socket.io-2.2.0.tgz";
        sha1 = "f0f633161ef6712c972b307598ecd08c9b1b4d5b";
      };
    }

    {
      name = "socket.io___socket.io_2.3.0.tgz";
      path = fetchurl {
        name = "socket.io___socket.io_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/socket.io/-/socket.io-2.3.0.tgz";
        sha1 = "cd762ed6a4faeca59bc1f3e243c0969311eb73fb";
      };
    }

    {
      name = "source_map_support___source_map_support_0.5.16.tgz";
      path = fetchurl {
        name = "source_map_support___source_map_support_0.5.16.tgz";
        url  = "https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.16.tgz";
        sha1 = "0ae069e7fe3ba7538c64c98515e35339eac5a042";
      };
    }

    {
      name = "source_map___source_map_0.6.1.tgz";
      path = fetchurl {
        name = "source_map___source_map_0.6.1.tgz";
        url  = "https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz";
        sha1 = "74722af32e9614e9c287a8d0bbde48b5e2f1a263";
      };
    }

    {
      name = "spawn_command___spawn_command_0.0.2_1.tgz";
      path = fetchurl {
        name = "spawn_command___spawn_command_0.0.2_1.tgz";
        url  = "https://registry.yarnpkg.com/spawn-command/-/spawn-command-0.0.2-1.tgz";
        sha1 = "62f5e9466981c1b796dc5929937e11c9c6921bd0";
      };
    }

    {
      name = "spdx_correct___spdx_correct_3.1.0.tgz";
      path = fetchurl {
        name = "spdx_correct___spdx_correct_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.1.0.tgz";
        sha1 = "fb83e504445268f154b074e218c87c003cd31df4";
      };
    }

    {
      name = "spdx_exceptions___spdx_exceptions_2.2.0.tgz";
      path = fetchurl {
        name = "spdx_exceptions___spdx_exceptions_2.2.0.tgz";
        url  = "https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.2.0.tgz";
        sha1 = "2ea450aee74f2a89bfb94519c07fcd6f41322977";
      };
    }

    {
      name = "spdx_expression_parse___spdx_expression_parse_3.0.0.tgz";
      path = fetchurl {
        name = "spdx_expression_parse___spdx_expression_parse_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.0.tgz";
        sha1 = "99e119b7a5da00e05491c9fa338b7904823b41d0";
      };
    }

    {
      name = "spdx_license_ids___spdx_license_ids_3.0.5.tgz";
      path = fetchurl {
        name = "spdx_license_ids___spdx_license_ids_3.0.5.tgz";
        url  = "https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.5.tgz";
        sha1 = "3694b5804567a458d3c8045842a6358632f62654";
      };
    }

    {
      name = "speedometer___speedometer_1.1.0.tgz";
      path = fetchurl {
        name = "speedometer___speedometer_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/speedometer/-/speedometer-1.1.0.tgz";
        sha1 = "a30b13abda45687a1a76977012c060f2ac8a7934";
      };
    }

    {
      name = "split2___split2_0.2.1.tgz";
      path = fetchurl {
        name = "split2___split2_0.2.1.tgz";
        url  = "https://registry.yarnpkg.com/split2/-/split2-0.2.1.tgz";
        sha1 = "02ddac9adc03ec0bb78c1282ec079ca6e85ae900";
      };
    }

    {
      name = "split___split_1.0.1.tgz";
      path = fetchurl {
        name = "split___split_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/split/-/split-1.0.1.tgz";
        sha1 = "605bd9be303aa59fb35f9229fbea0ddec9ea07d9";
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
      name = "srt_to_vtt___srt_to_vtt_1.1.3.tgz";
      path = fetchurl {
        name = "srt_to_vtt___srt_to_vtt_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/srt-to-vtt/-/srt-to-vtt-1.1.3.tgz";
        sha1 = "a9bc16cde5412e000e59ffda469f3e9befed5dde";
      };
    }

    {
      name = "sshpk___sshpk_1.16.1.tgz";
      path = fetchurl {
        name = "sshpk___sshpk_1.16.1.tgz";
        url  = "https://registry.yarnpkg.com/sshpk/-/sshpk-1.16.1.tgz";
        sha1 = "fb661c0bef29b39db40769ee39fa70093d6f6877";
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
      name = "standard_as_callback___standard_as_callback_2.0.1.tgz";
      path = fetchurl {
        name = "standard_as_callback___standard_as_callback_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/standard-as-callback/-/standard-as-callback-2.0.1.tgz";
        sha1 = "ed8bb25648e15831759b6023bdb87e6b60b38126";
      };
    }

    {
      name = "statuses___statuses_1.3.1.tgz";
      path = fetchurl {
        name = "statuses___statuses_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/statuses/-/statuses-1.3.1.tgz";
        sha1 = "faf51b9eb74aaef3b3acf4ad5f61abf24cb7b93e";
      };
    }

    {
      name = "statuses___statuses_1.5.0.tgz";
      path = fetchurl {
        name = "statuses___statuses_1.5.0.tgz";
        url  = "https://registry.yarnpkg.com/statuses/-/statuses-1.5.0.tgz";
        sha1 = "161c7dac177659fd9811f43771fa99381478628c";
      };
    }

    {
      name = "stream_shift___stream_shift_1.0.1.tgz";
      path = fetchurl {
        name = "stream_shift___stream_shift_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/stream-shift/-/stream-shift-1.0.1.tgz";
        sha1 = "d7088281559ab2778424279b0877da3c392d5a3d";
      };
    }

    {
      name = "stream_splicer___stream_splicer_1.3.2.tgz";
      path = fetchurl {
        name = "stream_splicer___stream_splicer_1.3.2.tgz";
        url  = "https://registry.yarnpkg.com/stream-splicer/-/stream-splicer-1.3.2.tgz";
        sha1 = "3c0441be15b9bf4e226275e6dc83964745546661";
      };
    }

    {
      name = "stream_to_blob_url___stream_to_blob_url_3.0.0.tgz";
      path = fetchurl {
        name = "stream_to_blob_url___stream_to_blob_url_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stream-to-blob-url/-/stream-to-blob-url-3.0.0.tgz";
        sha1 = "48dcaba85fab2d6c3795d38eb97a07741653f1dc";
      };
    }

    {
      name = "stream_to_blob___stream_to_blob_2.0.0.tgz";
      path = fetchurl {
        name = "stream_to_blob___stream_to_blob_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/stream-to-blob/-/stream-to-blob-2.0.0.tgz";
        sha1 = "3b71d5445eaf69025556237d2dfd0fc66fd142e7";
      };
    }

    {
      name = "stream_with_known_length_to_buffer___stream_with_known_length_to_buffer_1.0.3.tgz";
      path = fetchurl {
        name = "stream_with_known_length_to_buffer___stream_with_known_length_to_buffer_1.0.3.tgz";
        url  = "https://registry.yarnpkg.com/stream-with-known-length-to-buffer/-/stream-with-known-length-to-buffer-1.0.3.tgz";
        sha1 = "6bcfcfecc33bd91deda375ca4738f99ec7cd541b";
      };
    }

    {
      name = "streamify___streamify_0.2.9.tgz";
      path = fetchurl {
        name = "streamify___streamify_0.2.9.tgz";
        url  = "https://registry.yarnpkg.com/streamify/-/streamify-0.2.9.tgz";
        sha1 = "8938b14db491e2b6be4f8d99cc4133c9f0384f0b";
      };
    }

    {
      name = "streamsearch___streamsearch_0.1.2.tgz";
      path = fetchurl {
        name = "streamsearch___streamsearch_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/streamsearch/-/streamsearch-0.1.2.tgz";
        sha1 = "808b9d0e56fc273d809ba57338e929919a1a9f1a";
      };
    }

    {
      name = "string_argv___string_argv_0.3.1.tgz";
      path = fetchurl {
        name = "string_argv___string_argv_0.3.1.tgz";
        url  = "https://registry.yarnpkg.com/string-argv/-/string-argv-0.3.1.tgz";
        sha1 = "95e2fbec0427ae19184935f816d74aaa4c5c19da";
      };
    }

    {
      name = "string_width___string_width_1.0.2.tgz";
      path = fetchurl {
        name = "string_width___string_width_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz";
        sha1 = "118bdf5b8cdc51a2a7e70d211e07e2b0b9b107d3";
      };
    }

    {
      name = "string_width___string_width_2.1.1.tgz";
      path = fetchurl {
        name = "string_width___string_width_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz";
        sha1 = "ab93f27a8dc13d28cac815c462143a6d9012ae9e";
      };
    }

    {
      name = "string_width___string_width_3.1.0.tgz";
      path = fetchurl {
        name = "string_width___string_width_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-3.1.0.tgz";
        sha1 = "22767be21b62af1081574306f69ac51b62203961";
      };
    }

    {
      name = "string_width___string_width_4.2.0.tgz";
      path = fetchurl {
        name = "string_width___string_width_4.2.0.tgz";
        url  = "https://registry.yarnpkg.com/string-width/-/string-width-4.2.0.tgz";
        sha1 = "952182c46cc7b2c313d1596e623992bd163b72b5";
      };
    }

    {
      name = "string.prototype.trimleft___string.prototype.trimleft_2.1.1.tgz";
      path = fetchurl {
        name = "string.prototype.trimleft___string.prototype.trimleft_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.trimleft/-/string.prototype.trimleft-2.1.1.tgz";
        sha1 = "9bdb8ac6abd6d602b17a4ed321870d2f8dcefc74";
      };
    }

    {
      name = "string.prototype.trimright___string.prototype.trimright_2.1.1.tgz";
      path = fetchurl {
        name = "string.prototype.trimright___string.prototype.trimright_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/string.prototype.trimright/-/string.prototype.trimright-2.1.1.tgz";
        sha1 = "440314b15996c866ce8a0341894d45186200c5d9";
      };
    }

    {
      name = "string2compact___string2compact_1.3.0.tgz";
      path = fetchurl {
        name = "string2compact___string2compact_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/string2compact/-/string2compact-1.3.0.tgz";
        sha1 = "22d946127b082d1203c51316af60117a337423c3";
      };
    }

    {
      name = "string_decoder___string_decoder_1.3.0.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz";
        sha1 = "42f114594a46cf1a8e30b0a84f56c78c3edac21e";
      };
    }

    {
      name = "string_decoder___string_decoder_0.10.31.tgz";
      path = fetchurl {
        name = "string_decoder___string_decoder_0.10.31.tgz";
        url  = "https://registry.yarnpkg.com/string_decoder/-/string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
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
      name = "stringify_object___stringify_object_3.3.0.tgz";
      path = fetchurl {
        name = "stringify_object___stringify_object_3.3.0.tgz";
        url  = "https://registry.yarnpkg.com/stringify-object/-/stringify-object-3.3.0.tgz";
        sha1 = "703065aefca19300d3ce88af4f5b3956d7556629";
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
      name = "strip_ansi___strip_ansi_4.0.0.tgz";
      path = fetchurl {
        name = "strip_ansi___strip_ansi_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-4.0.0.tgz";
        sha1 = "a8479022eb1ac368a871389b635262c505ee368f";
      };
    }

    {
      name = "strip_ansi___strip_ansi_5.2.0.tgz";
      path = fetchurl {
        name = "strip_ansi___strip_ansi_5.2.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-5.2.0.tgz";
        sha1 = "8c9a536feb6afc962bdfa5b104a5091c1ad9c0ae";
      };
    }

    {
      name = "strip_ansi___strip_ansi_6.0.0.tgz";
      path = fetchurl {
        name = "strip_ansi___strip_ansi_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.0.tgz";
        sha1 = "0b1571dd7669ccd4f3e06e14ef1eed26225ae532";
      };
    }

    {
      name = "strip_bom___strip_bom_3.0.0.tgz";
      path = fetchurl {
        name = "strip_bom___strip_bom_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz";
        sha1 = "2334c18e9c759f7bdd56fdef7e9ae3d588e68ed3";
      };
    }

    {
      name = "strip_eof___strip_eof_1.0.0.tgz";
      path = fetchurl {
        name = "strip_eof___strip_eof_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-eof/-/strip-eof-1.0.0.tgz";
        sha1 = "bb43ff5598a6eb05d89b59fcd129c983313606bf";
      };
    }

    {
      name = "strip_final_newline___strip_final_newline_2.0.0.tgz";
      path = fetchurl {
        name = "strip_final_newline___strip_final_newline_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/strip-final-newline/-/strip-final-newline-2.0.0.tgz";
        sha1 = "89b852fb2fcbe936f6f4b3187afb0a12c1ab58ad";
      };
    }

    {
      name = "strip_json_comments___strip_json_comments_2.0.1.tgz";
      path = fetchurl {
        name = "strip_json_comments___strip_json_comments_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz";
        sha1 = "3c531942e908c2697c0ec344858c286c7ca0a60a";
      };
    }

    {
      name = "superagent___superagent_3.8.3.tgz";
      path = fetchurl {
        name = "superagent___superagent_3.8.3.tgz";
        url  = "https://registry.yarnpkg.com/superagent/-/superagent-3.8.3.tgz";
        sha1 = "460ea0dbdb7d5b11bc4f78deba565f86a178e128";
      };
    }

    {
      name = "supertest___supertest_4.0.2.tgz";
      path = fetchurl {
        name = "supertest___supertest_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/supertest/-/supertest-4.0.2.tgz";
        sha1 = "c2234dbdd6dc79b6f15b99c8d6577b90e4ce3f36";
      };
    }

    {
      name = "supports_color___supports_color_6.0.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-6.0.0.tgz";
        sha1 = "76cfe742cf1f41bb9b1c29ad03068c05b4c0e40a";
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
      name = "supports_color___supports_color_5.5.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_5.5.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz";
        sha1 = "e2e69a44ac8772f78a1ec0b35b689df6530efc8f";
      };
    }

    {
      name = "supports_color___supports_color_6.1.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_6.1.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-6.1.0.tgz";
        sha1 = "0764abc69c63d5ac842dd4867e8d025e880df8f3";
      };
    }

    {
      name = "supports_color___supports_color_7.1.0.tgz";
      path = fetchurl {
        name = "supports_color___supports_color_7.1.0.tgz";
        url  = "https://registry.yarnpkg.com/supports-color/-/supports-color-7.1.0.tgz";
        sha1 = "68e32591df73e25ad1c4b49108a2ec507962bfd1";
      };
    }

    {
      name = "swagger_cli___swagger_cli_2.3.5.tgz";
      path = fetchurl {
        name = "swagger_cli___swagger_cli_2.3.5.tgz";
        url  = "https://registry.yarnpkg.com/swagger-cli/-/swagger-cli-2.3.5.tgz";
        sha1 = "a7ae08ae9abe4cc4aaab0334c57166a2cb377fd3";
      };
    }

    {
      name = "swagger_methods___swagger_methods_2.0.2.tgz";
      path = fetchurl {
        name = "swagger_methods___swagger_methods_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/swagger-methods/-/swagger-methods-2.0.2.tgz";
        sha1 = "5891d5536e54d5ba8e7ae1007acc9170f41c9590";
      };
    }

    {
      name = "swagger_parser___swagger_parser_8.0.4.tgz";
      path = fetchurl {
        name = "swagger_parser___swagger_parser_8.0.4.tgz";
        url  = "https://registry.yarnpkg.com/swagger-parser/-/swagger-parser-8.0.4.tgz";
        sha1 = "ddec68723d13ee3748dd08fd5b7ba579327595da";
      };
    }

    {
      name = "symbol_observable___symbol_observable_1.2.0.tgz";
      path = fetchurl {
        name = "symbol_observable___symbol_observable_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-1.2.0.tgz";
        sha1 = "c22688aed4eab3cdc2dfeacbb561660560a00804";
      };
    }

    {
      name = "tar_fs___tar_fs_2.0.0.tgz";
      path = fetchurl {
        name = "tar_fs___tar_fs_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/tar-fs/-/tar-fs-2.0.0.tgz";
        sha1 = "677700fc0c8b337a78bee3623fdc235f21d7afad";
      };
    }

    {
      name = "tar_stream___tar_stream_2.1.0.tgz";
      path = fetchurl {
        name = "tar_stream___tar_stream_2.1.0.tgz";
        url  = "https://registry.yarnpkg.com/tar-stream/-/tar-stream-2.1.0.tgz";
        sha1 = "d1aaa3661f05b38b5acc9b7020efdca5179a2cc3";
      };
    }

    {
      name = "tar___tar_4.4.13.tgz";
      path = fetchurl {
        name = "tar___tar_4.4.13.tgz";
        url  = "https://registry.yarnpkg.com/tar/-/tar-4.4.13.tgz";
        sha1 = "43b364bc52888d555298637b10d60790254ab525";
      };
    }

    {
      name = "tar___tar_5.0.5.tgz";
      path = fetchurl {
        name = "tar___tar_5.0.5.tgz";
        url  = "https://registry.yarnpkg.com/tar/-/tar-5.0.5.tgz";
        sha1 = "03fcdb7105bc8ea3ce6c86642b9c942495b04f93";
      };
    }

    {
      name = "term_size___term_size_1.2.0.tgz";
      path = fetchurl {
        name = "term_size___term_size_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/term-size/-/term-size-1.2.0.tgz";
        sha1 = "458b83887f288fc56d6fffbfad262e26638efa69";
      };
    }

    {
      name = "text_hex___text_hex_1.0.0.tgz";
      path = fetchurl {
        name = "text_hex___text_hex_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/text-hex/-/text-hex-1.0.0.tgz";
        sha1 = "69dc9c1b17446ee79a92bf5b884bb4b9127506f5";
      };
    }

    {
      name = "thirty_two___thirty_two_1.0.2.tgz";
      path = fetchurl {
        name = "thirty_two___thirty_two_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/thirty-two/-/thirty-two-1.0.2.tgz";
        sha1 = "4ca2fffc02a51290d2744b9e3f557693ca6b627a";
      };
    }

    {
      name = "through2___through2_0.6.5.tgz";
      path = fetchurl {
        name = "through2___through2_0.6.5.tgz";
        url  = "https://registry.yarnpkg.com/through2/-/through2-0.6.5.tgz";
        sha1 = "41ab9c67b29d57209071410e1d7a7a968cd3ad48";
      };
    }

    {
      name = "through2___through2_1.1.1.tgz";
      path = fetchurl {
        name = "through2___through2_1.1.1.tgz";
        url  = "https://registry.yarnpkg.com/through2/-/through2-1.1.1.tgz";
        sha1 = "0847cbc4449f3405574dbdccd9bb841b83ac3545";
      };
    }

    {
      name = "through2___through2_2.0.5.tgz";
      path = fetchurl {
        name = "through2___through2_2.0.5.tgz";
        url  = "https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz";
        sha1 = "01c1e39eb31d07cb7d03a96a70823260b23132cd";
      };
    }

    {
      name = "through___through_2.3.8.tgz";
      path = fetchurl {
        name = "through___through_2.3.8.tgz";
        url  = "https://registry.yarnpkg.com/through/-/through-2.3.8.tgz";
        sha1 = "0dd4c9ffaabc357960b1b724115d7e0e86a2e1f5";
      };
    }

    {
      name = "thunky___thunky_1.1.0.tgz";
      path = fetchurl {
        name = "thunky___thunky_1.1.0.tgz";
        url  = "https://registry.yarnpkg.com/thunky/-/thunky-1.1.0.tgz";
        sha1 = "5abaf714a9405db0504732bbccd2cedd9ef9537d";
      };
    }

    {
      name = "timed_out___timed_out_4.0.1.tgz";
      path = fetchurl {
        name = "timed_out___timed_out_4.0.1.tgz";
        url  = "https://registry.yarnpkg.com/timed-out/-/timed-out-4.0.1.tgz";
        sha1 = "f32eacac5a175bea25d7fab565ab3ed8741ef56f";
      };
    }

    {
      name = "timers_ext___timers_ext_0.1.7.tgz";
      path = fetchurl {
        name = "timers_ext___timers_ext_0.1.7.tgz";
        url  = "https://registry.yarnpkg.com/timers-ext/-/timers-ext-0.1.7.tgz";
        sha1 = "6f57ad8578e07a3fb9f91d9387d65647555e25c6";
      };
    }

    {
      name = "tmp___tmp_0.0.33.tgz";
      path = fetchurl {
        name = "tmp___tmp_0.0.33.tgz";
        url  = "https://registry.yarnpkg.com/tmp/-/tmp-0.0.33.tgz";
        sha1 = "6d34335889768d21b2bcda0aa277ced3b1bfadf9";
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
      name = "to_arraybuffer___to_arraybuffer_1.0.1.tgz";
      path = fetchurl {
        name = "to_arraybuffer___to_arraybuffer_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz";
        sha1 = "7d229b1fcc637e466ca081180836a7aabff83f43";
      };
    }

    {
      name = "to_regex_range___to_regex_range_5.0.1.tgz";
      path = fetchurl {
        name = "to_regex_range___to_regex_range_5.0.1.tgz";
        url  = "https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz";
        sha1 = "1648c44aae7c8d988a326018ed72f5b4dd0392e4";
      };
    }

    {
      name = "to_utf_8___to_utf_8_1.3.0.tgz";
      path = fetchurl {
        name = "to_utf_8___to_utf_8_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/to-utf-8/-/to-utf-8-1.3.0.tgz";
        sha1 = "b2af7be9e003f4c3817cc116d3baed2a054993c9";
      };
    }

    {
      name = "toidentifier___toidentifier_1.0.0.tgz";
      path = fetchurl {
        name = "toidentifier___toidentifier_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/toidentifier/-/toidentifier-1.0.0.tgz";
        sha1 = "7e1be3470f1e77948bc43d94a3c8f4d7752ba553";
      };
    }

    {
      name = "toposort_class___toposort_class_1.0.1.tgz";
      path = fetchurl {
        name = "toposort_class___toposort_class_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/toposort-class/-/toposort-class-1.0.1.tgz";
        sha1 = "7ffd1f78c8be28c3ba45cd4e1a3f5ee193bd9988";
      };
    }

    {
      name = "torrent_discovery___torrent_discovery_9.2.1.tgz";
      path = fetchurl {
        name = "torrent_discovery___torrent_discovery_9.2.1.tgz";
        url  = "https://registry.yarnpkg.com/torrent-discovery/-/torrent-discovery-9.2.1.tgz";
        sha1 = "afeac808487f5180be98ce2f3e4b0abc93c7b6b7";
      };
    }

    {
      name = "torrent_piece___torrent_piece_2.0.0.tgz";
      path = fetchurl {
        name = "torrent_piece___torrent_piece_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/torrent-piece/-/torrent-piece-2.0.0.tgz";
        sha1 = "6598ae67d93699e887f178db267ba16d89d7ec9b";
      };
    }

    {
      name = "touch___touch_3.1.0.tgz";
      path = fetchurl {
        name = "touch___touch_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/touch/-/touch-3.1.0.tgz";
        sha1 = "fe365f5f75ec9ed4e56825e0bb76d24ab74af83b";
      };
    }

    {
      name = "tough_cookie___tough_cookie_2.4.3.tgz";
      path = fetchurl {
        name = "tough_cookie___tough_cookie_2.4.3.tgz";
        url  = "https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-2.4.3.tgz";
        sha1 = "53f36da3f47783b0925afa06ff9f3b165280f781";
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
      name = "tree_kill___tree_kill_1.2.2.tgz";
      path = fetchurl {
        name = "tree_kill___tree_kill_1.2.2.tgz";
        url  = "https://registry.yarnpkg.com/tree-kill/-/tree-kill-1.2.2.tgz";
        sha1 = "4ca09a9092c88b73a7cdc5e8a01b507b0790a0cc";
      };
    }

    {
      name = "triple_beam___triple_beam_1.3.0.tgz";
      path = fetchurl {
        name = "triple_beam___triple_beam_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/triple-beam/-/triple-beam-1.3.0.tgz";
        sha1 = "a595214c7298db8339eeeee083e4d10bd8cb8dd9";
      };
    }

    {
      name = "ts_node___ts_node_8.5.4.tgz";
      path = fetchurl {
        name = "ts_node___ts_node_8.5.4.tgz";
        url  = "https://registry.yarnpkg.com/ts-node/-/ts-node-8.5.4.tgz";
        sha1 = "a152add11fa19c221d0b48962c210cf467262ab2";
      };
    }

    {
      name = "tsconfig_paths___tsconfig_paths_3.9.0.tgz";
      path = fetchurl {
        name = "tsconfig_paths___tsconfig_paths_3.9.0.tgz";
        url  = "https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.9.0.tgz";
        sha1 = "098547a6c4448807e8fcb8eae081064ee9a3c90b";
      };
    }

    {
      name = "tslib___tslib_1.9.0.tgz";
      path = fetchurl {
        name = "tslib___tslib_1.9.0.tgz";
        url  = "https://registry.yarnpkg.com/tslib/-/tslib-1.9.0.tgz";
        sha1 = "e37a86fda8cbbaf23a057f473c9f4dc64e5fc2e8";
      };
    }

    {
      name = "tslib___tslib_1.10.0.tgz";
      path = fetchurl {
        name = "tslib___tslib_1.10.0.tgz";
        url  = "https://registry.yarnpkg.com/tslib/-/tslib-1.10.0.tgz";
        sha1 = "c3c19f95973fb0a62973fb09d90d961ee43e5c8a";
      };
    }

    {
      name = "tslint_config_standard___tslint_config_standard_9.0.0.tgz";
      path = fetchurl {
        name = "tslint_config_standard___tslint_config_standard_9.0.0.tgz";
        url  = "https://registry.yarnpkg.com/tslint-config-standard/-/tslint-config-standard-9.0.0.tgz";
        sha1 = "349a94819d93d5f8d803e3c71cb58ef38eff88e0";
      };
    }

    {
      name = "tslint_eslint_rules___tslint_eslint_rules_5.4.0.tgz";
      path = fetchurl {
        name = "tslint_eslint_rules___tslint_eslint_rules_5.4.0.tgz";
        url  = "https://registry.yarnpkg.com/tslint-eslint-rules/-/tslint-eslint-rules-5.4.0.tgz";
        sha1 = "e488cc9181bf193fe5cd7bfca213a7695f1737b5";
      };
    }

    {
      name = "tslint___tslint_5.20.1.tgz";
      path = fetchurl {
        name = "tslint___tslint_5.20.1.tgz";
        url  = "https://registry.yarnpkg.com/tslint/-/tslint-5.20.1.tgz";
        sha1 = "e401e8aeda0152bc44dd07e614034f3f80c67b7d";
      };
    }

    {
      name = "tsutils___tsutils_2.29.0.tgz";
      path = fetchurl {
        name = "tsutils___tsutils_2.29.0.tgz";
        url  = "https://registry.yarnpkg.com/tsutils/-/tsutils-2.29.0.tgz";
        sha1 = "32b488501467acbedd4b85498673a0812aca0b99";
      };
    }

    {
      name = "tsutils___tsutils_3.17.1.tgz";
      path = fetchurl {
        name = "tsutils___tsutils_3.17.1.tgz";
        url  = "https://registry.yarnpkg.com/tsutils/-/tsutils-3.17.1.tgz";
        sha1 = "ed719917f11ca0dee586272b2ac49e015a2dd759";
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
      name = "tv4___tv4_1.3.0.tgz";
      path = fetchurl {
        name = "tv4___tv4_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/tv4/-/tv4-1.3.0.tgz";
        sha1 = "d020c846fadd50c855abb25ebaecc68fc10f7963";
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
      name = "type_detect___type_detect_0.1.1.tgz";
      path = fetchurl {
        name = "type_detect___type_detect_0.1.1.tgz";
        url  = "https://registry.yarnpkg.com/type-detect/-/type-detect-0.1.1.tgz";
        sha1 = "0ba5ec2a885640e470ea4e8505971900dac58822";
      };
    }

    {
      name = "type_detect___type_detect_4.0.8.tgz";
      path = fetchurl {
        name = "type_detect___type_detect_4.0.8.tgz";
        url  = "https://registry.yarnpkg.com/type-detect/-/type-detect-4.0.8.tgz";
        sha1 = "7646fb5f18871cfbb7749e69bd39a6388eb7450c";
      };
    }

    {
      name = "type_is___type_is_1.6.15.tgz";
      path = fetchurl {
        name = "type_is___type_is_1.6.15.tgz";
        url  = "https://registry.yarnpkg.com/type-is/-/type-is-1.6.15.tgz";
        sha1 = "cab10fb4909e441c82842eafe1ad646c81804410";
      };
    }

    {
      name = "type_is___type_is_1.6.18.tgz";
      path = fetchurl {
        name = "type_is___type_is_1.6.18.tgz";
        url  = "https://registry.yarnpkg.com/type-is/-/type-is-1.6.18.tgz";
        sha1 = "4e552cd05df09467dcbc4ef739de89f2cf37c131";
      };
    }

    {
      name = "type___type_1.2.0.tgz";
      path = fetchurl {
        name = "type___type_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/type/-/type-1.2.0.tgz";
        sha1 = "848dd7698dafa3e54a6c479e759c4bc3f18847a0";
      };
    }

    {
      name = "type___type_2.0.0.tgz";
      path = fetchurl {
        name = "type___type_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/type/-/type-2.0.0.tgz";
        sha1 = "5f16ff6ef2eb44f260494dae271033b29c09a9c3";
      };
    }

    {
      name = "typedarray_to_buffer___typedarray_to_buffer_3.1.5.tgz";
      path = fetchurl {
        name = "typedarray_to_buffer___typedarray_to_buffer_3.1.5.tgz";
        url  = "https://registry.yarnpkg.com/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz";
        sha1 = "a97ee7a9ff42691b9f783ff1bc5112fe3fca9080";
      };
    }

    {
      name = "typedarray___typedarray_0.0.6.tgz";
      path = fetchurl {
        name = "typedarray___typedarray_0.0.6.tgz";
        url  = "https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz";
        sha1 = "867ac74e3864187b1d3d47d996a78ec5c8830777";
      };
    }

    {
      name = "typescript___typescript_3.7.4.tgz";
      path = fetchurl {
        name = "typescript___typescript_3.7.4.tgz";
        url  = "https://registry.yarnpkg.com/typescript/-/typescript-3.7.4.tgz";
        sha1 = "1743a5ec5fef6a1fa9f3e4708e33c81c73876c19";
      };
    }

    {
      name = "uint64be___uint64be_2.0.2.tgz";
      path = fetchurl {
        name = "uint64be___uint64be_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/uint64be/-/uint64be-2.0.2.tgz";
        sha1 = "ef4a179752fe8f9ddaa29544ecfc13490031e8e5";
      };
    }

    {
      name = "undefsafe___undefsafe_2.0.2.tgz";
      path = fetchurl {
        name = "undefsafe___undefsafe_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/undefsafe/-/undefsafe-2.0.2.tgz";
        sha1 = "225f6b9e0337663e0d8e7cfd686fc2836ccace76";
      };
    }

    {
      name = "uniq___uniq_1.0.1.tgz";
      path = fetchurl {
        name = "uniq___uniq_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/uniq/-/uniq-1.0.1.tgz";
        sha1 = "b31c5ae8254844a3a8281541ce2b04b865a734ff";
      };
    }

    {
      name = "unique_string___unique_string_1.0.0.tgz";
      path = fetchurl {
        name = "unique_string___unique_string_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unique-string/-/unique-string-1.0.0.tgz";
        sha1 = "9e1057cca851abb93398f8b33ae187b99caec11a";
      };
    }

    {
      name = "universalify___universalify_0.1.2.tgz";
      path = fetchurl {
        name = "universalify___universalify_0.1.2.tgz";
        url  = "https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz";
        sha1 = "b646f69be3942dabcecc9d6639c80dc105efaa66";
      };
    }

    {
      name = "unordered_array_remove___unordered_array_remove_1.0.2.tgz";
      path = fetchurl {
        name = "unordered_array_remove___unordered_array_remove_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/unordered-array-remove/-/unordered-array-remove-1.0.2.tgz";
        sha1 = "c546e8f88e317a0cf2644c97ecb57dba66d250ef";
      };
    }

    {
      name = "unpipe___unpipe_1.0.0.tgz";
      path = fetchurl {
        name = "unpipe___unpipe_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/unpipe/-/unpipe-1.0.0.tgz";
        sha1 = "b2bf4ee8514aae6165b4817829d21b2ef49904ec";
      };
    }

    {
      name = "unzip_response___unzip_response_2.0.1.tgz";
      path = fetchurl {
        name = "unzip_response___unzip_response_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/unzip-response/-/unzip-response-2.0.1.tgz";
        sha1 = "d2f0f737d16b0615e72a6935ed04214572d56f97";
      };
    }

    {
      name = "update_notifier___update_notifier_2.5.0.tgz";
      path = fetchurl {
        name = "update_notifier___update_notifier_2.5.0.tgz";
        url  = "https://registry.yarnpkg.com/update-notifier/-/update-notifier-2.5.0.tgz";
        sha1 = "d0744593e13f161e406acb1d9408b72cad08aff6";
      };
    }

    {
      name = "uri_js___uri_js_4.2.2.tgz";
      path = fetchurl {
        name = "uri_js___uri_js_4.2.2.tgz";
        url  = "https://registry.yarnpkg.com/uri-js/-/uri-js-4.2.2.tgz";
        sha1 = "94c540e1ff772956e2299507c010aea6c8838eb0";
      };
    }

    {
      name = "url_parse_lax___url_parse_lax_1.0.0.tgz";
      path = fetchurl {
        name = "url_parse_lax___url_parse_lax_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/url-parse-lax/-/url-parse-lax-1.0.0.tgz";
        sha1 = "7af8f303645e9bd79a272e7a14ac68bc0609da73";
      };
    }

    {
      name = "useragent___useragent_2.3.0.tgz";
      path = fetchurl {
        name = "useragent___useragent_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/useragent/-/useragent-2.3.0.tgz";
        sha1 = "217f943ad540cb2128658ab23fc960f6a88c9972";
      };
    }

    {
      name = "ut_metadata___ut_metadata_3.5.0.tgz";
      path = fetchurl {
        name = "ut_metadata___ut_metadata_3.5.0.tgz";
        url  = "https://registry.yarnpkg.com/ut_metadata/-/ut_metadata-3.5.0.tgz";
        sha1 = "02d954bbbbf48c8563510ff2dae9f65f6b4f5fa3";
      };
    }

    {
      name = "ut_pex___ut_pex_2.0.0.tgz";
      path = fetchurl {
        name = "ut_pex___ut_pex_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/ut_pex/-/ut_pex-2.0.0.tgz";
        sha1 = "d0c6f2d3d5ee98f38ee004ee852b390d1e7c9ac8";
      };
    }

    {
      name = "utf_8_validate___utf_8_validate_5.0.2.tgz";
      path = fetchurl {
        name = "utf_8_validate___utf_8_validate_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/utf-8-validate/-/utf-8-validate-5.0.2.tgz";
        sha1 = "63cfbccd85dc1f2b66cf7a1d0eebc08ed056bfb3";
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
      name = "util.promisify___util.promisify_1.0.0.tgz";
      path = fetchurl {
        name = "util.promisify___util.promisify_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/util.promisify/-/util.promisify-1.0.0.tgz";
        sha1 = "440f7165a459c9a16dc145eb8e72f35687097030";
      };
    }

    {
      name = "utile___utile_0.3.0.tgz";
      path = fetchurl {
        name = "utile___utile_0.3.0.tgz";
        url  = "https://registry.yarnpkg.com/utile/-/utile-0.3.0.tgz";
        sha1 = "1352c340eb820e4d8ddba039a4fbfaa32ed4ef3a";
      };
    }

    {
      name = "utils_merge___utils_merge_1.0.1.tgz";
      path = fetchurl {
        name = "utils_merge___utils_merge_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/utils-merge/-/utils-merge-1.0.1.tgz";
        sha1 = "9f95710f50a267947b2ccc124741c1028427e713";
      };
    }

    {
      name = "uue___uue_3.1.2.tgz";
      path = fetchurl {
        name = "uue___uue_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/uue/-/uue-3.1.2.tgz";
        sha1 = "e99368414e87200012eb37de4dbaebaa1c742ad2";
      };
    }

    {
      name = "uuid___uuid_3.3.3.tgz";
      path = fetchurl {
        name = "uuid___uuid_3.3.3.tgz";
        url  = "https://registry.yarnpkg.com/uuid/-/uuid-3.3.3.tgz";
        sha1 = "4568f0216e78760ee1dbf3a4d2cf53e224112866";
      };
    }

    {
      name = "validate_npm_package_license___validate_npm_package_license_3.0.4.tgz";
      path = fetchurl {
        name = "validate_npm_package_license___validate_npm_package_license_3.0.4.tgz";
        url  = "https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz";
        sha1 = "fc91f6b9c7ba15c857f4cb2c5defeec39d4f410a";
      };
    }

    {
      name = "validator___validator_10.11.0.tgz";
      path = fetchurl {
        name = "validator___validator_10.11.0.tgz";
        url  = "https://registry.yarnpkg.com/validator/-/validator-10.11.0.tgz";
        sha1 = "003108ea6e9a9874d31ccc9e5006856ccd76b228";
      };
    }

    {
      name = "validator___validator_11.1.0.tgz";
      path = fetchurl {
        name = "validator___validator_11.1.0.tgz";
        url  = "https://registry.yarnpkg.com/validator/-/validator-11.1.0.tgz";
        sha1 = "ac18cac42e0aa5902b603d7a5d9b7827e2346ac4";
      };
    }

    {
      name = "validator___validator_12.1.0.tgz";
      path = fetchurl {
        name = "validator___validator_12.1.0.tgz";
        url  = "https://registry.yarnpkg.com/validator/-/validator-12.1.0.tgz";
        sha1 = "a3a7315d5238cbc15e46ad8d5e479aafa7119925";
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
      name = "vasync___vasync_1.6.4.tgz";
      path = fetchurl {
        name = "vasync___vasync_1.6.4.tgz";
        url  = "https://registry.yarnpkg.com/vasync/-/vasync-1.6.4.tgz";
        sha1 = "dfe93616ad0e7ae801b332a9d88bfc5cdc8e1d1f";
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

    {
      name = "verror___verror_1.6.0.tgz";
      path = fetchurl {
        name = "verror___verror_1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/verror/-/verror-1.6.0.tgz";
        sha1 = "7d13b27b1facc2e2da90405eb5ea6e5bdd252ea5";
      };
    }

    {
      name = "videostream___videostream_3.2.1.tgz";
      path = fetchurl {
        name = "videostream___videostream_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/videostream/-/videostream-3.2.1.tgz";
        sha1 = "643688ad4bfbf37570d421e3196b7e0ad38eeebc";
      };
    }

    {
      name = "webfinger.js___webfinger.js_2.7.0.tgz";
      path = fetchurl {
        name = "webfinger.js___webfinger.js_2.7.0.tgz";
        url  = "https://registry.yarnpkg.com/webfinger.js/-/webfinger.js-2.7.0.tgz";
        sha1 = "403354a14a65aeeba64c1408c18a387487cea106";
      };
    }

    {
      name = "webtorrent___webtorrent_0.107.17.tgz";
      path = fetchurl {
        name = "webtorrent___webtorrent_0.107.17.tgz";
        url  = "https://registry.yarnpkg.com/webtorrent/-/webtorrent-0.107.17.tgz";
        sha1 = "26e8cd71aab0d62adc0b33850953aeed4570011d";
      };
    }

    {
      name = "which_module___which_module_2.0.0.tgz";
      path = fetchurl {
        name = "which_module___which_module_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/which-module/-/which-module-2.0.0.tgz";
        sha1 = "d9ef07dce77b9902b8a3a8fa4b31c3e3f7e6e87a";
      };
    }

    {
      name = "which_pm_runs___which_pm_runs_1.0.0.tgz";
      path = fetchurl {
        name = "which_pm_runs___which_pm_runs_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/which-pm-runs/-/which-pm-runs-1.0.0.tgz";
        sha1 = "670b3afbc552e0b55df6b7780ca74615f23ad1cb";
      };
    }

    {
      name = "which___which_1.3.1.tgz";
      path = fetchurl {
        name = "which___which_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-1.3.1.tgz";
        sha1 = "a45043d54f5805316da8d62f9f50918d3da70b0a";
      };
    }

    {
      name = "which___which_2.0.2.tgz";
      path = fetchurl {
        name = "which___which_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-2.0.2.tgz";
        sha1 = "7c6a8dd0a636a0327e10b59c9286eee93f3f51b1";
      };
    }

    {
      name = "wide_align___wide_align_1.1.3.tgz";
      path = fetchurl {
        name = "wide_align___wide_align_1.1.3.tgz";
        url  = "https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.3.tgz";
        sha1 = "ae074e6bdc0c14a431e804e624549c633b000457";
      };
    }

    {
      name = "widest_line___widest_line_2.0.1.tgz";
      path = fetchurl {
        name = "widest_line___widest_line_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/widest-line/-/widest-line-2.0.1.tgz";
        sha1 = "7438764730ec7ef4381ce4df82fb98a53142a3fc";
      };
    }

    {
      name = "wildstring___wildstring_1.0.9.tgz";
      path = fetchurl {
        name = "wildstring___wildstring_1.0.9.tgz";
        url  = "https://registry.yarnpkg.com/wildstring/-/wildstring-1.0.9.tgz";
        sha1 = "82a696d5653c7d4ec9ba716859b6b53aba2761c5";
      };
    }

    {
      name = "winston_transport___winston_transport_4.3.0.tgz";
      path = fetchurl {
        name = "winston_transport___winston_transport_4.3.0.tgz";
        url  = "https://registry.yarnpkg.com/winston-transport/-/winston-transport-4.3.0.tgz";
        sha1 = "df68c0c202482c448d9b47313c07304c2d7c2c66";
      };
    }

    {
      name = "winston___winston_2.1.1.tgz";
      path = fetchurl {
        name = "winston___winston_2.1.1.tgz";
        url  = "https://registry.yarnpkg.com/winston/-/winston-2.1.1.tgz";
        sha1 = "3c9349d196207fd1bdff9d4bc43ef72510e3a12e";
      };
    }

    {
      name = "winston___winston_3.2.1.tgz";
      path = fetchurl {
        name = "winston___winston_3.2.1.tgz";
        url  = "https://registry.yarnpkg.com/winston/-/winston-3.2.1.tgz";
        sha1 = "63061377976c73584028be2490a1846055f77f07";
      };
    }

    {
      name = "wkx___wkx_0.4.8.tgz";
      path = fetchurl {
        name = "wkx___wkx_0.4.8.tgz";
        url  = "https://registry.yarnpkg.com/wkx/-/wkx-0.4.8.tgz";
        sha1 = "a092cf088d112683fdc7182fd31493b2c5820003";
      };
    }

    {
      name = "wrap_ansi___wrap_ansi_3.0.1.tgz";
      path = fetchurl {
        name = "wrap_ansi___wrap_ansi_3.0.1.tgz";
        url  = "https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-3.0.1.tgz";
        sha1 = "288a04d87eda5c286e060dfe8f135ce8d007f8ba";
      };
    }

    {
      name = "wrap_ansi___wrap_ansi_5.1.0.tgz";
      path = fetchurl {
        name = "wrap_ansi___wrap_ansi_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-5.1.0.tgz";
        sha1 = "1fd1f67235d5b6d0fee781056001bfb694c03b09";
      };
    }

    {
      name = "wrap_ansi___wrap_ansi_6.2.0.tgz";
      path = fetchurl {
        name = "wrap_ansi___wrap_ansi_6.2.0.tgz";
        url  = "https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-6.2.0.tgz";
        sha1 = "e9393ba07102e6c91a3b221478f0257cd2856e53";
      };
    }

    {
      name = "wrappy___wrappy_1.0.2.tgz";
      path = fetchurl {
        name = "wrappy___wrappy_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz";
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    }

    {
      name = "write_file_atomic___write_file_atomic_2.4.3.tgz";
      path = fetchurl {
        name = "write_file_atomic___write_file_atomic_2.4.3.tgz";
        url  = "https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-2.4.3.tgz";
        sha1 = "1fd2e9ae1df3e75b8d8c367443c692d4ca81f481";
      };
    }

    {
      name = "ws___ws_7.2.1.tgz";
      path = fetchurl {
        name = "ws___ws_7.2.1.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-7.2.1.tgz";
        sha1 = "03ed52423cd744084b2cf42ed197c8b65a936b8e";
      };
    }

    {
      name = "ws___ws_6.1.4.tgz";
      path = fetchurl {
        name = "ws___ws_6.1.4.tgz";
        url  = "https://registry.yarnpkg.com/ws/-/ws-6.1.4.tgz";
        sha1 = "5b5c8800afab925e94ccb29d153c8d02c1776ef9";
      };
    }

    {
      name = "x_xss_protection___x_xss_protection_1.3.0.tgz";
      path = fetchurl {
        name = "x_xss_protection___x_xss_protection_1.3.0.tgz";
        url  = "https://registry.yarnpkg.com/x-xss-protection/-/x-xss-protection-1.3.0.tgz";
        sha1 = "3e3a8dd638da80421b0e9fff11a2dbe168f6d52c";
      };
    }

    {
      name = "xdg_basedir___xdg_basedir_3.0.0.tgz";
      path = fetchurl {
        name = "xdg_basedir___xdg_basedir_3.0.0.tgz";
        url  = "https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-3.0.0.tgz";
        sha1 = "496b2cc109eca8dbacfe2dc72b603c17c5870ad4";
      };
    }

    {
      name = "xhr2___xhr2_0.1.4.tgz";
      path = fetchurl {
        name = "xhr2___xhr2_0.1.4.tgz";
        url  = "https://registry.yarnpkg.com/xhr2/-/xhr2-0.1.4.tgz";
        sha1 = "7f87658847716db5026323812f818cadab387a5f";
      };
    }

    {
      name = "xliff___xliff_4.3.2.tgz";
      path = fetchurl {
        name = "xliff___xliff_4.3.2.tgz";
        url  = "https://registry.yarnpkg.com/xliff/-/xliff-4.3.2.tgz";
        sha1 = "ef9655abce99f4c60efbc8b6d019c3c55e543315";
      };
    }

    {
      name = "xml_js___xml_js_1.6.11.tgz";
      path = fetchurl {
        name = "xml_js___xml_js_1.6.11.tgz";
        url  = "https://registry.yarnpkg.com/xml-js/-/xml-js-1.6.11.tgz";
        sha1 = "927d2f6947f7f1c19a316dd8eea3614e8b18f8e9";
      };
    }

    {
      name = "xml2js___xml2js_0.4.23.tgz";
      path = fetchurl {
        name = "xml2js___xml2js_0.4.23.tgz";
        url  = "https://registry.yarnpkg.com/xml2js/-/xml2js-0.4.23.tgz";
        sha1 = "a0c69516752421eb2ac758ee4d4ccf58843eac66";
      };
    }

    {
      name = "xml___xml_1.0.1.tgz";
      path = fetchurl {
        name = "xml___xml_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/xml/-/xml-1.0.1.tgz";
        sha1 = "78ba72020029c5bc87b8a81a3cfcd74b4a2fc1e5";
      };
    }

    {
      name = "xmlbuilder___xmlbuilder_13.0.2.tgz";
      path = fetchurl {
        name = "xmlbuilder___xmlbuilder_13.0.2.tgz";
        url  = "https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-13.0.2.tgz";
        sha1 = "02ae33614b6a047d1c32b5389c1fdacb2bce47a7";
      };
    }

    {
      name = "xmlbuilder___xmlbuilder_11.0.1.tgz";
      path = fetchurl {
        name = "xmlbuilder___xmlbuilder_11.0.1.tgz";
        url  = "https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-11.0.1.tgz";
        sha1 = "be9bae1c8a046e76b31127726347d0ad7002beb3";
      };
    }

    {
      name = "xmldom___xmldom_0.1.19.tgz";
      path = fetchurl {
        name = "xmldom___xmldom_0.1.19.tgz";
        url  = "https://registry.yarnpkg.com/xmldom/-/xmldom-0.1.19.tgz";
        sha1 = "631fc07776efd84118bf25171b37ed4d075a0abc";
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
      name = "xtend___xtend_4.0.2.tgz";
      path = fetchurl {
        name = "xtend___xtend_4.0.2.tgz";
        url  = "https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz";
        sha1 = "bb72779f5fa465186b1f438f674fa347fdb5db54";
      };
    }

    {
      name = "y18n___y18n_4.0.0.tgz";
      path = fetchurl {
        name = "y18n___y18n_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/y18n/-/y18n-4.0.0.tgz";
        sha1 = "95ef94f85ecc81d007c264e190a120f0a3c8566b";
      };
    }

    {
      name = "yallist___yallist_2.1.2.tgz";
      path = fetchurl {
        name = "yallist___yallist_2.1.2.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-2.1.2.tgz";
        sha1 = "1c11f9218f076089a47dd512f93c6699a6a81d52";
      };
    }

    {
      name = "yallist___yallist_3.1.1.tgz";
      path = fetchurl {
        name = "yallist___yallist_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-3.1.1.tgz";
        sha1 = "dbb7daf9bfd8bac9ab45ebf602b8cbad0d5d08fd";
      };
    }

    {
      name = "yallist___yallist_4.0.0.tgz";
      path = fetchurl {
        name = "yallist___yallist_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz";
        sha1 = "9bb92790d9c0effec63be73519e11a35019a3a72";
      };
    }

    {
      name = "yargs_parser___yargs_parser_13.1.1.tgz";
      path = fetchurl {
        name = "yargs_parser___yargs_parser_13.1.1.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-13.1.1.tgz";
        sha1 = "d26058532aa06d365fe091f6a1fc06b2f7e5eca0";
      };
    }

    {
      name = "yargs_parser___yargs_parser_16.1.0.tgz";
      path = fetchurl {
        name = "yargs_parser___yargs_parser_16.1.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-16.1.0.tgz";
        sha1 = "73747d53ae187e7b8dbe333f95714c76ea00ecf1";
      };
    }

    {
      name = "yargs_unparser___yargs_unparser_1.6.0.tgz";
      path = fetchurl {
        name = "yargs_unparser___yargs_unparser_1.6.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs-unparser/-/yargs-unparser-1.6.0.tgz";
        sha1 = "ef25c2c769ff6bd09e4b0f9d7c605fb27846ea9f";
      };
    }

    {
      name = "yargs___yargs_13.3.0.tgz";
      path = fetchurl {
        name = "yargs___yargs_13.3.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-13.3.0.tgz";
        sha1 = "4c657a55e07e5f2cf947f8a366567c04a0dedc83";
      };
    }

    {
      name = "yargs___yargs_15.1.0.tgz";
      path = fetchurl {
        name = "yargs___yargs_15.1.0.tgz";
        url  = "https://registry.yarnpkg.com/yargs/-/yargs-15.1.0.tgz";
        sha1 = "e111381f5830e863a89550bd4b136bb6a5f37219";
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

    {
      name = "yn___yn_3.1.1.tgz";
      path = fetchurl {
        name = "yn___yn_3.1.1.tgz";
        url  = "https://registry.yarnpkg.com/yn/-/yn-3.1.1.tgz";
        sha1 = "1e87401a09d767c1d5eab26a6e4c185182d2eb50";
      };
    }

    {
      name = "youtube_dl___youtube_dl_2.3.0.tgz";
      path = fetchurl {
        name = "youtube_dl___youtube_dl_2.3.0.tgz";
        url  = "https://registry.yarnpkg.com/youtube-dl/-/youtube-dl-2.3.0.tgz";
        sha1 = "193d59164e809b2c619b348b7e98b37e6abcf620";
      };
    }

    {
      name = "z_schema___z_schema_4.2.2.tgz";
      path = fetchurl {
        name = "z_schema___z_schema_4.2.2.tgz";
        url  = "https://registry.yarnpkg.com/z-schema/-/z-schema-4.2.2.tgz";
        sha1 = "43fa2709ae5016885db50e1ce31b254b72c0886c";
      };
    }

    {
      name = "zero_fill___zero_fill_2.2.3.tgz";
      path = fetchurl {
        name = "zero_fill___zero_fill_2.2.3.tgz";
        url  = "https://registry.yarnpkg.com/zero-fill/-/zero-fill-2.2.3.tgz";
        sha1 = "a3def06ba5e39ae644850bb4ca2ad4112b4855e9";
      };
    }
  ];
}
