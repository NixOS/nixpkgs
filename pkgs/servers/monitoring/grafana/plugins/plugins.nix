{ callPackage }:
rec {
  inherit callPackage;

  grafanaPlugin = callPackage ./grafana-plugin.nix { };

  aceiot-svg-panel = grafanaPlugin {
    pname = "aceiot-svg-panel";
    version = "0.0.11";
    zipHash = "388e270d9ab1be3c5af05f41a68cfe3348593f4b01686902a29689a07ea030b0";
    meta.description = "SVG Visualization Panel";
  };
  ae3e-plotly-panel = grafanaPlugin {
    pname = "ae3e-plotly-panel";
    version = "0.5.0";
    zipHash = "78d258264e8af64ac1c668257c7f675641db432b18269c61e404771e92ace82e";
    meta.description = "Render chart from any datasource with Plotly javascript library";
  };
  agenty-flowcharting-panel = grafanaPlugin {
    pname = "agenty-flowcharting-panel";
    version = "0.9.1";
    zipHash = "5365e8c6df51432b4b1c7dcdb8fb533410d7802e757c1fa58d7f4f659f289366";
    meta.description = "Flowcharting is a Grafana plugin. Use it to display complexe diagrams using the online graphing library draw.io like a vsio";
  };
  akumuli-datasource = grafanaPlugin {
    pname = "akumuli-datasource";
    version = "1.3.12";
    zipHash = "52fd602e0eae2a11c6cf9e3b35c5e6839a9222a028437457d7ba19006552b264";
    meta.description = "Datasource plugin for Akumuli time-series database";
  };
  alertlist = grafanaPlugin {
    pname = "alertlist";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Shows list of alerts and their current status";
  };
  alertmanager = grafanaPlugin {
    pname = "alertmanager";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "";
  };
  alexanderzobnin-zabbix-app = grafanaPlugin {
    pname = "alexanderzobnin-zabbix-app";
    version = "4.4.4";
    zipHash = {
      x86_64-linux = "5be76e4bfbd0ecae4b5eda73c180e8862a7b3dbe0cab4316d5e03239de93651c";
      aarch64-linux = "4b15cee7e03ecef658e30d2c79330c1011403e8a4180d1a0cf8a188692a9dffb";
      x86_64-darwin = "9e5508b3034ced8d33a25215210184e3e83fbf7edea2af144df39d447ab26893";
      aarch64-darwin = "54adaa3402abded39bfb36ea676ac68de291cd11e3d90508e430e1dc704c214c";
    };
    meta.description = "Zabbix plugin for Grafana";
  };
  alexandra-trackmap-panel = grafanaPlugin {
    pname = "alexandra-trackmap-panel";
    version = "1.2.6";
    zipHash = "0c575600d8d6ec71f977a6f96b4efe82d448c2644d45b2be18f3c6658e7b361b";
    meta.description = "Map plugin to visualize timeseries data from geo:json or NGSIv2 sources as either a Ant-path, Hexbin, or Heatmap.";
  };
  annolist = grafanaPlugin {
    pname = "annolist";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "List annotations";
  };
  anodot-datasource = grafanaPlugin {
    pname = "anodot-datasource";
    version = "4.1.1";
    zipHash = "bf4ea9f5f55a8d242ababd6debd866152d5896a639e9591d200b87ce60d9554b";
    meta.description = "Datasource for anodot-panel plugin";
  };
  anodot-panel = grafanaPlugin {
    pname = "anodot-panel";
    version = "2.0.1";
    zipHash = "7392c5de78dcde1dde9b022e031cb626c6ba5632105d6fb37efb12a56e71f74c";
    meta.description = "Anodot Grafana Panel for usage together with anodot-datasource";
  };
  apache-iotdb-datasource = grafanaPlugin {
    pname = "apache-iotdb-datasource";
    version = "1.0.0";
    zipHash = "7ec09c64245fcc6cbdbbdeef7be721a071d85651bc8f6fa4a755488008ea07ad";
    meta.description = "Apache IoTDB";
  };
  apache-skywalking-datasource = grafanaPlugin {
    pname = "apache-skywalking-datasource";
    version = "0.1.0";
    zipHash = "0bac52584b01757018c0fbba2e299379cead7c45e7ac92ed4af28df2dc50f075";
    meta.description = "Apache SkyWalking";
  };
  aquaqanalytics-kdbbackend-datasource = grafanaPlugin {
    pname = "aquaqanalytics-kdbbackend-datasource";
    version = "1.0.0";
    zipHash = "325ea8534484b74608b0a908d565627d0287719c0222822e9e71526f42ae6a3f";
    meta.description = "AquaQ Analytics' backend adaptor for KX Systems' kdb+ database";
  };
  arabian9ts-gcpstatus-datasource = grafanaPlugin {
    pname = "arabian9ts-gcpstatus-datasource";
    version = "0.1.0";
    zipHash = "20b8c3953cfe84897e3d46a8a638907e6da90d287751bad701ae76ca59ea025c";
    meta.description = "Load GCP incident logs from the status page";
  };
  archilogic-floor-panel = grafanaPlugin {
    pname = "archilogic-floor-panel";
    version = "0.0.1";
    zipHash = "7c9afd27d7ed7cc8902493d4d21add81fe4bb9afa9afa89912de22b9337ee024";
    meta.description = "Floor Plan Visualization";
  };
  auxmoney-waterfall-panel = grafanaPlugin {
    pname = "auxmoney-waterfall-panel";
    version = "1.0.6";
    zipHash = "cf67c19fdca7d2eb73484b1cd78e7217f285e613b21f21c357b3a5e8e74b34ca";
    meta.description = "A waterfall panel for a single time-series";
  };
  aws-datasource-provisioner-app = grafanaPlugin {
    pname = "aws-datasource-provisioner-app";
    version = "1.13.1";
    zipHash = {
      x86_64-linux = "65abeeb102221c3a497aec10ae6ccefa17635ad722b1c60ec869dc3ffc1cb2c5";
      aarch64-linux = "720c08350097a52406de93cc0cf57b783a4a41fa55db019d92b581cc295d733a";
      x86_64-darwin = "7329971c1080946c8aa972ca8d6761b3264adc22b446e21756c58500cbc324a5";
      aarch64-darwin = "2d427d4204c56783dfab25d69e1b12ce0861aa40381245ce6a018df2552032cf";
    };
    meta.description = "AWS Datasource Provisioner";
  };
  axiomhq-axiom-datasource = grafanaPlugin {
    pname = "axiomhq-axiom-datasource";
    version = "0.2.0";
    zipHash = "0bd19bd916c4a8c4710e7180372e18714d22a1c1c256f32b547087a2199932a3";
    meta.description = "Query Axiom through Grafana";
  };
  ayoungprogrammer-finance-datasource = grafanaPlugin {
    pname = "ayoungprogrammer-finance-datasource";
    version = "1.0.1";
    zipHash = "80f8da9c7294d0fca74fad305539f99d657bab83a728c7ba62a05330cf488354";
    meta.description = "Finance data for grafana";
  };
  barchart = grafanaPlugin {
    pname = "barchart";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Categorical charts with group support";
  };
  bargauge = grafanaPlugin {
    pname = "bargauge";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Horizontal and vertical gauges";
  };
  bessler-pictureit-panel = grafanaPlugin {
    pname = "bessler-pictureit-panel";
    version = "1.0.1";
    zipHash = "11314a01ebb1d76723c9720581c82fe2c4874d4c752a55f11917a355c8f23d66";
    meta.description = "Add Measurements to a Picture in Grafana";
  };
  bilibala-echarts-panel = grafanaPlugin {
    pname = "bilibala-echarts-panel";
    version = "2.2.4";
    zipHash = "0b6b3e981a0364e6cea4af67eec09ea91cb3e6f9823a712439494f10f81b9b7a";
    meta.description = "Echarts panel for grafana";
  };
  blackcowmoo-googleanalytics-datasource = grafanaPlugin {
    pname = "blackcowmoo-googleanalytics-datasource";
    version = "0.2.3";
    zipHash = "2180a577c66aeade208a52647bf1981643bc5f23f4161b0270bf605659415b29";
    meta.description = " GoogleAnalytics Visualize & datasource";
  };
  blackmirror1-singlestat-math-panel = grafanaPlugin {
    pname = "blackmirror1-singlestat-math-panel";
    version = "1.1.8";
    zipHash = "eb74f36e53db3472fcde630563936578fe4abc84d99483f32c818e98e43110d5";
    meta.description = "Single Stat panel with math.";
  };
  blackmirror1-statusbygroup-panel = grafanaPlugin {
    pname = "blackmirror1-statusbygroup-panel";
    version = "1.1.2";
    zipHash = "ca6c9bd12bd334aec1c3dbcf11eb7a84dc4f761c5099b7873b040aecd86d272d";
    meta.description = "Status By Group Panel for Grafana";
  };
  boazreicher-mosaicplot-panel = grafanaPlugin {
    pname = "boazreicher-mosaicplot-panel";
    version = "1.0.18";
    zipHash = "041495b94fa684f79746dd2b27544a748963b32119158d7d05f21631df2c892f";
    meta.description = "Mosaic Plot Panel";
  };
  boazreicher-sierraplot-panel = grafanaPlugin {
    pname = "boazreicher-sierraplot-panel";
    version = "1.0.14";
    zipHash = "40d09acfd32ccd760c5fc3f6bacade4c785869e07241c0b62f5670bb55d11e74";
    meta.description = "Sierra Plot Panel";
  };
  bosun-app = grafanaPlugin {
    pname = "bosun-app";
    version = "0.0.29";
    zipHash = "f033b1102ee5313e27c3399c69ba04b72a5df2745a49c7a458ae94fcf30d25a0";
    meta.description = "Bosun Datasource and Bosun Panels";
  };
  briangann-datatable-panel = grafanaPlugin {
    pname = "briangann-datatable-panel";
    version = "1.0.4";
    zipHash = "fedb83c2fb9755d5c3fed9e9603063e377b7fc6dc14c39c801b984f88682549f";
    meta.description = "Datatable panel for Grafana";
  };
  briangann-gauge-panel = grafanaPlugin {
    pname = "briangann-gauge-panel";
    version = "2.0.1";
    zipHash = "6766f659efd73fddb158dca00357ea550a9f16a212e0a3261722a615f785f718";
    meta.description = "D3-based Gauge panel for Grafana";
  };
  bsull-console-datasource = grafanaPlugin {
    pname = "bsull-console-datasource";
    version = "1.0.1";
    zipHash = "57a0ff548770c10bc6db59d53170ffc45f3a532f1645e70bd918f20d366bd704";
    meta.description = "Tokio Console datasource for Grafana";
  };
  bsull-materialize-datasource = grafanaPlugin {
    pname = "bsull-materialize-datasource";
    version = "0.1.1";
    zipHash = "f68177662ad19e07bd292823e9adde1c85e1b41ddbc80eec7982f4c287e49e53";
    meta.description = "Materialize datasource for Grafana";
  };
  camptocamp-prometheus-alertmanager-datasource = grafanaPlugin {
    pname = "camptocamp-prometheus-alertmanager-datasource";
    version = "2.0.0";
    zipHash = "4c75a3b7a94bb60e425a70b692fa1f13cc556f8d8357a54ade41fc1d4c2f510c";
    meta.description = "Grafana datasource for Prometheus AlertManager";
  };
  candlestick = grafanaPlugin {
    pname = "candlestick";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "";
  };
  canvas = grafanaPlugin {
    pname = "canvas";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Explicit element placement";
  };
  ccin2p3-riemann-datasource = grafanaPlugin {
    pname = "ccin2p3-riemann-datasource";
    version = "0.1.6";
    zipHash = "25f2841bec08e905d9e5656177086d3b60c78fb166f4867b6d9da5cb3cbcfc8d";
    meta.description = "Subscribe to riemann.io websocket streams!";
  };
  cesnet-dp3-app = grafanaPlugin {
    pname = "cesnet-dp3-app";
    version = "0.1.0";
    zipHash = "88e492747d1de68eedc5170c262a3c74a1b14967e6b1220b2c7b1a472943ec7f";
    meta.description = "CESNET DP³ plugin for Grafana";
  };
  chaosmeshorg-datasource = grafanaPlugin {
    pname = "chaosmeshorg-datasource";
    version = "2.2.3";
    zipHash = "0031af57ea58663ecd0e2b4fcbd6891475e930b8c73caef2a2a4d7a5df5bc02e";
    meta.description = "Chaos Mesh (A Chaos Engineering Platform for Kubernetes) Data Source";
  };
  checkmk-cloud-datasource = grafanaPlugin {
    pname = "checkmk-cloud-datasource";
    version = "3.1.1";
    zipHash = "28a039a0b5cde0d9450ac7f333137690f5323bb9684c61575e43e37e6ae9f832";
    meta.description = "Checkmk data source for Checkmk Cloud Edition";
  };
  citilogics-geoloop-panel = grafanaPlugin {
    pname = "citilogics-geoloop-panel";
    version = "1.1.2";
    zipHash = "0e8c24d4d71e57d4f232766bbaa1ec670733f1e59b865f3ac6ad9841df34bf1d";
    meta.description = "Looping animated map for Grafana.";
  };
  clarity89-finnhub-datasource = grafanaPlugin {
    pname = "clarity89-finnhub-datasource";
    version = "0.4.1";
    zipHash = "1e0af199c5019adeeaa02c83944951bd8c23f593db3eccd5bd9357ccf44dfd26";
    meta.description = "Finnhub Data Source";
  };
  cloudspout-button-panel = grafanaPlugin {
    pname = "cloudspout-button-panel";
    version = "7.0.23";
    zipHash = "c7b5f5bc2abadd58b744e8e497b06d05cb5e335dce4aae257423470df8f97b86";
    meta.description = "Panel for a single button";
  };
  cloudwatch = grafanaPlugin {
    pname = "cloudwatch";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Data source for Amazon AWS monitoring service";
  };
  cnos-cnosdb-datasource = grafanaPlugin {
    pname = "cnos-cnosdb-datasource";
    version = "0.5.2";
    zipHash = "1af102cf1ebe8d915b4cce6279544067385825a7023ad933f3b7cfc8b5d5dd47";
    meta.description = "A grafana data source plugin for CnosDB.";
  };
  cognitedata-datasource = grafanaPlugin {
    pname = "cognitedata-datasource";
    version = "4.0.1";
    zipHash = "f3917ce2ecdcd56bb8c7a69250e13ed6b0ef84ea7e9036af5f898edd2668bd06";
    meta.description = "Cognite Data Fusion datasource";
  };
  computest-cloudwatchalarm-datasource = grafanaPlugin {
    pname = "computest-cloudwatchalarm-datasource";
    version = "1.2.0";
    zipHash = "b8e0b461d3a7454dca8c1b487e7c81ccae03c1abf7dc90a285439501749f59a0";
    meta.description = "Data source for Amazon AWS CloudWatch Alarm status";
  };
  corpglory-chartwerk-panel = grafanaPlugin {
    pname = "corpglory-chartwerk-panel";
    version = "0.5.0";
    zipHash = "2c25b2cd6e8ba4c392170f1602deaa8f4f742f536e1f9c2a3ba9033fa7c34d81";
    meta.description = "Chartwerk panel with extended chart customization";
  };
  corpglory-progresslist-panel = grafanaPlugin {
    pname = "corpglory-progresslist-panel";
    version = "1.0.6";
    zipHash = "b45e2cead3400d92461f4af6cd0fe740d3ca9bdf6cbe917e85ad825aca46fef4";
    meta.description = "A panel showing list of progress-like items in one board";
  };
  cpacket-cclearutilitybundle-app = grafanaPlugin {
    pname = "cpacket-cclearutilitybundle-app";
    version = "4.1.0";
    zipHash = "201ef940e8eeec316769e1c3768d3f8d1294121d5bbfbe95e4e5de7f7b3a3acc";
    meta.description = "Grafana plugin allowing to download pcap files, collect packet analytics for specified data ranges from cPacket devices, and to import a list of dashboards for network observability.";
  };
  dalmatinerdb-datasource = grafanaPlugin {
    pname = "dalmatinerdb-datasource";
    version = "1.0.5";
    zipHash = "e1f6434f9c31256f1d98eba80612d4474f0dbeeb600011603003fc6bbc2afd11";
    meta.description = "DalmaterinDB Datasource";
  };
  dalvany-image-panel = grafanaPlugin {
    pname = "dalvany-image-panel";
    version = "3.0.0";
    zipHash = "a69595eb4b59ed43d1d2b4be214f3fa516cb419ad0b5336505f07bd1f9ff74d2";
    meta.description = "Concatenate a metric to an URL in order to display an image";
  };
  dashlist = grafanaPlugin {
    pname = "dashlist";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "List of dynamic links to other dashboards";
  };
  ddurieux-glpi-app = grafanaPlugin {
    pname = "ddurieux-glpi-app";
    version = "1.3.1";
    zipHash = "0218dce276c38bdedf35a15ca54539fafb6048fb28273cfc2fba761c51053601";
    meta.description = "GLPI app for Grafana";
  };
  debug = grafanaPlugin {
    pname = "debug";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Debug Panel for Grafana";
  };
  devicehive-devicehive-datasource = grafanaPlugin {
    pname = "devicehive-devicehive-datasource";
    version = "2.0.2";
    zipHash = "e19059b1d96bdf084190c56a0bcc2a2c6a57865cc291e4062d934f59880a67af";
    meta.description = "DeviceHive datasource";
  };
  devopsprodigy-kubegraf-app = grafanaPlugin {
    pname = "devopsprodigy-kubegraf-app";
    version = "1.5.2";
    zipHash = "acc4a5ec304f54d42b31857ee44093362743030ea1ae41812feab2d5d984df36";
    meta.description = "An updated version of the Grafana App for Kubernetes plugin, this plugin allows you to visualize and analyze your Kubernetes cluster’s performance. It demonstrates in graphics the main service metrics and characteristics of the Kubernetes cluster. It also makes it easier to examine the application’s life cycle and error logs.";
  };
  digrich-bubblechart-panel = grafanaPlugin {
    pname = "digrich-bubblechart-panel";
    version = "1.2.1";
    zipHash = "4d6b9aa80c3c99494f3b13ffb6b09816f2054c04181f9a7195c3c36d0332a4ed";
    meta.description = "Bubblechart panel";
  };
  dlopes7-appdynamics-datasource = grafanaPlugin {
    pname = "dlopes7-appdynamics-datasource";
    version = "3.4.0";
    zipHash = {
      x86_64-linux = "8f00142dc0bff797b826c08ed46fd0a929220ee15e6e88d854f8005f724c5442";
      aarch64-linux = "d7e1484c1620d01d7273ffd44813151154b014a5d6638cad521be759d3404a30";
      x86_64-darwin = "f4bf0dccb1b7183c8063ae6f998921babd29c9485878864874b9bf3a7c91e701";
      aarch64-darwin = "3f3c2859200823321729549951d8b6998d89392442f6a8b1c49dda153910bef1";
    };
    meta.description = "AppDynamics datasource plugin for Grafana";
  };
  dvelop-odata-datasource = grafanaPlugin {
    pname = "dvelop-odata-datasource";
    version = "1.0.0";
    zipHash = "e6dca77e5d8c14b95395217e37fd326c5db6fbd446e791daf9b467b020261c3d";
    meta.description = "OData data source for Grafana";
  };
  elasticsearch = grafanaPlugin {
    pname = "elasticsearch";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Open source logging & analytics database";
  };
  embraceio-metric-app = grafanaPlugin {
    pname = "embraceio-metric-app";
    version = "1.2.0";
    zipHash = "f0a8657b04a73cdae0cd62554f1db2efbc52228d727d7f3cd85de800e5d396e6";
    meta.description = "Mobile observability and data platform that empowers mobile teams to deliver optimal user experiences";
  };
  equansdatahub-tree-panel = grafanaPlugin {
    pname = "equansdatahub-tree-panel";
    version = "1.3.1";
    zipHash = "813bb83630835b96ea1e16971db12e2ea23bd7c6106f7905b37463fbefb65ff9";
    meta.description = "View data, from a table data source, as a interactive tree like structure";
  };
  esnet-arcdiagram-panel = grafanaPlugin {
    pname = "esnet-arcdiagram-panel";
    version = "1.0.3";
    zipHash = "0d778aba4e315fe38dc4139b32794b84dd1e3c41d67c8272c9e053f36397f244";
    meta.description = "An arc diagram panel plugin for Grafana.";
  };
  esnet-chord-panel = grafanaPlugin {
    pname = "esnet-chord-panel";
    version = "1.0.3";
    zipHash = "e1cbe8fd7f933cafd2bb02f68b6ff80648b01d643936d7f06171d04cdc3ca428";
    meta.description = "ESnet Chord Panel Plugin for Grafana 8.3 and newer";
  };
  esnet-matrix-panel = grafanaPlugin {
    pname = "esnet-matrix-panel";
    version = "1.0.9";
    zipHash = "78b302536e2a4d0521331f05fb9b36d8fcb19d922e74d2fa7bbcee20a12a05c9";
    meta.description = "Matrix Panel Plugin that allows comparison of two non-timeseries categories";
  };
  factry-untimely-panel = grafanaPlugin {
    pname = "factry-untimely-panel";
    version = "0.3.1";
    zipHash = "33bb57456773f04c1036749d219f898844e2492dbf92d810d921d4a576fb592d";
    meta.description = "Grafana panel for displaying time series data as function of distance";
  };
  farski-blendstat-panel = grafanaPlugin {
    pname = "farski-blendstat-panel";
    version = "1.0.3";
    zipHash = "ba098f98f24006f9f3ba119836e59bb6f128384cc45886ef836d6c1322e5d0e4";
    meta.description = "Blendstat Panel for Grafana";
  };
  fastweb-openfalcon-datasource = grafanaPlugin {
    pname = "fastweb-openfalcon-datasource";
    version = "1.0.1";
    zipHash = "a309246482bcbd4d9382b3d794d1ad6d10eb1fb671b2a910bc83e68e263ad240";
    meta.description = "datasource plugin for Open-Falcon";
  };
  fatcloud-windrose-panel = grafanaPlugin {
    pname = "fatcloud-windrose-panel";
    version = "0.7.1";
    zipHash = "1a66339b88ecaf632dcae28bfa8339b6bcd554b74ea06e51323ba5bc49e573e9";
    meta.description = "Make windrose plots";
  };
  fetzerch-sunandmoon-datasource = grafanaPlugin {
    pname = "fetzerch-sunandmoon-datasource";
    version = "0.3.0";
    zipHash = "cef67c87894cdc31abd755d5da7071998e1ff8e5b042008dacb657a2a3930454";
    meta.description = "Calculates position of Sun and Moon.";
  };
  fifemon-graphql-datasource = grafanaPlugin {
    pname = "fifemon-graphql-datasource";
    version = "1.3.0";
    zipHash = "97bbbee0823e26e6098dfe28f5a1764b28377086202d12cf8e1fa1cdec858838";
    meta.description = "GraphQL Data Source";
  };
  flaminggoat-maptrack3d-panel = grafanaPlugin {
    pname = "flaminggoat-maptrack3d-panel";
    version = "0.1.9";
    zipHash = "27d7913cd1218827ba24da1b3a41f2654cd668144ee337582a00eddce7fc35e3";
    meta.description = "A plugin for Grafana that visualizes GPS points on a 3D globe";
  };
  flant-statusmap-panel = grafanaPlugin {
    pname = "flant-statusmap-panel";
    version = "0.5.1";
    zipHash = "6841f3687f70711673766646aca3a2bb2d28a8e2e6336370329c90d917beb5a9";
    meta.description = "Statusmap panel for grafana";
  };
  foursquare-clouderamanager-datasource = grafanaPlugin {
    pname = "foursquare-clouderamanager-datasource";
    version = "0.9.3";
    zipHash = "8c4cb1d9d9558a8bbf2aa9202390aee53e4be86f839628d9503fe20a66eb44fb";
    meta.description = "Cloudera Manager datasource";
  };
  frser-sqlite-datasource = grafanaPlugin {
    pname = "frser-sqlite-datasource";
    version = "3.3.2";
    zipHash = "87afd9c1198038a1342eeaa1c5960df84e05ee2d0da5c67a22ce28322645e9d2";
    meta.description = "SQLite as a (Backend) Datasource";
  };
  fzakaria-simple-annotations-datasource = grafanaPlugin {
    pname = "fzakaria-simple-annotations-datasource";
    version = "1.0.1";
    zipHash = "cae78915ea066a13163fef88562074a8eecf7d9eb48a8eac093b3fd64748fe47";
    meta.description = "Simple Annotations for Grafana saved in your dashboard.json";
  };
  gabrielthomasjacobs-zendesk-datasource = grafanaPlugin {
    pname = "gabrielthomasjacobs-zendesk-datasource";
    version = "1.1.1";
    zipHash = "8825cb5e1eb944bf45bad9136dee3790741d88543317dbbe1b60ec1162917303";
    meta.description = "A datasource plugin to add Zendesk integration";
  };
  gapit-htmlgraphics-panel = grafanaPlugin {
    pname = "gapit-htmlgraphics-panel";
    version = "2.1.1";
    zipHash = "e8adbff8e140a169a999c95f0472188cf39241ea94f85f9b901b5d79fb4bd038";
    meta.description = "Grafana panel for displaying metric sensitive HTML and SVG graphics";
  };
  gauge = grafanaPlugin {
    pname = "gauge";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Standard gauge visualization";
  };
  geomap = grafanaPlugin {
    pname = "geomap";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Geomap panel";
  };
  gnocchixyz-gnocchi-datasource = grafanaPlugin {
    pname = "gnocchixyz-gnocchi-datasource";
    version = "1.7.1";
    zipHash = "30821d76bd2ed0c421fc1253a8b7ce6292b97d3ece2b64514a6f8f1de496e0a5";
    meta.description = "Gnocchi Datasource";
  };
  golioth-websocket-datasource = grafanaPlugin {
    pname = "golioth-websocket-datasource";
    version = "1.0.2";
    zipHash = "c974fd148262830213956e401adc093fd698ac804f08e3779b5c7de391f19069";
    meta.description = "A data source plugin for handling WebSocket connections on Grafana. Works great in the general use case or with IoT projects built on Golioth.";
  };
  googlecloud-logging-datasource = grafanaPlugin {
    pname = "googlecloud-logging-datasource";
    version = "1.4.0";
    zipHash = "2470f4a4151b12575c15d90073150c692cb5573bab325de687ddb20ce5e7d9bd";
    meta.description = "";
  };
  googlecloud-trace-datasource = grafanaPlugin {
    pname = "googlecloud-trace-datasource";
    version = "1.1.0";
    zipHash = "67d50a5f282eac0379f95b2aac9180a94512574a5910f74f2a6e3412fbdc848d";
    meta.description = "";
  };
  goshposh-metaqueries-datasource = grafanaPlugin {
    pname = "goshposh-metaqueries-datasource";
    version = "0.0.9";
    zipHash = "b89baa421826bfc879e00de01414c888eb49901a203220fdf9c3524e015a4fb0";
    meta.description = "";
  };
  gowee-traceroutemap-panel = grafanaPlugin {
    pname = "gowee-traceroutemap-panel";
    version = "0.3.0";
    zipHash = "7df682457e7797f874284e5ef4099e92ea544b16785362301e198ee74e91e562";
    meta.description = "A Grafana panel that visualize traceroute hops in a map";
  };
  grafadruid-druid-datasource = grafanaPlugin {
    pname = "grafadruid-druid-datasource";
    version = "1.4.1";
    zipHash = "edab71a91a8aaa8a7a00143e79a77ac11fd846925a57c8ff462e1507d15732ef";
    meta.description = "Connects Grafana to Druid";
  };
  grafana-astradb-datasource = grafanaPlugin {
    pname = "grafana-astradb-datasource";
    version = "0.3.2";
    zipHash = {
      x86_64-linux = "23c9465679a9ef6b4b9aefd17136f8721b94c4bc95c563c7a85d07b76879a289";
      aarch64-linux = "32bbe6b3791c9cfb3d3c35af882b0d4831d90ac234e20a594e6a7277a5e0b16b";
      x86_64-darwin = "2946fd8b6a2c14624e75c0549cf18d916cca2990036427e0aacd63221ad1c090";
      aarch64-darwin = "6d7c378dafe0e702ad2e4f9b95675b4c422eb5b59fbf2e4ba4ea46ae6db27887";
    };
    meta.description = "AstraDB datasource plugin for Grafana";
  };
  grafana-athena-datasource = grafanaPlugin {
    pname = "grafana-athena-datasource";
    version = "2.13.3";
    zipHash = {
      x86_64-linux = "45ef1961418952374f73c8de5a5b2acd0bf87f721f43754c5248094e687bf6d1";
      aarch64-linux = "5e846d8120a51252926cf344bc117da26735421012023ab8ec144fcdc65ccf68";
      x86_64-darwin = "a264cc8d6ae8586704873a6766ae6c673bf4a03d88c91d3aedac2cd1fc5d7772";
      aarch64-darwin = "8cddfdb41a93df7b6282fc45683c5203e928aa69445db3b25e0797e40179f46c";
    };
    meta.description = "Use Amazon Athena with Grafana";
  };
  grafana-azure-data-explorer-datasource = grafanaPlugin {
    pname = "grafana-azure-data-explorer-datasource";
    version = "4.7.1";
    zipHash = {
      x86_64-linux = "60f1d2bae01e5753fdb37079c31f253c52dc8932ce310c816b9cdb845a983394";
      aarch64-linux = "956a0db0ce1492a29a437f27bae7d0d4775b2f255b3bef4a5780260b1bbbee02";
      x86_64-darwin = "edfd30335feac56b27e75a1ce90c6ff09a7160eafc3f31bb3357572dc015730f";
      aarch64-darwin = "f296280ed4ce10cc4dc51729ec62fee06cb287c38f85281b1b09d627dfbba1f2";
    };
    meta.description = "Grafana data source for Azure Data Explorer";
  };
  grafana-azure-monitor-datasource = grafanaPlugin {
    pname = "grafana-azure-monitor-datasource";
    version = "1.0.0";
    zipHash = "7fd34d2fdcef62e199dace3d3b236e5972768b59c4648de3dfca96c8a6a20868";
    meta.description = "Data source for Microsoft Azure Monitor & Application Insights";
  };
  grafana-azuredevops-datasource = grafanaPlugin {
    pname = "grafana-azuredevops-datasource";
    version = "0.4.1";
    zipHash = {
      x86_64-linux = "67cbf7c6a9113fe46feb6c315bdea13e15fa6121fc66753004974e888a8e3156";
      aarch64-linux = "a2ec0ab25943e98fe04df345f6f88cd030d8f98ec228addcd0bde55953361bcd";
      x86_64-darwin = "045f750d8bb25d7db0c51502315a04729b7fe030cd8908671056cebe4906a2c8";
      aarch64-darwin = "ad38895047030ca5ca60120fa25c423a6ef7567793047d22113682be57004174";
    };
    meta.description = "The Grafana data source plugin for Azure Devops";
  };
  grafana-bigquery-datasource = grafanaPlugin {
    pname = "grafana-bigquery-datasource";
    version = "1.4.1";
    zipHash = {
      x86_64-linux = "8f1ba477bc210476a347393a1884ddca281e6ac08c0a59c321c21c18e4e63b33";
      aarch64-linux = "b81095e1860436068c51e323f595d1e74fecdc8e989473da435b6002cc4b571d";
      x86_64-darwin = "6fae6aef7d203f291a079d031cde330325dd9cd59d67a0cf1f680f4a061910e9";
      aarch64-darwin = "4297e855466a5bac49745d73bc995fc43793045944fc289c7efab5956d048276";
    };
    meta.description = "Google BigQuery datasource for Grafana";
  };
  grafana-clickhouse-datasource = grafanaPlugin {
    pname = "grafana-clickhouse-datasource";
    version = "3.3.0";
    zipHash = {
      x86_64-linux = "164397ff6bcf98bb717bfa0e21295d95585acb2ec0c1f1712de8b02794cd8186";
      aarch64-linux = "e2b0a3f8d68a3d96ee5688652a649fd4cea7e6783d1d932bc3304280b3dd8a89";
      x86_64-darwin = "6e97b2e84c3002a5e0c63be327aa2ee2b8a789d1c2a54afe67cf58a4064aef3f";
      aarch64-darwin = "bbf53696ee2ccdff4916dff37e11a658a1f6394aa924335a488ebd103762d7ec";
    };
    meta.description = "ClickHouse datasource plugin for Grafana";
  };
  grafana-clock-panel = grafanaPlugin {
    pname = "grafana-clock-panel";
    version = "2.1.3";
    zipHash = "65e75e57f490b01bb9e63031172c9741e7e2af8844975fd340399a4c937d6da8";
    meta.description = "Clock panel for grafana";
  };
  grafana-databricks-datasource = grafanaPlugin {
    pname = "grafana-databricks-datasource";
    version = "1.2.0";
    zipHash = {
      x86_64-linux = "1f16fd3cf058bf5b7a090d3872abca0121461d0dba67985d171f8ddda38c28a6";
      aarch64-linux = "bde9e94fcea6f5792ac6e89e8686026a35bfbbef742b12eec6df6250f3c48d0c";
      x86_64-darwin = "90076016f49052279d70a7cde33b5610dc96d06aabb323e7afb920b0e652fb7a";
      aarch64-darwin = "52e099ef8b18c9d4892068e6b27a387ca88a2c25b7097510a34d18d3c4b6813a";
    };
    meta.description = "Databricks datasource plugin for Grafana";
  };
  grafana-datadog-datasource = grafanaPlugin {
    pname = "grafana-datadog-datasource";
    version = "3.7.0";
    zipHash = {
      x86_64-linux = "aff3fe18138f98ddb73b956d3cd41edc37211d0db75b8d16dd37a4d556d0ffd0";
      aarch64-linux = "5a2967c1b3fed030f21228a13578393c6e609da8a4d0d04192a2233b4c245f58";
      x86_64-darwin = "f4418489534b234c24d50a856e0c6255f5cabd018451477f6d4df96e398af64f";
      aarch64-darwin = "b51305bf5ae814a3f14bd9fb106a6dddced86de6779a0f0506c16600aaa871b0";
    };
    meta.description = "Datadog datasource plugin for Grafana. Grafana Data dog datasource plugin";
  };
  grafana-db2-datasource = grafanaPlugin {
    pname = "grafana-db2-datasource";
    version = "0.1.0";
    zipHash = {
      x86_64-linux = "40898c407c58df9750c8501024671bd9c86d88e300b80442c0f0a02984fb2322";
    };
    meta.description = "Grafana DB2 Data Source";
  };
  grafana-discourse-datasource = grafanaPlugin {
    pname = "grafana-discourse-datasource";
    version = "2.0.2";
    zipHash = "d0c4f13deed1247300d12c2339c1656e2e1592194b5053fee6bd83b0701a7df7";
    meta.description = "Data source for the hosted Discourse forum software";
  };
  grafana-dynatrace-datasource = grafanaPlugin {
    pname = "grafana-dynatrace-datasource";
    version = "3.12.1";
    zipHash = {
      x86_64-linux = "4ff43236399b8caca963ad564a5e4d9541293e95d556d1f060c9e74f440c276e";
      aarch64-linux = "3309c838f2622dd86e706ba1bc47460a8b80b09f024fb63eb00dc81695125e73";
      x86_64-darwin = "387ee5f4fbc280742af5c472414d927e3f12bdda725b82594707ada07143a0c5";
      aarch64-darwin = "d22a97b4b40edd5c5b5315977262675d5f5409b799debfd641814a6aaa6cb9cb";
    };
    meta.description = "Dynatrace datasource plugin for Grafana";
  };
  grafana-enterprise-logs-app = grafanaPlugin {
    pname = "grafana-enterprise-logs-app";
    version = "3.1.3";
    zipHash = "ff6ea40704d1234a0df70628c24d00ee2e36603307b87e5bf4c39700228de1bf";
    meta.description = "";
  };
  grafana-enterprise-traces-app = grafanaPlugin {
    pname = "grafana-enterprise-traces-app";
    version = "2.2.1";
    zipHash = "eae8363328d93a021bb095b489e426f7f72ed28c89e78eb177d3a90257bc28bc";
    meta.description = "";
  };
  grafana-es-open-distro-datasource = grafanaPlugin {
    pname = "grafana-es-open-distro-datasource";
    version = "1.0.6";
    zipHash = {
      x86_64-linux = "11faa462c85da5dff654405b991cafe45ed4975a43cab218f88f0daf9dc07a8a";
      x86_64-darwin = "d966c810071982a751b547b59e4bd19101418bbead93fd149b8972bcfeb876be";
    };
    meta.description = "";
  };
  grafana-falconlogscale-datasource = grafanaPlugin {
    pname = "grafana-falconlogscale-datasource";
    version = "1.2.0";
    zipHash = {
      x86_64-linux = "3de03c3bd8a29f11467417bf8cb76f6cd595d6bea0f4720a7366a69013bee87c";
      aarch64-linux = "8176b442bddd00dbd86f62c1c7635317fdb7baeafa884632dc0dcc595c1ee1d4";
      x86_64-darwin = "750636411eaad8bf7248b9296eb1007a0155bcd6c32248df9321041ad2d21679";
      aarch64-darwin = "4aee66a475bd40561a18923c610727dc27da3af1b780d7ccd56fadd5aaa81e02";
    };
    meta.description = "Falcon LogScale data source for Grafana";
  };
  grafana-github-datasource = grafanaPlugin {
    pname = "grafana-github-datasource";
    version = "1.5.3";
    zipHash = {
      x86_64-linux = "1cace9beac34d86856e2b584de944f38e9a1f8c3c430e105c1d1787be9e89be4";
      aarch64-linux = "3067944ee4cef175f61d4e4b7d822df44db0c89eeffd54f906487bbb0be4bcd0";
      x86_64-darwin = "b1739026c1a80033406de555578f2f7e0e7bff102b92efc97b2253e48d6b5c9e";
      aarch64-darwin = "5d2ab6a2b448b1ba71537f7fd550cb336f39b2ed9f7032722be8721664537303";
    };
    meta.description = "Show data about github issues/pull requests";
  };
  grafana-gitlab-datasource = grafanaPlugin {
    pname = "grafana-gitlab-datasource";
    version = "1.6.0";
    zipHash = {
      x86_64-linux = "6b63ca943fb37d6d3105fc639bd1f5351134d8a72d3ef789e5b5b29235d6a838";
      aarch64-linux = "f5f67093dcfb9f67888393708fc642e511e25330c79fb0f6dc3e01e2732a0fb1";
      x86_64-darwin = "ad2a01fc7a4947ee9889adceb9c5262b3190ef9d1a1245923ad9cb55cc63ba2b";
      aarch64-darwin = "36e4b859614d06cd521ca2ce1fefdf1d72ebec37736f8a240af00be98f85d419";
    };
    meta.description = "GitLab datasource plugin for Grafana";
  };
  grafana-googlesheets-datasource = grafanaPlugin {
    pname = "grafana-googlesheets-datasource";
    version = "1.2.5";
    zipHash = {
      x86_64-linux = "29b29801ef054329f53667b91c1e1b5cf74f677e87069b242de57c54ff630f5f";
      aarch64-linux = "a4e3b390bde7068d29846007c43a16747aafbb28ba66987384f0143daeb9cfe8";
      x86_64-darwin = "3ce2aec44b81aacc6f2fbfe61c4b5c5832a0367c2603bdf7fd98e8c445dd1397";
      aarch64-darwin = "0631fbef016a0c52ef5583d638434b077900986fccbc845c4c7354fdff81c022";
    };
    meta.description = "Show data from google sheets";
  };
  grafana-guidedtour-panel = grafanaPlugin {
    pname = "grafana-guidedtour-panel";
    version = "0.2.0";
    zipHash = "4e0bc3e6d0fcd2a7584e4dbbf12c1c9a3c7b08d0a7828d6b38f15e298548e9c7";
    meta.description = "Guided tour for Grafana dashboards";
  };
  grafana-honeycomb-datasource = grafanaPlugin {
    pname = "grafana-honeycomb-datasource";
    version = "2.1.0";
    zipHash = {
      x86_64-linux = "ae00007514a26e8a5a161008613a201b71d3750f7321878f3407be8bc91041a7";
      aarch64-linux = "fdd9a323af5e40118b58c5c1e716e65737c09b2ebe50f5c26787f8b3d812426c";
      x86_64-darwin = "a4e6503520d062aabede7f43c25cf8dc79efcaa567af423017eb762d9b6ccd63";
      aarch64-darwin = "a965525e4ce3b07516135531427a522b95112c1c390901b8380341845580c860";
    };
    meta.description = "Honeycomb datasource plugin for Grafana";
  };
  grafana-image-renderer = grafanaPlugin {
    pname = "grafana-image-renderer";
    version = "3.8.4";
    zipHash = {
      x86_64-darwin = "bef52397e13538624aa59e6cf6138962434ea92f4424eff1511d4eea29f5b7cc";
      x86_64-linux = "ec9b228fec212b119c7df7a8c2352ef323190600bf2c4f5e70a8c9d58a847358";
    };
    meta.description = "Grafana Backend Image Renderer that uses headless chrome to capture images.";
  };
  grafana-iot-sitewise-datasource = grafanaPlugin {
    pname = "grafana-iot-sitewise-datasource";
    version = "1.15.0";
    zipHash = {
      x86_64-linux = "b2e96e72a7afdda78e207d4fb1a07b9b85b94d52a127988cfec6a19be21be31e";
      aarch64-linux = "f7ca548b2a4b4a1b13027a3f83597c7a3dfb018438dd7fcad7ebec07887c515f";
      x86_64-darwin = "6ed8fa144157886b272555b4b5148059a0f495554616d9e0864778b718985e60";
      aarch64-darwin = "ff9e80d90519fd2603d2fdd19ef66bd1d4092a24e03af21e70c0d7ee6a689a80";
    };
    meta.description = "A managed service to collect, store, organize and monitor data from industrial equipment";
  };
  grafana-iot-twinmaker-app = grafanaPlugin {
    pname = "grafana-iot-twinmaker-app";
    version = "1.10.0";
    zipHash = {
      x86_64-linux = "55881938c8d15c8179f05456b83f2de263500be552b7546da0bade91785fa785";
      aarch64-linux = "d9dfd7d07e774425228097068f8373aee4267f43be9b1e2d732d9b8d9cd770e9";
      x86_64-darwin = "6c2cd4125d39a7c5508acaa4356355d127c09b0d94cfeffa9a9b98075ea27117";
      aarch64-darwin = "b0482d9439cd3b308af80d5e51540b545232f70a95d75c08366219c82e0dce07";
    };
    meta.description = "Create end-user 3D digital twin applications to monitor industrial operations with AWS IoT TwinMaker. AWS IoT TwinMaker is a service that makes it faster and easier for developers to create digital replicas of real-world systems, helping more customers realize the potential of digital twins to optimize operations.";
  };
  grafana-jira-datasource = grafanaPlugin {
    pname = "grafana-jira-datasource";
    version = "1.8.1";
    zipHash = {
      x86_64-linux = "f203b4743360fc2f5448227da9cef04d68df3cad386f6189db13e14d54273f79";
      aarch64-linux = "5a72ed046a289f2e5208c33b47af838217964b1c19c84f51e0f4a58b0c74d69a";
      x86_64-darwin = "5f93850da49d716fce4ddc2337440c8820586a9c65f0e14dc4c5c0b3872514b0";
      aarch64-darwin = "c13b6eb4be0bd08c734244172570ea68b81a3628637da2714e7e549c69612d68";
    };
    meta.description = "Jira datasource plugin for Grafana";
  };
  grafana-kairosdb-datasource = grafanaPlugin {
    pname = "grafana-kairosdb-datasource";
    version = "3.0.2";
    zipHash = "ad15fa977189fa18d7d81bc7ab8e4eb0cbc0a262691d53f9bc217caf3adff267";
    meta.description = "datasource plugin for KairosDB";
  };
  grafana-llm-app = grafanaPlugin {
    pname = "grafana-llm-app";
    version = "0.5.1";
    zipHash = {
      x86_64-linux = "37fce3dc5ab9ea6d2c21d6431fcf357b22555fc91ac8b3bf1474e81835a34b62";
      aarch64-linux = "c9d921e02ab7c6a75c83007b4a1b42d31ba1866aeddbfca56df57552de544628";
      x86_64-darwin = "9491b54d8954446c47cabe47fc1274e92ebd9f6b6dc7b95db2dcde0866577704";
      aarch64-darwin = "ba2e3739090533e7dd03cb56a831933d3be2a32dd7450b50f34e318307964952";
    };
    meta.description = "Plugin to easily allow LLM based extensions to grafana";
  };
  grafana-looker-datasource = grafanaPlugin {
    pname = "grafana-looker-datasource";
    version = "0.2.1";
    zipHash = {
      x86_64-linux = "633fec18309b65bd77b3dc30c66e877333f69ca0f1f57f37fdad4f9ba471dd42";
      aarch64-linux = "9e70d429cdfabe9fd592cb674d4f7dd8a54318c6d784a27e7d66ad481c84d981";
      x86_64-darwin = "9fb789e1205ab6607602c8448f93f45f2d87b441dfabb39365e4617374bf97eb";
      aarch64-darwin = "c3562485b09c5c317d3ffcb22bdde451822af1729c2af1682516dcc311d23755";
    };
    meta.description = "Looker datasource plugin for Grafana";
  };
  grafana-metrics-enterprise-app = grafanaPlugin {
    pname = "grafana-metrics-enterprise-app";
    version = "4.0.8";
    zipHash = "5fd5abc865d65343a1e247a82836f60313423ee382bf89e1f9d82deced6bc71e";
    meta.description = "";
  };
  grafana-mock-datasource = grafanaPlugin {
    pname = "grafana-mock-datasource";
    version = "0.1.5";
    zipHash = {
      x86_64-linux = "82a6858c370012fe363916b7ab621ff90fcb34f9bacb41cf6c0afe33f5c2382a";
      aarch64-linux = "8127c2395f4604b82ccba0cadf6b88fb5b8b33ae6e44b3c7b3a970634b42775a";
      x86_64-darwin = "8a3387244276ab4d5b34815e19c66ee1edc4b86e79e6c41f400046dbca726132";
      aarch64-darwin = "eaf13c9dc95ce7b3b2e86326cf71421468833897ab7c59eb275a44a29de21ba2";
    };
    meta.description = "Grafana mock datasource";
  };
  grafana-mongodb-datasource = grafanaPlugin {
    pname = "grafana-mongodb-datasource";
    version = "1.10.2";
    zipHash = {
      x86_64-linux = "6c3f16dae0cd86de8f0a85cbf48239b622c1cc868106f820018972bb1c354dd5";
      aarch64-linux = "1f7f31024f71ea2e2b8c36e2fa4722e468e0176acb1c7a3884c58862eee428f7";
      x86_64-darwin = "57876b315cf42013375b2c02c69fd6a86e6bb03395855f91e708c54c655eb55e";
      aarch64-darwin = "ef01d4f6c5e02c4194f8f3e3c21a507857f93e397751ce83083d3283b2e86928";
    };
    meta.description = "MongoDB datasource plugin for Grafana";
  };
  grafana-mqtt-datasource = grafanaPlugin {
    pname = "grafana-mqtt-datasource";
    version = "1.0.0-beta.3";
    zipHash = {
      x86_64-linux = "aa40a737a5df833a3aa5aae0ca704e3b81ef4a9ffb6133272090dec9c31a891c";
      aarch64-linux = "56cbbbc90c9d7a486ac83aa96d6fab7059845c4c8951f04836697a8d1d8799a5";
      x86_64-darwin = "a3b271e07e07d60ca48d562f4b586d3bd5890e5294cd448c623003afabf98c63";
      aarch64-darwin = "51f440b6d06098ca481af6a5d400aca63ed0a916b6e8b264eef0f559633c1e67";
    };
    meta.description = "MQTT Client Datasource Plugin";
  };
  grafana-newrelic-datasource = grafanaPlugin {
    pname = "grafana-newrelic-datasource";
    version = "4.2.0";
    zipHash = {
      x86_64-linux = "8ef169adec2ebcc51e772727c11e741a0a6669d7f0c83b227483062a7124400f";
      aarch64-linux = "43a47ed293253cc4a72c18341f6f1883c85202cb9396cfa8bfbd25b8b0614161";
      x86_64-darwin = "a18d2bb3201555d2636944737a77bcdecab2cfa3ef1bac873172ba3380ac24ed";
      aarch64-darwin = "d59f954306bb1d9b75c72633d8773fd2b6ec3b0251f377f8aa085d7f0c5fec5a";
    };
    meta.description = "New Relic datasource plugin for Grafana";
  };
  grafana-odbc-datasource = grafanaPlugin {
    pname = "grafana-odbc-datasource";
    version = "1.3.0";
    zipHash = {
      x86_64-linux = "e6d331aeaa7e1567e64ffc16f18fc1492451b6d041963effd8a2cf142efa10e3";
      aarch64-linux = "b0011f9dcb29eeaba6b6864e97add06d77a7ab1559eaaf3a81f39e5da0042ed5";
    };
    meta.description = "Grafana Sqlyze Data Source. Generic datasource plugin to connect SQL databases via ODBC driver";
  };
  grafana-oncall-app = grafanaPlugin {
    pname = "grafana-oncall-app";
    version = "1.3.70";
    zipHash = "b6d44f126a14dcfc6e882d6aac50f11b0ed1dc74519458d071877b018f1b9e68";
    meta.description = "Collect and analyze alerts, escalate based on schedules and deliver them to Slack, Phone Calls, SMS and others.";
  };
  grafana-opcua-datasource = grafanaPlugin {
    pname = "grafana-opcua-datasource";
    version = "1.2.2";
    zipHash = {
      x86_64-linux = "b2519f0bcf1bf888a30bc42de5ccde05323b1e35f42d6e3824b17d55f0b8940b";
    };
    meta.description = "A Grafana datasource that reads data from OPC UA Servers";
  };
  grafana-opensearch-datasource = grafanaPlugin {
    pname = "grafana-opensearch-datasource";
    version = "2.14.0";
    zipHash = {
      x86_64-linux = "37e5ebde20ae0b76a6aa703ec976829f517a5bcd7d525e6fabe98c2e3c032495";
      aarch64-linux = "790d279a6d48dac24c38b6bf847db425bffc1b98d8563141b0d9eac4bb14c598";
      x86_64-darwin = "d2bb665a968afd2aa243b95d7d3c65bbee1ba80eab9ecbed9facde3564af3170";
      aarch64-darwin = "3bb3e8916c85fb865282ef07a094ab4ae86a3924e72c4d6dff0427ee1213835a";
    };
    meta.description = "";
  };
  grafana-oracle-datasource = grafanaPlugin {
    pname = "grafana-oracle-datasource";
    version = "2.7.1";
    zipHash = {
      x86_64-linux = "c3ec2123b8ff52595b8df6172a95d0644c6580023f53da666548fea670f94325";
    };
    meta.description = "Oracle datasource plugin for Grafana";
  };
  grafana-orbit-datasource = grafanaPlugin {
    pname = "grafana-orbit-datasource";
    version = "0.1.1";
    zipHash = "021ec5fa47ab7b4d44add4397d4b0315996cc4128b974e2d0ecb9e10ef2165b2";
    meta.description = "A data source for Orbit.";
  };
  grafana-polystat-panel = grafanaPlugin {
    pname = "grafana-polystat-panel";
    version = "2.1.4";
    zipHash = "d799a2e4dcdb6d65c9ffaf55130512d39f1ab50fb3da0e02dd3f7f6fefc4c709";
    meta.description = "Polystat panel for Grafana";
  };
  grafana-pyroscope-datasource = grafanaPlugin {
    pname = "grafana-pyroscope-datasource";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Supports Phlare and Pyroscope backends, horizontally-scalable, highly-available, multi-tenant continuous profiling aggregation systems.";
  };
  grafana-redshift-datasource = grafanaPlugin {
    pname = "grafana-redshift-datasource";
    version = "1.13.1";
    zipHash = {
      x86_64-linux = "017718bfaa812e857f6798d61a890e29a26f16a9dd65fec3e5613affe6af7643";
      aarch64-linux = "12e905314d96180ae74f4606a6aca366d6004dd8078b671394412b16cbe16231";
      x86_64-darwin = "4bb8928a9efaebadb3622861c25a5bd6dfc2c1e1bfe1d49568b7df91fb0feb19";
      aarch64-darwin = "1958de3779dbad40619f7877a3b5cfe20dd826e7b22e946e3b9379ecd24e5734";
    };
    meta.description = "Use Amazon Redshift in Grafana";
  };
  grafana-salesforce-datasource = grafanaPlugin {
    pname = "grafana-salesforce-datasource";
    version = "1.3.1";
    zipHash = {
      x86_64-linux = "1ff7e0d26bcf06f825cbb2cc9cb86f4fbd5e129c0b30e4b59b5ab31ce2bd97df";
      aarch64-linux = "f96b83d3f9caed35503852c5c60f9580aca6a578c64fd7a01b6d4088ece41a2a";
      x86_64-darwin = "e170f6ebb7af480ea008dd6e27aaff6def6a7863367e0791f3a449ed04810e1b";
      aarch64-darwin = "334c5b9ed640aba01a5b5a12071a3746cc6076e53d5f16e44589ee399116cb77";
    };
    meta.description = "Salesforce datasource plugin for Grafana";
  };
  grafana-saphana-datasource = grafanaPlugin {
    pname = "grafana-saphana-datasource";
    version = "1.5.2";
    zipHash = {
      x86_64-linux = "3ae59aa3b4a2761198e57d126caabbacd390cc861e349c0b72501418b33033c3";
      aarch64-linux = "87f9aa2c44a9a1483093c7af9ad8057deafe105abff197db0e65295084188891";
      x86_64-darwin = "0f8d884d22bbce587439bfcba8a0e5aea7591dfc2d6c3db9712af4db8289f9e2";
      aarch64-darwin = "1946fe1aff8ff205b2f225044a81c2cc30135c372791e7f46b3bd3f34916cf2d";
    };
    meta.description = "The Grafana® data source plugin for SAP HANA®. SAP HANA® is the trademark or registered trademark of SAP SE or its affiliates in Germany and in several other countries.";
  };
  grafana-selfservetutorials-app = grafanaPlugin {
    pname = "grafana-selfservetutorials-app";
    version = "1.0.0";
    zipHash = "b53d96529859f2aa99f1640ae944f0918c929f19079bb1325ab0b15fe6e734e9";
    meta.description = "Tutorial docs and walkthroughs for self serve users";
  };
  grafana-sentry-datasource = grafanaPlugin {
    pname = "grafana-sentry-datasource";
    version = "1.4.0";
    zipHash = {
      x86_64-linux = "7d3d140c398c5f0a31adad3c427b3faa0afea406aa76cc124ce62b05a4f703d2";
      aarch64-linux = "4e57695dba2d7b9b454125dbdada54b1584b786bc9b868719d784a9f6d3573a6";
      x86_64-darwin = "0be2aa0da6781c178f7a76e598f248b8bf59114ccbd3be4cd275348f7d957fcc";
      aarch64-darwin = "a2f1c10588abe3214f29573e31cea7d0272ffcbedfbb134fc8563db6fe6bfd34";
    };
    meta.description = "Grafana datasource plugin for Sentry";
  };
  grafana-servicenow-datasource = grafanaPlugin {
    pname = "grafana-servicenow-datasource";
    version = "2.8.1";
    zipHash = {
      x86_64-linux = "dd5c9a551894c5ae38b55bf56757b1a0c63c4ab5f6fdce9a5e5cd2ddeba799e9";
      aarch64-linux = "4e2cbbd4e3d5373350f563ee7be082593541afc922441ede176fa707dc0f9cec";
      x86_64-darwin = "da601ae25faf2548c058bdbc6ed456fc4974aa1f989e117e7280d0044f5b052f";
      aarch64-darwin = "27f66ca4d436ea067e5dbf5b1623d55c1148684c445be63427f25543b624ae31";
    };
    meta.description = "ServiceNow datasource plugin for Grafana";
  };
  grafana-simple-json-datasource = grafanaPlugin {
    pname = "grafana-simple-json-datasource";
    version = "1.4.2";
    zipHash = "515c6dd38310c97c735bba34b5f8038b5909677dad8f09626d1189c06139c8c8";
    meta.description = "simple json datasource";
  };
  grafana-snowflake-datasource = grafanaPlugin {
    pname = "grafana-snowflake-datasource";
    version = "1.8.0";
    zipHash = {
      x86_64-linux = "be3d40c0048692fe55e37ffd56c8c3ef8c210cba480dbc33c9c2aa6ba661ceb5";
      aarch64-linux = "705378581b3c82bf50224dd0f706fef4a4c7c71ea25bddbb704d3476a316ffda";
      x86_64-darwin = "f76000b5ac83a62f1cc2a75d542825c91f0184d2c6f70ef7ae2934d89e28813a";
      aarch64-darwin = "ad1d2509d9217032663fcfa0268e2350a03ce9802bf3e70cff482f4de1a3219b";
    };
    meta.description = "Snowflake datasource plugin for Grafana";
  };
  grafana-splunk-datasource = grafanaPlugin {
    pname = "grafana-splunk-datasource";
    version = "4.4.0";
    zipHash = {
      x86_64-linux = "694f971bb1f3aadf7f998d67f743998d24d3fd0dc762fe8335cfae6873208588";
      aarch64-linux = "b53a05e5102847ad2db9c06b6c8c41a3a4a72ee1f17213e2d96b9d90603a2306";
      x86_64-darwin = "a463a1ba8cb0d4cf96997ba439e2fd96b6b20e1903135a4a238d2390bdf56ac4";
      aarch64-darwin = "efdcd266c41c28a054a5c8c762dd63ea5900ad8a66be09d66300027a11166e02";
    };
    meta.description = "Splunk datasource plugin for Grafana";
  };
  grafana-splunk-monitoring-datasource = grafanaPlugin {
    pname = "grafana-splunk-monitoring-datasource";
    version = "1.3.1";
    zipHash = {
      x86_64-linux = "1ca6ac66a69d02438818a03616674ae0e11dcc41293b623111dcddc2eeab6c81";
      aarch64-linux = "299995b79da528a62380b4fae87037077b01b54e20bd6c9d2313fd18fc39af6d";
      x86_64-darwin = "0eb07d1db5cbb72363a3a17a6c9d0b9e043e53fea9187bec999ea7df94581f3f";
      aarch64-darwin = "f32901165532140270d7fff64301a87577e7bdf5c2f4a8a55d6600f066b6d770";
    };
    meta.description = "Splunk Infrastructure Monitoring (formerly SignalFx) datasource plugin for Grafana. Also known as Splunk Observability";
  };
  grafana-strava-datasource = grafanaPlugin {
    pname = "grafana-strava-datasource";
    version = "1.6.1";
    zipHash = {
      x86_64-linux = "c4723d0b56bd6cecf4890834501c56c95ff102be80410ff08cd2585825153a04";
      aarch64-linux = "0d77508b2c98ce74097ebdf0636b6e4c465218dc10d8cf5669139274f4af3b12";
      x86_64-darwin = "e068d002ac2ca5b70769679f5553fb160d92ab15acf5295db968621e82e3ab0e";
      aarch64-darwin = "f5a4b9ac6434280f6899e5ea4988e0bab69d097f8661dba0de1fd1b5a09293b4";
    };
    meta.description = "Strava datasource";
  };
  grafana-sumologic-datasource = grafanaPlugin {
    pname = "grafana-sumologic-datasource";
    version = "0.2.0";
    zipHash = {
      x86_64-linux = "45dc7829eec933a441f50d9d783ca45a0c513c77c8edd6714dc5883bad351cd0";
      aarch64-linux = "5d0fbeebae6e3e78d8323cd939d7e2e7e090cc55906a4b6b6dcd4d8c4f04aac1";
      x86_64-darwin = "d40b95ee962dd7855775ec4de303433e5a80c3d3fa367f6401a5ea8a8aee88b2";
      aarch64-darwin = "935537d709b405f290495d8b6a543a590b8de3b8dab7cae5aa99c1deb0c01bca";
    };
    meta.description = "Sumo Logic datasource plugin for Grafana";
  };
  grafana-synthetic-monitoring-app = grafanaPlugin {
    pname = "grafana-synthetic-monitoring-app";
    version = "1.12.4";
    zipHash = "7874e18d8cd5cdaec1afd1de6c0a0aa2db479257dbbf8d9a0e900a7a854deda4";
    meta.description = "Worldwide black box monitoring for services and applications";
  };
  grafana-testdata-datasource = grafanaPlugin {
    pname = "grafana-testdata-datasource";
    version = "10.3.0-pre-6b4337a";
    zipHash = {
      x86_64-linux = "9efbd5dcb023f05d65a46cd27f447f719e4d7e6d6c74c72f6d608d29d7a8e0be";
      aarch64-linux = "1d1ea6ec7d5c929f4e41b9452ef4466b8f0811551efad8b94c5b5073f221717f";
      x86_64-darwin = "30e3b6067122b0ba560567e093916981e7123c76c4b842bd40193d73cbf313c1";
      aarch64-darwin = "2ac9bb339d45786d9a1e37b65419cf1c409564d68901f753c06172039145b9fd";
    };
    meta.description = "Generates test data in different forms";
  };
  grafana-timestream-datasource = grafanaPlugin {
    pname = "grafana-timestream-datasource";
    version = "2.8.0";
    zipHash = {
      x86_64-linux = "7205f29ce20e35fa72b5df3993207168649bff398de1608523aeb1b73b9a59b9";
      aarch64-linux = "895a4028aa8cde7fefe80b170339228d92e9912c2efd092d1b00556384e9758e";
      x86_64-darwin = "f62d4fa7f51f136194f5c887eb573f6003a09ef098ea7858cfedc0f4847e811b";
      aarch64-darwin = "0f1040dbb5bc9328e837269462a8115e35954fbb2ae1f07080652394b7c10c33";
    };
    meta.description = "Managed timeseries database from amazon";
  };
  grafana-wavefront-datasource = grafanaPlugin {
    pname = "grafana-wavefront-datasource";
    version = "2.2.1";
    zipHash = {
      x86_64-linux = "3d287b77408957c860ca9f3b50a0619f76925eeacc79606c6373deeeb279c3bd";
      aarch64-linux = "0dcdcc50400f0b3ed89ce95353b15492a0986cd863de09785227c73b4c1f1f6a";
      x86_64-darwin = "baa096ff2ed294306352927c7423c023ff3bc1debfd96313db1c6dc62e442e96";
      aarch64-darwin = "c47e11aae67b45cb37a5b45c92c1b466c7b4f44ac937e7baddc33fd937991a0a";
    };
    meta.description = "Wavefront datasource plugin for Grafana";
  };
  grafana-worldmap-panel = grafanaPlugin {
    pname = "grafana-worldmap-panel";
    version = "1.0.6";
    zipHash = "fe582c74110bf477495f55f5432d131c1958754508f1246d805d568a0d4ab699";
    meta.description = "This panel is deprecated and will no longer be supported. Please use Geomap instead. World Map panel for Grafana. Displays time series data or geohash data from Elasticsearch overlaid on a world map.";
  };
  grafana-x-ray-datasource = grafanaPlugin {
    pname = "grafana-x-ray-datasource";
    version = "2.8.1";
    zipHash = {
      x86_64-linux = "4eaca07ba9497fde58062a2b173205d722011ae875f8bbcc1fb3a150c50b47ca";
      aarch64-linux = "14d8aecb21edf51e72c4f9c043d4c08898d1dcd7bf63b7ee812632bc677cf54b";
      x86_64-darwin = "fab7ee104b4d0ceda64993229dee459286e09111157bc59f0ab20df7a608ea73";
      aarch64-darwin = "99584d01438647489a1666e425d29d7b1218079d30e6480d5c407b700e83c34e";
    };
    meta.description = "Data source for Amazon AWS X-Ray";
  };
  grafana-xyzchart-panel = grafanaPlugin {
    pname = "grafana-xyzchart-panel";
    version = "0.1.0";
    zipHash = "4eadc2c474c9bd551e3fcce69a44e2458c9a08a65a94e789c7e421fdff7b7465";
    meta.description = "XYZ chart";
  };
  graph = grafanaPlugin {
    pname = "graph";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "The old default graph panel";
  };
  graphite = grafanaPlugin {
    pname = "graphite";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Open source time series database";
  };
  gretamosa-topology-panel = grafanaPlugin {
    pname = "gretamosa-topology-panel";
    version = "1.0.1";
    zipHash = "5915a957c82adb95e4d21938a232a5ebc96f977f6be4f9634ec481cddaea6411";
    meta.description = "Sigma.js graph panel for grafana";
  };
  gridprotectionalliance-openhistorian-datasource = grafanaPlugin {
    pname = "gridprotectionalliance-openhistorian-datasource";
    version = "1.0.3";
    zipHash = "6f18e8db35e20854dcab9b72ef62bca143de45802da1cc1d07808a44eed1b855";
    meta.description = "Datasource plugin for openHistorian";
  };
  gridprotectionalliance-osisoftpi-datasource = grafanaPlugin {
    pname = "gridprotectionalliance-osisoftpi-datasource";
    version = "4.2.0";
    zipHash = "13f0845800bc763867d3a2cee8cbe0c780a1f6d1208f60d4b3a54f1e48502ba4";
    meta.description = "Datasource plugin for OSIsoft PI Web API";
  };
  groonga-datasource = grafanaPlugin {
    pname = "groonga-datasource";
    version = "1.1.4";
    zipHash = "88359b3b9ff1fc6255a27a6fba0b42f6f301c397b56b365746f1bfc7aa6e7c27";
    meta.description = "Groonga datasource";
  };
  hadesarchitect-cassandra-datasource = grafanaPlugin {
    pname = "hadesarchitect-cassandra-datasource";
    version = "3.0.0";
    zipHash = "247c31eb5bab18a39fc342a228dddad09d87c4b6a08f4df787ed8901bec8afb6";
    meta.description = "Apache Cassandra Datasource for Grafana";
  };
  hamedkarbasi93-kafka-datasource = grafanaPlugin {
    pname = "hamedkarbasi93-kafka-datasource";
    version = "0.2.0";
    zipHash = "c408e1889fb02f36f3946846e9dfe123955c6df4b7cbbb340b49fe16787df1e3";
    meta.description = "Kafka Datasource Plugin";
  };
  hamedkarbasi93-nodegraphapi-datasource = grafanaPlugin {
    pname = "hamedkarbasi93-nodegraphapi-datasource";
    version = "1.0.1";
    zipHash = "f82dbb758902ef7d3f8200b7a24131b3ba75185e8aab9d3e0e470d47d334ef67";
    meta.description = "A datasource that provides data for nodegraph panel via api";
  };
  hawkular-datasource = grafanaPlugin {
    pname = "hawkular-datasource";
    version = "1.1.2";
    zipHash = "619ca61e85ffca37113efc70d331529a180ae8d5233bf4a7b4013c9f20397ec9";
    meta.description = "Hawkular Datasource";
  };
  heatmap = grafanaPlugin {
    pname = "heatmap";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Like a histogram over time";
  };
  histogram = grafanaPlugin {
    pname = "histogram";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "";
  };
  influxdata-flightsql-datasource = grafanaPlugin {
    pname = "influxdata-flightsql-datasource";
    version = "1.0.5";
    zipHash = "9d675664b586bb592e211c0bb7eb3616fb31693ad771d47df4685f91c1d41eb3";
    meta.description = "Query databases that support Flight SQL transport.";
  };
  influxdb = grafanaPlugin {
    pname = "influxdb";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Open source time series database";
  };
  innius-grpc-datasource = grafanaPlugin {
    pname = "innius-grpc-datasource";
    version = "1.2.2";
    zipHash = "e02bb2b63d0828302a23fa17203376481a4f400fcb1e5e7b18ba93773570b821";
    meta.description = "simple grpc datasource plugin";
  };
  innius-video-panel = grafanaPlugin {
    pname = "innius-video-panel";
    version = "1.0.7";
    zipHash = "8ffe4098cda621d387340e3840df18872b2b68e08a078e6d37b7f478076ee9e8";
    meta.description = "Display video from a URL, YouTube ID, or an iFrame.";
  };
  instana-datasource = grafanaPlugin {
    pname = "instana-datasource";
    version = "3.3.9";
    zipHash = "855ba7ae190a38a14f7f4e56d91239113d8061a499cd52de2a2307ff7ac5710e";
    meta.description = "Grafana datasource plugin for Instana: Automatic Infrastructure and Application Monitoring";
  };
  integrationmatters-comparison-panel = grafanaPlugin {
    pname = "integrationmatters-comparison-panel";
    version = "1.1.0";
    zipHash = "83b7a75e6aa53b2d97b46ecb8d04c0f4d2d429184a6619d6b382a75361821732";
    meta.description = "";
  };
  iosb-sensorthings-datasource = grafanaPlugin {
    pname = "iosb-sensorthings-datasource";
    version = "0.0.5";
    zipHash = "08d7430f101cead6fa0d624fd89241ec14816faeb710df9d3cc664c17a1f35eb";
    meta.description = "A data source plugin for loading data from OGC SensorThings APIs into Grafana.";
  };
  isaozler-paretochart-panel = grafanaPlugin {
    pname = "isaozler-paretochart-panel";
    version = "0.3.4";
    zipHash = "b32f6861b3bf5126c7018176aee977a0340c0da7acf478d17c215a085593d0b9";
    meta.description = "Pareto Chart for Grafana";
  };
  isaozler-shiftselector-panel = grafanaPlugin {
    pname = "isaozler-shiftselector-panel";
    version = "0.1.4";
    zipHash = "0891654c4e726106079b7172c4af81315a3552109bfa899ea305ea3ea701fc32";
    meta.description = "The shift selector allows you to adjust the time range of your grafana dashboard to one specific shift or a range of shifts.";
  };
  isovalent-hubble-datasource = grafanaPlugin {
    pname = "isovalent-hubble-datasource";
    version = "1.0.0";
    zipHash = "a6cb77335967f79997a41ca06488e0a238c01e66215c26ba604f4ebd2d1f320c";
    meta.description = "Hubble datasource plugin";
  };
  isovalent-hubbleprocessancestry-panel = grafanaPlugin {
    pname = "isovalent-hubbleprocessancestry-panel";
    version = "1.0.3";
    zipHash = "f3dadc1e7ae71124e9eee06e74229d00febb73422cb831a9fa2aa5499d3d6cb4";
    meta.description = "Hubble Process Ancestry panel plugin for Grafana";
  };
  itrs-obcerv-datasource = grafanaPlugin {
    pname = "itrs-obcerv-datasource";
    version = "1.3.0";
    zipHash = "2024b25352d9820202d17ec72deeef1e2f79c72f1b845c18d6c03700bf87fb4a";
    meta.description = "Data source for ITRS Group observability platform";
  };
  jaeger = grafanaPlugin {
    pname = "jaeger";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Open source, end-to-end distributed tracing";
  };
  jasonlashua-prtg-datasource = grafanaPlugin {
    pname = "jasonlashua-prtg-datasource";
    version = "4.0.4";
    zipHash = "a02ab30427afcccc05ee66ab9343e47db717301eb514a2a7478b017a3860d67d";
    meta.description = "PRTG Datasource plugin for Grafana";
  };
  jdbranham-diagram-panel = grafanaPlugin {
    pname = "jdbranham-diagram-panel";
    version = "1.7.3";
    zipHash = "e79848168bdf4ac542088943fed756072fa5af25e8c7ba2b6d08de6de015a268";
    meta.description = "Display diagrams and charts with colored metric indicators";
  };
  jeanbaptistewatenberg-percent-panel = grafanaPlugin {
    pname = "jeanbaptistewatenberg-percent-panel";
    version = "1.0.6";
    zipHash = "2f9fa5e8bd0cb317307c163a8767a7d73fd34102618ea2440d53e0a66e77f26f";
    meta.description = "Grafana percent+ stat panel. Simply computes and display percent given two metrics.";
  };
  joshhunt-destiny-datasource = grafanaPlugin {
    pname = "joshhunt-destiny-datasource";
    version = "1.0.0";
    zipHash = "bd068d32c00f8de58a266e9b798f731adacae12a1698fb47c5abd2be4b3a3d1b";
    meta.description = "Data source to retrieve Post Game Carnage Reports from Destiny 2";
  };
  kentik-connect-app = grafanaPlugin {
    pname = "kentik-connect-app";
    version = "1.7.0";
    zipHash = "7e21524e89d61ed653a9c3044ef14267aa34d91067aa9ef19270e2e1b26f34ae";
    meta.description = "Kentik Connect Pro allows you to quickly and easily add network activity visibility metrics to your Grafana dashboard.";
  };
  kniepdennis-neo4j-datasource = grafanaPlugin {
    pname = "kniepdennis-neo4j-datasource";
    version = "1.3.1";
    zipHash = "5286cb341ae351a66b0e54445fceb1a81a879785674e92d2046a41d4199003c3";
    meta.description = "Allows Neo4j to be used as a DataSource for Grafana";
  };
  knightss27-weathermap-panel = grafanaPlugin {
    pname = "knightss27-weathermap-panel";
    version = "0.4.3";
    zipHash = "3748e114a604814f1d642275b71718834aebd7bf859062635e3c32ab64d26bbe";
    meta.description = "A simple & sleek network weathermap.";
  };
  larona-epict-panel = grafanaPlugin {
    pname = "larona-epict-panel";
    version = "2.0.6";
    zipHash = "a2128839785dcd587a44a062c35dfca333232930e57bf11dc90227577f372950";
    meta.description = "Enter the URL of the image you want, and add some metrics on it.";
  };
  lework-lenav-panel = grafanaPlugin {
    pname = "lework-lenav-panel";
    version = "1.0.0";
    zipHash = "367369fcf5cfa966b44819a9159fd89633b1081dbc5da47e5f419240bac62702";
    meta.description = "A panel to display website navigation.";
  };
  loki = grafanaPlugin {
    pname = "loki";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Like Prometheus but for logs. OSS logging solution from Grafana Labs";
  };
  macropower-analytics-panel = grafanaPlugin {
    pname = "macropower-analytics-panel";
    version = "2.1.0";
    zipHash = "208c3b61926e64aa1a5d4ea406e872670508385cd0e5a11d2130fedd87ee78ba";
    meta.description = "It's like Google Analytics, but for Grafana dashboards!";
  };
  magnesium-wordcloud-panel = grafanaPlugin {
    pname = "magnesium-wordcloud-panel";
    version = "1.2.4";
    zipHash = "59f2817eec4cdb790da490966271b64ae9b3592ef743a48a27a062fdb139ad62";
    meta.description = "WordCloud / TagCloud Panel";
  };
  manassehzhou-maxcompute-datasource = grafanaPlugin {
    pname = "manassehzhou-maxcompute-datasource";
    version = "0.0.2";
    zipHash = "eb6a7a203ba80ecab97fc7487fe99a239a03c79d54a7c8b9000807256d288e4f";
    meta.description = "Aliyun MaxCompute as a (Backend) Datasource";
  };
  marcuscalidus-svg-panel = grafanaPlugin {
    pname = "marcuscalidus-svg-panel";
    version = "0.3.4";
    zipHash = "f5b054ba538fafc3e8984f4601ab20ef4ee2e96af6880cfff8fc1e965944a8a9";
    meta.description = "SVG panel for grafana";
  };
  marcusolsson-calendar-panel = grafanaPlugin {
    pname = "marcusolsson-calendar-panel";
    version = "2.3.1";
    zipHash = "c94d2a53f91c971728e7eafef094bb55131502cae934d11da14116621354d93d";
    meta.description = "Display events and set time range";
  };
  marcusolsson-csv-datasource = grafanaPlugin {
    pname = "marcusolsson-csv-datasource";
    version = "0.6.11";
    zipHash = {
      x86_64-linux = "cb9314745c10b195529daf7597d4596732fa1285a517a5e29784d893440ef2e3";
      aarch64-linux = "71fa0f6ec47cab723392d068feee950ebd1b3685c2845e31827d84709539b4d8";
      x86_64-darwin = "71cd6482bb61ad99675d35d7e47e60287d047fcaef86cc98097628a4131e9892";
      aarch64-darwin = "e7b1252696a9fb206e18eb3c7160b74ceff44c9327358c4e546d7fe904680cc9";
    };
    meta.description = "A data source for loading CSV data";
  };
  marcusolsson-dynamictext-panel = grafanaPlugin {
    pname = "marcusolsson-dynamictext-panel";
    version = "4.2.0";
    zipHash = "4f8b44e18eb176d43ca02880517e465cc7784457259f3fc0fcd0bbcde4947f4d";
    meta.description = "Data-driven text with Markdown and Handlebars support";
  };
  marcusolsson-gantt-panel = grafanaPlugin {
    pname = "marcusolsson-gantt-panel";
    version = "0.8.1";
    zipHash = "e358340d05454602813b08d655baff2c591e111a8196020016281c08e8115dca";
    meta.description = "Tasks and processes over time";
  };
  marcusolsson-hexmap-panel = grafanaPlugin {
    pname = "marcusolsson-hexmap-panel";
    version = "0.3.3";
    zipHash = "615ecc340f4a6f891d0a04c3a2f931392d1d1497c027dc111a6b6b774458f13b";
    meta.description = "Hexagonal tiling of data";
  };
  marcusolsson-hourly-heatmap-panel = grafanaPlugin {
    pname = "marcusolsson-hourly-heatmap-panel";
    version = "2.0.1";
    zipHash = "1d58581dc793d8013c24dfe97e6556a44095080e007144176ecaa9522965b298";
    meta.description = "Heatmap for the hours of the day";
  };
  marcusolsson-json-datasource = grafanaPlugin {
    pname = "marcusolsson-json-datasource";
    version = "1.3.9";
    zipHash = "37f0678278efd252da9d0f2e72ab0ca539b58aa6be3048a0a8cd8efbf4c6f49e";
    meta.description = "A data source plugin for loading JSON APIs into Grafana.";
  };
  marcusolsson-static-datasource = grafanaPlugin {
    pname = "marcusolsson-static-datasource";
    version = "3.0.0";
    zipHash = "810b6060b866f0250d33c1ad3e955e5b6c9bf02f14b266ff0346d2c07d746afd";
    meta.description = "Static Data Source for Grafana";
  };
  marcusolsson-treemap-panel = grafanaPlugin {
    pname = "marcusolsson-treemap-panel";
    version = "2.0.1";
    zipHash = "d88d299e43a07a8ed0ef9caf1307ab2d430a0c152de01922a6bbb860aa114196";
    meta.description = "Area-based visualization of hierarchical data";
  };
  mckn-funnel-panel = grafanaPlugin {
    pname = "mckn-funnel-panel";
    version = "1.0.0";
    zipHash = "90f459fba506ae4b37d2594fbd40923b1b91984a0c3052c3a708f0d3a8bd3cf8";
    meta.description = "Visualize how data moves through a process";
  };
  mesak-imagesave-panel = grafanaPlugin {
    pname = "mesak-imagesave-panel";
    version = "1.0.3";
    zipHash = "2d1f663788a2dce3f67c98b994cc835420d0982cb778273ae8992f682e0c0868";
    meta.description = "save image to grafana";
  };
  meteostat-meteostat-datasource = grafanaPlugin {
    pname = "meteostat-meteostat-datasource";
    version = "0.1.5";
    zipHash = "ce10353762e028270659deb759f04532516662e3267bc6703d001e67a8bf830f";
    meta.description = "Access historic weather data using the meteostat API";
  };
  michaeldmoore-annunciator-panel = grafanaPlugin {
    pname = "michaeldmoore-annunciator-panel";
    version = "1.1.0";
    zipHash = "bd8f6037aa7e07eb80b25486d53cdf8bcd364dc3884416751eb5957d8370a3dc";
    meta.description = "Enhanced version of built-in SingleStat panel, with specialized display of thresholds and value-sensative presentation";
  };
  michaeldmoore-multistat-panel = grafanaPlugin {
    pname = "michaeldmoore-multistat-panel";
    version = "1.7.2";
    zipHash = "52ac96f857276d25ac3ca333e5cb1d174c8cc4889253e289aad27b16d4484f75";
    meta.description = "Enhanced version of built-in SingleStat panel, for queries involving multi-valued recordsets";
  };
  michaeldmoore-scatter-panel = grafanaPlugin {
    pname = "michaeldmoore-scatter-panel";
    version = "1.2.0";
    zipHash = "60c4127198e7e26f5a4fedd64eb659fbc05fe8cd3bd48b92acadfcc4623ed8fd";
    meta.description = "A really easy-to-use scatter-plot plugin panel for table formatted Grafana data";
  };
  mofengfeng-greptimedb-datasource = grafanaPlugin {
    pname = "mofengfeng-greptimedb-datasource";
    version = "0.2.5";
    zipHash = "7e4446ff454ad500a1d7855331d3668101f9c242691e2440710f0e07170a350e";
    meta.description = "Open source time series database";
  };
  monasca-datasource = grafanaPlugin {
    pname = "monasca-datasource";
    version = "1.0.1";
    zipHash = "30da8d8abf2e03cb8546b1df6e0a08d0ce4a39bcf94cfba0cba05da62b47ca84";
    meta.description = "datasource for the Monasca Api";
  };
  monitoringartist-monitoringart-datasource = grafanaPlugin {
    pname = "monitoringartist-monitoringart-datasource";
    version = "1.0.1";
    zipHash = "0b42a062d6df5177551e4b70af3e55e8c78cdec96992c22b3231caab643eea4b";
    meta.description = "Monitoring Art datasource for Grafana.";
  };
  moogsoft-aiops-app = grafanaPlugin {
    pname = "moogsoft-aiops-app";
    version = "9.0.0";
    zipHash = "31d7ffd5539d0ecde35efc0da4cec002aa5791572066e8e2da775e682884d644";
    meta.description = "Moogsoft AIOps App";
  };
  mssql = grafanaPlugin {
    pname = "mssql";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Data source for Microsoft SQL Server compatible databases";
  };
  mtanda-google-calendar-datasource = grafanaPlugin {
    pname = "mtanda-google-calendar-datasource";
    version = "1.0.5";
    zipHash = "c44b9bce9d87e7729d3d250e9e5f33c0a80665d583e440cc2fcc6488b3514126";
    meta.description = "google calendar datasource";
  };
  mtanda-heatmap-epoch-panel = grafanaPlugin {
    pname = "mtanda-heatmap-epoch-panel";
    version = "0.1.8";
    zipHash = "324d68fa7c41ed8f8e26c2195f53a030d3d89ca55d9ea148eade88217607247e";
    meta.description = "Heatmap Panel for Grafana";
  };
  mtanda-histogram-panel = grafanaPlugin {
    pname = "mtanda-histogram-panel";
    version = "0.1.7";
    zipHash = "c51e324b729a87862c5953b24dbf3cb6828c93f7d25fd9e3e25843d801b78054";
    meta.description = "Histogram Panel for Grafana";
  };
  mxswat-separator-panel = grafanaPlugin {
    pname = "mxswat-separator-panel";
    version = "1.0.1";
    zipHash = "ad15a76825ff3fe8e8114f642dc97c0f648549396632586f436fd8252155c59f";
    meta.description = "A simple separator panel";
  };
  mysql = grafanaPlugin {
    pname = "mysql";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Data source for MySQL databases";
  };
  nagasudhirpulla-api-datasource = grafanaPlugin {
    pname = "nagasudhirpulla-api-datasource";
    version = "1.2.4";
    zipHash = "cc6b3a02c24be7bdd3e05f09809016636d46e31e8d2555c446015eacf2ec9d5b";
    meta.description = "";
  };
  natel-discrete-panel = grafanaPlugin {
    pname = "natel-discrete-panel";
    version = "0.1.1";
    zipHash = "edde37659644e4c3bf5ec08ad3b0bee1f917764af3a622a7142e0ac25afa6a3b";
    meta.description = "Discrete Events grafana";
  };
  natel-influx-admin-panel = grafanaPlugin {
    pname = "natel-influx-admin-panel";
    version = "0.0.6";
    zipHash = "8697f7541e9e6b911d198574ab51c8a33d9f5f7d64c0a6a2e60649ac29d9130d";
    meta.description = "InfluxDB admin for grafana";
  };
  natel-plotly-panel = grafanaPlugin {
    pname = "natel-plotly-panel";
    version = "0.0.7";
    zipHash = "818ab33b42a1421b561f4e44f0cd19cd1a56767d3952045b8042a4da58bd470e";
    meta.description = "Scatter plots and more";
  };
  natel-usgs-datasource = grafanaPlugin {
    pname = "natel-usgs-datasource";
    version = "0.0.3";
    zipHash = "4391769255b0f02adf98aad4941e570683d4b10b6c564d8c1d65a9220a6fa6cb";
    meta.description = "Read USGS sensor data";
  };
  needleinajaystack-haystack-datasource = grafanaPlugin {
    pname = "needleinajaystack-haystack-datasource";
    version = "0.0.11";
    zipHash = "f16be3d4f3627f51a1073049bfb212309f80fd6c93efa8009441163289d709ff";
    meta.description = "A Grafana data source for Haystack tagged data";
  };
  neocat-cal-heatmap-panel = grafanaPlugin {
    pname = "neocat-cal-heatmap-panel";
    version = "0.0.4";
    zipHash = "e7ffe4b6408f512303a94f16d2b9eaf513c907aea53869d49896acdb6617cdd9";
    meta.description = "Cal-HeatMap panel for Grafana";
  };
  netdatacloud-netdata-datasource = grafanaPlugin {
    pname = "netdatacloud-netdata-datasource";
    version = "2.0.0";
    zipHash = "1eae345fc06a9991075c8c8e5235f1a3867070d778f728a23c02e1723b2445e9";
    meta.description = "netdata datasource plugin";
  };
  netsage-bumpchart-panel = grafanaPlugin {
    pname = "netsage-bumpchart-panel";
    version = "1.1.1";
    zipHash = "f989aaceb8058d485cc33e151c9e562f09181078b15be1fbb3134ca95b868eb3";
    meta.description = "Bump Chart Panel Plugin";
  };
  netsage-sankey-panel = grafanaPlugin {
    pname = "netsage-sankey-panel";
    version = "1.1.1";
    zipHash = "5a65dc22c57a8cfd99e77a9baac100125408f95ce824569553c89bf75f9960cf";
    meta.description = "Sankey Panel Plugin for Grafana";
  };
  netsage-slopegraph-panel = grafanaPlugin {
    pname = "netsage-slopegraph-panel";
    version = "1.1.1";
    zipHash = "c9dd4b0a4cb203c505bf0bfd2201c6a4ddcc7389bce12d79bbf821816684eb85";
    meta.description = "Slope Graph Panel";
  };
  nikosc-percenttrend-panel = grafanaPlugin {
    pname = "nikosc-percenttrend-panel";
    version = "1.0.7";
    zipHash = "b9068740557d43490cef7b58c04ed230b3b27973a7310b242448fe34887f9ffa";
    meta.description = "Percent change with trend display";
  };
  nline-plotlyjs-panel = grafanaPlugin {
    pname = "nline-plotlyjs-panel";
    version = "1.6.1";
    zipHash = "a3cdf4eb2e48146b63d006b0dd1d533a50c2dcc257206c15296412275fefa6d0";
    meta.description = "Render charts with Plotly.js";
  };
  novalabs-annotations-panel = grafanaPlugin {
    pname = "novalabs-annotations-panel";
    version = "0.0.2";
    zipHash = "5e0c208781ef1919811f6b6e16a292108d219680ef8f5db9288918069fb9e21e";
    meta.description = "Annotations panel for Grafana";
  };
  novatec-sdg-panel = grafanaPlugin {
    pname = "novatec-sdg-panel";
    version = "4.0.3";
    zipHash = "47ae745ff48c522cd9b76e946a3884f0be4aeb2fc6194a5423233c1c20a6fe64";
    meta.description = "Service Dependency Graph panel for Grafana. Shows metric-based, dynamic dependency graph between services, indicates responsetime, load and error rate statistic for individual services and communication edges. Shows communication to external services, such as Web calls, database calls, message queues, LDAP calls, etc. Provides a details dialog for each selected service that shows statistics about incoming and outgoing traffic.";
  };
  oci-logs-datasource = grafanaPlugin {
    pname = "oci-logs-datasource";
    version = "4.0.0";
    zipHash = "3ea7ce0bd3dc0c0b0af207fe0bc11f7a5abd9f45719525c90ed9d18fbd77b2d6";
    meta.description = "Oracle Cloud Infrastructure Logs Data Source for Grafana";
  };
  oci-metrics-datasource = grafanaPlugin {
    pname = "oci-metrics-datasource";
    version = "5.0.0";
    zipHash = "a06a2ba7fe2987d382609d370ffd5eb08fd84f2b673619bb9b9803c54f90e1f3";
    meta.description = "Oracle Cloud Infrastructure Metrics Data Source for Grafana";
  };
  opengemini-opengemini-datasource = grafanaPlugin {
    pname = "opengemini-opengemini-datasource";
    version = "1.0.0";
    zipHash = "888bc60da81f318e904854a71e26e0b4bd83f5f920a267c1a63a4aba96f0bf37";
    meta.description = "openGemini grafana datasource plugin";
  };
  opennms-opennms-app = grafanaPlugin {
    pname = "opennms-opennms-app";
    version = "9.0.10";
    zipHash = "9e508f980ed64e4bcfe6114fe25308b0992bf6155aab0e56d1d8fefcf4e5bbf3";
    meta.description = "Create flexible dashboards using data from OpenNMS® Horizon™ and/or OpenNMS® Meridian™.";
  };
  opentsdb = grafanaPlugin {
    pname = "opentsdb";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Open source time series database";
  };
  operato-windrose-panel = grafanaPlugin {
    pname = "operato-windrose-panel";
    version = "1.1.1";
    zipHash = "fe250efda9f60853dbc7d677494d845e2c6030ce3fd60a22e5ce344d9f110bf8";
    meta.description = "Wind parameter visualization panel";
  };
  orchestracities-iconstat-panel = grafanaPlugin {
    pname = "orchestracities-iconstat-panel";
    version = "1.2.3";
    zipHash = "6178612cbe78377b28f5f2fe288cca790e57456c64ea30d6cf969ac7992ff66a";
    meta.description = "";
  };
  orchestracities-map-panel = grafanaPlugin {
    pname = "orchestracities-map-panel";
    version = "1.4.4";
    zipHash = "89b71c3f2791ef3d953acc0f69edacc02b0cea52c6203c61f2bb8019cff830d7";
    meta.description = "Orchestra Cities Map";
  };
  parca-datasource = grafanaPlugin {
    pname = "parca-datasource";
    version = "0.0.36";
    zipHash = "612ce905de66df47faada9ca0769d438952de4d5c07c9538fd0e7b166018b1fa";
    meta.description = "Parca datasource plugin for Grafana";
  };
  parca-panel = grafanaPlugin {
    pname = "parca-panel";
    version = "0.0.36";
    zipHash = "bc73f5cf01968310ca525789cab7aeb26e330a3ef9c088431821665785efdd12";
    meta.description = "Parca panel plugin for Grafana";
  };
  parseable-parseable-datasource = grafanaPlugin {
    pname = "parseable-parseable-datasource";
    version = "1.1.0";
    zipHash = "77578af8db9091d026e240f26f1b13df4dadd3a02480b17280f56f895497e74b";
    meta.description = "Parseable is an open source, Kubernetes native, log storage and observability platform. This plugin allows you to visualize your Parseable logs in Grafana.";
  };
  paytm-kapacitor-datasource = grafanaPlugin {
    pname = "paytm-kapacitor-datasource";
    version = "0.1.3";
    zipHash = "5b4d5102e994f01ea9d91fa1a6627c98366687c35b73a2e48e6b5866a1aa1fc0";
    meta.description = "kapacitor simple json datasource";
  };
  performancecopilot-pcp-app = grafanaPlugin {
    pname = "performancecopilot-pcp-app";
    version = "5.0.0";
    zipHash = "7257577d4f504ffa5917765e6cbfa04a112ee79b32ce9e0f9f5a6c1bffb7ed49";
    meta.description = "Performance Co-Pilot Grafana Plugin";
  };
  petrslavotinek-carpetplot-panel = grafanaPlugin {
    pname = "petrslavotinek-carpetplot-panel";
    version = "0.1.2";
    zipHash = "9525e0e1fffc91d79a3fa2751b3e34ef861676a347932fb49dfd559d7e11791b";
    meta.description = "Carpet plot panel plugin for grafana";
  };
  pgillich-tree-panel = grafanaPlugin {
    pname = "pgillich-tree-panel";
    version = "0.1.9";
    zipHash = "d8b574264f736e26631f0be5b40c5d24831e28129065845f45d836107b101510";
    meta.description = "Tree View for JSON API datasource. It can show JSON REST API responses, for example: Kubernetes API";
  };
  pgollangi-firestore-datasource = grafanaPlugin {
    pname = "pgollangi-firestore-datasource";
    version = "0.2.6";
    zipHash = "e2a15d460be1a3e1da62eb9c4da6c0420995c8b90552edcd7573568f1f85aa97";
    meta.description = "Google firestore datasource plugin for grafana";
  };
  philipsgis-phlowchart-panel = grafanaPlugin {
    pname = "philipsgis-phlowchart-panel";
    version = "0.1.0";
    zipHash = "0563230236fe97144445c4381ea390a6fccc59beb2187473c739435a0d2db9cc";
    meta.description = "A Grafana panel plugin to render interactive flowchart visualization of directed graph data.";
  };
  pixie-pixie-datasource = grafanaPlugin {
    pname = "pixie-pixie-datasource";
    version = "0.0.9";
    zipHash = "99180e906042baf39a4d44aae11ff4e30237d32b94d0348d94ea6edaeca6fca2";
    meta.description = "Pixie's Grafana Datasource Plugin";
  };
  postgres = grafanaPlugin {
    pname = "postgres";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Data source for PostgreSQL and compatible databases";
  };
  pr0ps-trackmap-panel = grafanaPlugin {
    pname = "pr0ps-trackmap-panel";
    version = "2.1.4";
    zipHash = "33fe2d63340a8ecdca9aa6be6b2dded652ee16d27f55d3bee99d7f06b45966e0";
    meta.description = "A plugin for Grafana that visualizes GPS points as a line on an interactive map.";
  };
  praj-ams-datasource = grafanaPlugin {
    pname = "praj-ams-datasource";
    version = "1.2.1";
    zipHash = "fdf6966fae271b365e8a5b8b3929c91195e68e546fbed7ba2c7de87462c5f2be";
    meta.description = "";
  };
  prometheus = grafanaPlugin {
    pname = "prometheus";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Open source time series database & alerting";
  };
  propeldata-graphql-datasource = grafanaPlugin {
    pname = "propeldata-graphql-datasource";
    version = "1.0.11";
    zipHash = "fcdf7d4f3e2176da86d43e6d9183d2a6142e664e782c8fdc4cc09141c005a4a1";
    meta.description = "Grafana data source plugin to connect to Propel";
  };
  pue-solr-datasource = grafanaPlugin {
    pname = "pue-solr-datasource";
    version = "1.0.3";
    zipHash = "7b9271c2b34612f632f8f8bd1bcc3932378898bb95e0e67fcb5920dc018c706e";
    meta.description = "Solr datasource";
  };
  quasardb-datasource = grafanaPlugin {
    pname = "quasardb-datasource";
    version = "3.8.3";
    zipHash = "d5d37cd42e6920b54cd71e907b6351c638efca63b8dffbdb29648ee126468943";
    meta.description = "Data source for QuasarDB, the high performance timeseries database for the most demanding use cases";
  };
  quickwit-quickwit-datasource = grafanaPlugin {
    pname = "quickwit-quickwit-datasource";
    version = "0.2.4";
    zipHash = "41c2e216fba27e6dd932bff81f4ac7ad5667d307239e5f99dd7e34cefe9b0a76";
    meta.description = "Quickwit is an OSS, Cloud-Native search engine on object storage. This plugin allows you to visualize logs and build dashboards on top of Quickwit.";
  };
  rackerlabs-blueflood-datasource = grafanaPlugin {
    pname = "rackerlabs-blueflood-datasource";
    version = "0.0.3";
    zipHash = "f8dbfce64676b470e7ff64190387762e192b3f522cd1a9a310421ebdd093aad9";
    meta.description = "blueflood datasource";
  };
  radensolutions-netxms-datasource = grafanaPlugin {
    pname = "radensolutions-netxms-datasource";
    version = "1.2.3";
    zipHash = "4ae3d95654e7f7a9c96961382c04de9e1e11d21f269944be5b45f3a2f8922c55";
    meta.description = "NetXMS datasource for grafana";
  };
  redis-app = grafanaPlugin {
    pname = "redis-app";
    version = "2.2.1";
    zipHash = "d59cc968686533a09a4de723ebd6aa27d7ea37bc184ac88308c4d156464951bd";
    meta.description = "Provides Application pages and custom panels for Redis Data Source.";
  };
  redis-datasource = grafanaPlugin {
    pname = "redis-datasource";
    version = "2.2.0";
    zipHash = "6b86adf28d7ce5748ec8dc5964a7dbd3f8f5095a0a43d259c74a1fa0f501a8ab";
    meta.description = "Allows to connect to any Redis database On-Premises and in the Cloud.";
  };
  redis-explorer-app = grafanaPlugin {
    pname = "redis-explorer-app";
    version = "2.1.1";
    zipHash = "b792fd5d444d72cc036d959299e86cfc9614ecda04c215f521fee085b8b9d3d8";
    meta.description = "Allows connecting to Redis Enterprise software clusters using REST API.";
  };
  rocketcom-astrotheme-panel = grafanaPlugin {
    pname = "rocketcom-astrotheme-panel";
    version = "1.0.6";
    zipHash = "9555b6c2f87a842fea3bc6d47240454da28e3a5a1aabe4504c6db4f8510ad210";
    meta.description = "An Astro UXDS theme for Grafana dashboards.";
  };
  runreveal-runreveal-datasource = grafanaPlugin {
    pname = "runreveal-runreveal-datasource";
    version = "0.2.1";
    zipHash = "2a9e12e3f0c0ddf0622459f71106bae2d6b34564a9119aa4624404ca14085d64";
    meta.description = "RunReveal datasource plugin for Grafana.";
  };
  ryantxu-ajax-panel = grafanaPlugin {
    pname = "ryantxu-ajax-panel";
    version = "0.1.0";
    zipHash = "85b14b59e1ed320d5b97bdea347612f5103f402c842d069be624f4c13ed7427a";
    meta.description = "AJAX panel for grafana";
  };
  sameeraswal-odometer-panel = grafanaPlugin {
    pname = "sameeraswal-odometer-panel";
    version = "1.0.0";
    zipHash = "60214d37de35257c129ba9fb71dd507e1a084290a034d8dbe8b1121ea46d6f88";
    meta.description = "Display moving counter for countdown countup";
  };
  satellogic-3d-globe-panel = grafanaPlugin {
    pname = "satellogic-3d-globe-panel";
    version = "0.1.1";
    zipHash = "14e19f0bcece1d5c8262fb0df391934e2bf2fb11289d6d59d7832f11c94a80d4";
    meta.description = "A Cesium based 3D Globe panel plugin.";
  };
  savantly-heatmap-panel = grafanaPlugin {
    pname = "savantly-heatmap-panel";
    version = "0.2.1";
    zipHash = "748f95a28709cf747bc50253ac117d9abb308c93aa6b695b99244491ec3b9b48";
    meta.description = "Heatmap panel for grafana";
  };
  scadavis-synoptic-panel = grafanaPlugin {
    pname = "scadavis-synoptic-panel";
    version = "2.0.0";
    zipHash = "2abf7b9dd6a92eb904bfdf6367bd66178a0fa3b5e3b3c545288b696ff99fbd81";
    meta.description = "SCADA-like synoptic panel for grafana";
  };
  sebastiangunreben-cdf-panel = grafanaPlugin {
    pname = "sebastiangunreben-cdf-panel";
    version = "0.2.7";
    zipHash = "cc25be9138087ba1da2cb5c9b50e1979f6ef5f9c53e0dd64ac5e01eac08d4609";
    meta.description = "Panel for CDF visualizations";
  };
  sentinelone-dataset-datasource = grafanaPlugin {
    pname = "sentinelone-dataset-datasource";
    version = "3.1.3";
    zipHash = "dad155bea6941fdb418c4059bdade2df2cb65a085e7c8721c3d3dc609338ffe3";
    meta.description = "Scalyr Observability Platform";
  };
  serrrios-statusoverview-panel = grafanaPlugin {
    pname = "serrrios-statusoverview-panel";
    version = "0.0.4";
    zipHash = "58ce2566f48a2b7b788a38311be6eab942d6e7f2a1416eb4fa8ee35f6c523276";
    meta.description = "Status Overview Panel for Grafana";
  };
  servicenow-cloudobservability-datasource = grafanaPlugin {
    pname = "servicenow-cloudobservability-datasource";
    version = "3.3.0";
    zipHash = "e660e7fdd6794fe57fadfabaf39582f84e76e56bb18ffa8e880e4daefcefebf5";
    meta.description = "Instantly visualize ServiceNow Cloud Observability (formerly known as Lightstep) data in Grafana";
  };
  shorelinesoftware-shoreline-datasource = grafanaPlugin {
    pname = "shorelinesoftware-shoreline-datasource";
    version = "1.2.1";
    zipHash = "3b553bb0e41ce0736b6ba4ff99d308648c4ee85b9670cccb7fe248af75a23416";
    meta.description = "Shoreline data source plugin for Grafana";
  };
  sidewinder-datasource = grafanaPlugin {
    pname = "sidewinder-datasource";
    version = "0.2.1";
    zipHash = "3a26017161737a281842110ca72cb6e38de2a2e4e58c7559d22e1ae73085074f";
    meta.description = "Sidewinder Grafana Datasource";
  };
  simpod-json-datasource = grafanaPlugin {
    pname = "simpod-json-datasource";
    version = "0.6.3";
    zipHash = "1ff8e61ffbf32168ad805ee09532173c06d544652a225d2ab062fafd4f2b7e12";
    meta.description = "Load JSON data over your arbitrary HTTP backend";
  };
  skydive-datasource = grafanaPlugin {
    pname = "skydive-datasource";
    version = "1.2.1";
    zipHash = "673c65d18a28b0e44da6bb1f4fcb3348969bf7aca81820b85b8656d2a97760a0";
    meta.description = "Skydive datasource";
  };
  smartmakers-trafficlight-panel = grafanaPlugin {
    pname = "smartmakers-trafficlight-panel";
    version = "1.0.1";
    zipHash = "d09a29f69243e8d8fc9fc086737aef743aa5bfdd9a76ab5562bdaaf326929f97";
    meta.description = "Add colour indicator for measurements to a picture in Grafana";
  };
  sneller-sneller-datasource = grafanaPlugin {
    pname = "sneller-sneller-datasource";
    version = "1.1.2";
    zipHash = "87d1212603cd7d06ff870507f1f1201033ad72f35297747b52f5c1e2de7e07d4";
    meta.description = "";
  };
  sni-pnp-datasource = grafanaPlugin {
    pname = "sni-pnp-datasource";
    version = "2.0.2";
    zipHash = "6529d7161035dc4a4d9f543f266892a22c7ef39ed38e469e0f3f9782f28df38b";
    meta.description = "pnp4nagios datasource";
  };
  sni-thruk-datasource = grafanaPlugin {
    pname = "sni-thruk-datasource";
    version = "2.0.3";
    zipHash = "927abc9525edee4aa300ef6293160a47a669939eb4d1b916bda3631369e39874";
    meta.description = "thruk datasource";
  };
  snuids-radar-panel = grafanaPlugin {
    pname = "snuids-radar-panel";
    version = "1.5.1";
    zipHash = "724da2132422e32812746b5591ba0857dc4e60cfe224c1363680fe0976a63a0b";
    meta.description = "Radar Graph for grafana";
  };
  snuids-svg-panel = grafanaPlugin {
    pname = "snuids-svg-panel";
    version = "1.0.0";
    zipHash = "d3c949a9ee21db49b748a9b1daf34927ed06a543b101d51712fba4c56eac5c94";
    meta.description = "A panel that displays values as colored svg images";
  };
  snuids-trafficlights-panel = grafanaPlugin {
    pname = "snuids-trafficlights-panel";
    version = "1.6.0";
    zipHash = "7c923f6d960a796264308d47d650b6dd3232881dcd18fe4ed6f1146d049b374e";
    meta.description = "Traffic lights for grafana";
  };
  speakyourcode-button-panel = grafanaPlugin {
    pname = "speakyourcode-button-panel";
    version = "0.3.2";
    zipHash = "298f0aa37261c517d0aaa7db3ff44d1d1dcd1bf96c73ef1d784f21a29a2e38fe";
    meta.description = "Grafana button control panel";
  };
  spiceai-spicexyz-datasource = grafanaPlugin {
    pname = "spiceai-spicexyz-datasource";
    version = "0.0.3";
    zipHash = "f1b268d80b7f880a27e3a6dcc87ba84a958e79ddc3db5e1c10ccfc085b733d96";
    meta.description = "Spice.ai Grafana Datasource Plugin";
  };
  sskgo-perfcurve-panel = grafanaPlugin {
    pname = "sskgo-perfcurve-panel";
    version = "1.5.0";
    zipHash = "106fb649bcd8dd61f7551dcd5b78a8cc1e04a2bf11a581e51e49a67c086dd2ac";
    meta.description = "Plot rotating machine operation point on a performance curve.";
  };
  stackdriver = grafanaPlugin {
    pname = "stackdriver";
    version = "1.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Data source for Google's monitoring service (formerly named Stackdriver)";
  };
  stagemonitor-elasticsearch-app = grafanaPlugin {
    pname = "stagemonitor-elasticsearch-app";
    version = "0.83.3";
    zipHash = "7e266d825d0417ad126b88cd670d984a4229c9bd43907a7fe54c969cb9aa289a";
    meta.description = "stagemonitor Elasticsearch Dashboards";
  };
  stat = grafanaPlugin {
    pname = "stat";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Big stat values & sparklines";
  };
  streamr-datasource = grafanaPlugin {
    pname = "streamr-datasource";
    version = "1.5.0";
    zipHash = "708c4b30064a55afa2447e0be0a38b0a076ea7d5c357a5d61f75ef4fd47e5e0e";
    meta.description = "Streamr data source plugin for Grafana";
  };
  svennergr-hackerone-datasource = grafanaPlugin {
    pname = "svennergr-hackerone-datasource";
    version = "1.0.4";
    zipHash = "0dc72c15594fdc65bc826cb5ba212356a894b0cc81db650b017bff10a919b0d0";
    meta.description = "Plugin to import HackerOne information into Grafana.";
  };
  table = grafanaPlugin {
    pname = "table";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Supports many column styles";
  };
  tailosstg-map-panel = grafanaPlugin {
    pname = "tailosstg-map-panel";
    version = "1.1.2";
    zipHash = "b7a84d19334800ce3397ccf5cda73ec5cde098f27b9881d27ee4eeac386c4a19";
    meta.description = "Visualize image files for indoor maps.";
  };
  tdengine-datasource = grafanaPlugin {
    pname = "tdengine-datasource";
    version = "3.3.5";
    zipHash = "90f6ff5c137daef1a460efc2c2f062819853a0b1252edcbf50aca34071551447";
    meta.description = "Grafana datasource plugin for TDengine";
  };
  tempo = grafanaPlugin {
    pname = "tempo";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "High volume, minimal dependency trace storage.  OSS tracing solution from Grafana Labs.";
  };
  text = grafanaPlugin {
    pname = "text";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Supports markdown and html content";
  };
  thalysantana-appcenter-datasource = grafanaPlugin {
    pname = "thalysantana-appcenter-datasource";
    version = "1.0.0";
    zipHash = "5bf4da5b0589f81aa979972c546d48753b6b75df79261246d54ed363256240a8";
    meta.description = "App Center data source for Grafana";
  };
  thiagoarrais-matomotracking-panel = grafanaPlugin {
    pname = "thiagoarrais-matomotracking-panel";
    version = "0.2.3";
    zipHash = "2cec05c48a4fcb3469c04821066fd53178bcf7bb145f23ae95a9d0df64b27c02";
    meta.description = "Panel for tracking via Matomo";
  };
  timeseries = grafanaPlugin {
    pname = "timeseries";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Time based line, area and bar charts";
  };
  timomyl-breadcrumb-panel = grafanaPlugin {
    pname = "timomyl-breadcrumb-panel";
    version = "1.2.0";
    zipHash = "f3e433cbc9d1af1a07d8a2ba64912dedc6c3c838ba081252439274a7b80a0823";
    meta.description = "Breadcrumb Panel for Grafana";
  };
  timomyl-organisations-panel = grafanaPlugin {
    pname = "timomyl-organisations-panel";
    version = "1.4.0";
    zipHash = "d538fcc9ac92f5c6fab5051429dcdfa93e18c6c5c4b49abaebd1ff3558f2069b";
    meta.description = "Organisations Panel for Grafana";
  };
  trino-datasource = grafanaPlugin {
    pname = "trino-datasource";
    version = "1.0.5";
    zipHash = "18557e897834ed684afd866ce84a43170bed49c8c85e36a0bc0e8ac0f5e4055e";
    meta.description = "The Trino datasource allows to query and visualize Trino data from within Grafana.";
  };
  vaduga-mapgl-panel = grafanaPlugin {
    pname = "vaduga-mapgl-panel";
    version = "1.0.2";
    zipHash = "7adcfbd598247d612df53b4eb7e2b0d757ce6f66876f1664391cb8f636bb382f";
    meta.description = "Geospatial map for large datasets using deck.gl";
  };
  ventura-psychrometric-panel = grafanaPlugin {
    pname = "ventura-psychrometric-panel";
    version = "4.0.1";
    zipHash = "2e05618e0b5f3d92045198311f4b31c1e6b8b6ec3891fc17bd60d56faa3d46ff";
    meta.description = "View air conditions on a psychrometric chart.";
  };
  vertamedia-clickhouse-datasource = grafanaPlugin {
    pname = "vertamedia-clickhouse-datasource";
    version = "2.5.4";
    zipHash = "1bd96f6b6dea22506ed36675b2b85009b98a3906895c52c649b2d0360df4dbb6";
    meta.description = "Altinity Grafana datasource for ClickHouse";
  };
  vertica-grafana-datasource = grafanaPlugin {
    pname = "vertica-grafana-datasource";
    version = "2.1.1";
    zipHash = "4e4137113489c082647f45252f9da48d6ba8e14e079a222ee57a28d3684b8ceb";
    meta.description = "Data source for Vertica and compatible databases";
  };
  verticle-flowhook-datasource = grafanaPlugin {
    pname = "verticle-flowhook-datasource";
    version = "0.1.3";
    zipHash = "1de7f5e9b6ebbfb8a27f25f3d6adc7299a27b6f4fe503b2e753bf670e23f656e";
    meta.description = "Consume webhook payloads, map and route them into your Grafana Logs panel.";
  };
  volkovlabs-echarts-panel = grafanaPlugin {
    pname = "volkovlabs-echarts-panel";
    version = "5.1.0";
    zipHash = "d1d7b69e570049cba63229af129bf3c295e7ca72cf4e6456e761b5c85c14c478";
    meta.description = "Powerful charting and visualization library Apache ECharts";
  };
  volkovlabs-form-panel = grafanaPlugin {
    pname = "volkovlabs-form-panel";
    version = "3.3.0";
    zipHash = "386579886e0b7c80cd336dc841640f26d65406a521323b66159f669e65e3b7cf";
    meta.description = "Insert, update application data, and modify configuration";
  };
  volkovlabs-grapi-datasource = grafanaPlugin {
    pname = "volkovlabs-grapi-datasource";
    version = "2.2.0";
    zipHash = "0f0eaa2e71a91bf5cad229576e12968287d3b0c8bbdc3629883d0e3291cfb7c6";
    meta.description = "Grafana HTTP API Data Source for Grafana";
  };
  volkovlabs-image-panel = grafanaPlugin {
    pname = "volkovlabs-image-panel";
    version = "4.1.0";
    zipHash = "21bd40c3fad3fc73c8720694ef96f08c6e802be1d2c6468795b9b5272811040a";
    meta.description = "Display Base64 encoded files in PNG, JPG, GIF, MP4, WEBM, MP3, OGG, PDF formats";
  };
  volkovlabs-rss-datasource = grafanaPlugin {
    pname = "volkovlabs-rss-datasource";
    version = "3.0.1";
    zipHash = "442b38640a2423f53923df802c46fff977942f874143134747a67ba39c36883b";
    meta.description = "Visualize RSS/Atom feeds";
  };
  volkovlabs-variable-panel = grafanaPlugin {
    pname = "volkovlabs-variable-panel";
    version = "2.2.0";
    zipHash = "fb7e9a63ab941e648f6b14a435f6b161111237bd6cd93deb8fa1efe6338e17cd";
    meta.description = "Update single, dependent and multi-variables as a Table and Tree View";
  };
  vonage-status-panel = grafanaPlugin {
    pname = "vonage-status-panel";
    version = "1.0.11";
    zipHash = "4e781f72b1a7794e826e7bd83be43c86e3f8b8e1def092710af140a8f2ef6e48";
    meta.description = "Status Panel for Grafana";
  };
  voxter-app = grafanaPlugin {
    pname = "voxter-app";
    version = "0.0.2";
    zipHash = "90c94ad3d65479a588d2bd62804745dfbd16371c8428f5c877fea4795b3939d0";
    meta.description = "Voxter for Grafana allows for the collection and graphing of Voxter data over time.";
  };
  williamvenner-timepickerbuttons-panel = grafanaPlugin {
    pname = "williamvenner-timepickerbuttons-panel";
    version = "4.1.1";
    zipHash = "8903538743ecc442bcca8035c24e99ea59d52de814da7d66129496bb85c41c86";
    meta.description = "Datasource-configured buttons panel plugin which set the time range of your Grafana dashboard";
  };
  woutervh-mapbox-panel = grafanaPlugin {
    pname = "woutervh-mapbox-panel";
    version = "1.0.0";
    zipHash = "c573684377d7707377b62e827321c1c09a269b8704ca42806161798431f9f26f";
    meta.description = "Grafana panel that displays spatial data on mapbox-gl.";
  };
  xginn8-pagerduty-datasource = grafanaPlugin {
    pname = "xginn8-pagerduty-datasource";
    version = "0.2.2";
    zipHash = "e2fdca8fd2a19b1f011beb7fc2e7d7f570978d417bc924ac89bbf8448da5c01b";
    meta.description = "Pagerduty datasource";
  };
  xychart = grafanaPlugin {
    pname = "xychart";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "";
  };
  ydbtech-ydb-datasource = grafanaPlugin {
    pname = "ydbtech-ydb-datasource";
    version = "0.4.3";
    zipHash = "0b8b49bc6e4e077453aeb91c7f784d7ab31f20c47f98ea6c50c7f8c60b65f723";
    meta.description = "YDB datasource plugin for Grafana";
  };
  yesoreyeram-boomtable-panel = grafanaPlugin {
    pname = "yesoreyeram-boomtable-panel";
    version = "1.4.1";
    zipHash = "1de1077e9c4a4cbe2039f300e97ca99b4ab0ef67e0fe78808063a7613b409fb5";
    meta.description = "Boom table panel for Graphite, InfluxDB, Prometheus";
  };
  yesoreyeram-boomtheme-panel = grafanaPlugin {
    pname = "yesoreyeram-boomtheme-panel";
    version = "0.2.1";
    zipHash = "d36a2da23d2d7e29a0d8cc17caaff6d475a34888ed0474049194682552e161ff";
    meta.description = "Themes for Grafana";
  };
  yesoreyeram-infinity-datasource = grafanaPlugin {
    pname = "yesoreyeram-infinity-datasource";
    version = "2.3.1";
    zipHash = {
      x86_64-linux = "23ee8f945103acd231efec6b41c79830dd1d86af5a635253d28caae996fa6146";
      aarch64-linux = "81a221722cd8812f9ac210d0bb783e78132c90084c8e9db53c2f2042c953a0fa";
      x86_64-darwin = "b5b95596cdfd6f5790914335f55886ecce30744d6c5308e638cb7d802f6b8617";
      aarch64-darwin = "06faddd133f5e39ee5f1ce345730511cce72d06f74053ae1ca06366c817c0d72";
    };
    meta.description = "JSON API, CSV, TSV, XML, GraphQL, HTML, Google Sheets and HTTP/REST API datasource for Grafana. Do infinite things with Grafana. Transform data with UQL/GROQ. Visualize data from many apis including Amazon AWS, Microsoft Azure, Google Cloud / GCP and RSS/ATOM feeds directly. Also support visualizing logs and traces.";
  };
  zestairlove-compacthostmap-panel = grafanaPlugin {
    pname = "zestairlove-compacthostmap-panel";
    version = "0.9.0";
    zipHash = "90d5667a5cfeb2045195ff414eb9de79ccb0feb8b97df8453b6af0df6703b8e9";
    meta.description = "Grafana Compact Hostmap Panel Plugin";
  };
  zipkin = grafanaPlugin {
    pname = "zipkin";
    version = "5.0.0";
    zipHash = "875e492c9ba2ce8cb103a8402ba79e5052453137f96aae751020607a2f65c05d";
    meta.description = "Placeholder for the distributed tracing system.";
  };
  zuburqan-parity-report-panel = grafanaPlugin {
    pname = "zuburqan-parity-report-panel";
    version = "1.2.2";
    zipHash = "1b78598e6119736039d0030bce2a738908426525fa280e6056af81f467edc1d8";
    meta.description = "Parity report plugin to compare metrics";
  };
}
