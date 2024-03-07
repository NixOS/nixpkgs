{ lib
, buildPythonPackage
, pythonOlder
, aiobotocore
, botocore
, typing-extensions
, fetchPypi
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildTypesAiobotocorePackage = serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      format = "setuptools";

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        inherit pname version hash;
      };

      propagatedBuildInputs = [
        aiobotocore
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [
        typing-extensions
      ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [
        "types_aiobotocore_${toUnderscore serviceName}"
      ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer = buildTypesAiobotocorePackage "accessanalyzer" "2.8.0" "sha256-7TmekyZVc2l2er1TIJURP7Qy0n7xRYnXt44FJr5XBWA=";

  types-aiobotocore-account = buildTypesAiobotocorePackage "account" "2.8.0" "sha256-rVwj3gN9+U5m6xXwytQpE8mSVPTlezzeNIwNH2vgR4Y=";

  types-aiobotocore-acm = buildTypesAiobotocorePackage "acm" "2.8.0" "sha256-VzV8viXJpHfI1aD1UtCX+GSSZKhRSTzMX5dnkGhm+9Y=";

  types-aiobotocore-acm-pca = buildTypesAiobotocorePackage "acm-pca" "2.8.0" "sha256-ib044RjF+1projrSoyiMdj9LkbT1BJrfObxs1ukSNHo=";

  types-aiobotocore-alexaforbusiness = buildTypesAiobotocorePackage "alexaforbusiness" "2.9.0" "sha256-lNp/rvyWKvD9jY9J9vU98CFyB/ysiS8JslXrjK2BtgE=";

  types-aiobotocore-amp = buildTypesAiobotocorePackage "amp" "2.9.0" "sha256-OiejoMmWNnF3dBKPWInCurB2xe0hnKG/FAR8NVuIeiU=";

  types-aiobotocore-amplify = buildTypesAiobotocorePackage "amplify" "2.9.0" "sha256-LUW+yAw4K8kOxSqF3tJuqXqHc83+3thnCbdWcz/PnO0=";

  types-aiobotocore-amplifybackend = buildTypesAiobotocorePackage "amplifybackend" "2.9.0" "sha256-TTmpkylWnRxNs+1s75qTdQ+GgWnyfyUZhfE1e1eSYXE=";

  types-aiobotocore-amplifyuibuilder = buildTypesAiobotocorePackage "amplifyuibuilder" "2.9.0" "sha256-ovLWirPFaMwFjk6e7zZbSoDxiXp0/ll6HnT9pxEJCaY=";

  types-aiobotocore-apigateway = buildTypesAiobotocorePackage "apigateway" "2.9.0" "sha256-mexH2IJbHyMzKRL1jVUuqiUdHBOOHRhCDR29GVIOgmc=";

  types-aiobotocore-apigatewaymanagementapi = buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.9.0" "sha256-ISlXwESp+llqSMTv2T7CwtTAuIXfiRTGwQnIejOb7aU=";

  types-aiobotocore-apigatewayv2 = buildTypesAiobotocorePackage "apigatewayv2" "2.9.0" "sha256-h2C2CZVVH72OML31/f0Yl8Ril2uGEvFKwHnumP9FoVo=";

  types-aiobotocore-appconfig = buildTypesAiobotocorePackage "appconfig" "2.9.0" "sha256-SO7ZAepv4lNrfZ6u3krEsN62LxLsK3p/hD3Bi68pYog=";

  types-aiobotocore-appconfigdata = buildTypesAiobotocorePackage "appconfigdata" "2.9.0" "sha256-qApIy0bwsg3T5LY1CzqpKfg8F+5MU/1Ygt7qN+TYI4c=";

  types-aiobotocore-appfabric = buildTypesAiobotocorePackage "appfabric" "2.9.0" "sha256-wolhhyFXsLIp8phvKat8baoUd6WJTv23J6eoThQ4QJ0=";

  types-aiobotocore-appflow = buildTypesAiobotocorePackage "appflow" "2.9.0" "sha256-QO6o0BPDJ/qOul8XkN+BW36aQomv//+1kG6sa8gljuE=";

  types-aiobotocore-appintegrations = buildTypesAiobotocorePackage "appintegrations" "2.9.0" "sha256-/zUXglyQUewxMcRgoCLPHHrc8fIjm68C547o4DOn/j8=";

  types-aiobotocore-application-autoscaling = buildTypesAiobotocorePackage "application-autoscaling" "2.9.0" "sha256-G2pTcy4uLL7ypl3PcKvI1g5jD7Ytxu37jxWs+i1opHM=";

  types-aiobotocore-application-insights = buildTypesAiobotocorePackage "application-insights" "2.9.0" "sha256-YwwGYTwwFOsyfsyY8L5dKhFl+uGTT+oKYEXSgo1UPXE=";

  types-aiobotocore-applicationcostprofiler = buildTypesAiobotocorePackage "applicationcostprofiler" "2.9.0" "sha256-ghooPwffm8YMs50MpYT82WJz7vHsMi/HZy0drnSXJUA=";

  types-aiobotocore-appmesh = buildTypesAiobotocorePackage "appmesh" "2.9.0" "sha256-tydjCV77K/EAyddwmiMDXsEC469GbgNcZRLMmy61Zh4=";

  types-aiobotocore-apprunner = buildTypesAiobotocorePackage "apprunner" "2.9.0" "sha256-nt2evZ5TqcCrwjGPornCrY27nlQX09RpYEHoYRb9XUA=";

  types-aiobotocore-appstream = buildTypesAiobotocorePackage "appstream" "2.9.0" "sha256-q/LwAh7O9SZOXjGawKwCcZFwRGmztfRjZ0sUkS/QuOc=";

  types-aiobotocore-appsync = buildTypesAiobotocorePackage "appsync" "2.9.0" "sha256-e4AE0rYgr61INMVTIuv3G35ywBnfnGo0+ZkAUbJCxS8=";

  types-aiobotocore-arc-zonal-shift = buildTypesAiobotocorePackage "arc-zonal-shift" "2.9.0" "sha256-PM6yAXmqwLXs7NAC6hnFUVCnkWg3iNz8hCN7soWSxPE=";

  types-aiobotocore-athena = buildTypesAiobotocorePackage "athena" "2.9.0" "sha256-uMKc1u/u3ppRCVVPZ05VTlXoEfxCY9tyLqYpxnl+CWc=";

  types-aiobotocore-auditmanager = buildTypesAiobotocorePackage "auditmanager" "2.9.0" "sha256-gPzB/GSkjq44Q2SjjDWJyidFNzg4veag0PvQ7nFl+pY=";

  types-aiobotocore-autoscaling = buildTypesAiobotocorePackage "autoscaling" "2.9.0" "sha256-AaCvm94dtOdLlOA1X8k5r2K1sbpTerX6cJEjdGs3L6Y=";

  types-aiobotocore-autoscaling-plans = buildTypesAiobotocorePackage "autoscaling-plans" "2.9.0" "sha256-p43Kie/Ax1BNmIN2Sny05NlxHWuasbXLlRbTNpvI8eM=";

  types-aiobotocore-backup = buildTypesAiobotocorePackage "backup" "2.9.0" "sha256-CO6ETR9Q1Lkj0o4d24iVfhvLyN3FBTpWQYrWStvPVP4=";

  types-aiobotocore-backup-gateway = buildTypesAiobotocorePackage "backup-gateway" "2.9.0" "sha256-TGtFwgq00PrrVKxJYhiIWMzUGpsvFMYVjS5xBxEorWI=";

  types-aiobotocore-backupstorage = buildTypesAiobotocorePackage "backupstorage" "2.9.0" "sha256-gNXODf0OIkG0Dw4JOZU0XuRKmf8CIc+GTcgZ8PUnRcY=";

  types-aiobotocore-batch = buildTypesAiobotocorePackage "batch" "2.9.0" "sha256-x/sNVy1MmdBelRwb+ytT13K9FcgUdnoahgckniLN9Gs=";

  types-aiobotocore-billingconductor = buildTypesAiobotocorePackage "billingconductor" "2.9.0" "sha256-wsbM8GYdwDf1ILZZBM/lBQo/qTduA49pljwfVlNTPo8=";

  types-aiobotocore-braket = buildTypesAiobotocorePackage "braket" "2.9.0" "sha256-Wi8Y5Ue4xiVm+3Ol9e3nDOS8QL1LjcUQsySIWc1R16M=";

  types-aiobotocore-budgets = buildTypesAiobotocorePackage "budgets" "2.9.0" "sha256-PU74F6DnMXB435pCmee7IAPS7YSR0pFBjDqgPMfORT4=";

  types-aiobotocore-ce = buildTypesAiobotocorePackage "ce" "2.9.0" "sha256-0drcozC0lKqYuHK3vSF2QG/7lywN6yKxbwJxqMIrIDM=";

  types-aiobotocore-chime = buildTypesAiobotocorePackage "chime" "2.9.0" "sha256-IGF7YcjgZy99X4KZA0CYJDMcJP8S9GZHwInW8eqLsCc=";

  types-aiobotocore-chime-sdk-identity = buildTypesAiobotocorePackage "chime-sdk-identity" "2.9.0" "sha256-MwfvczW4j4IjZBPUTyA0WcT8sqSTYhrnEzkKrVXuIY4=";

  types-aiobotocore-chime-sdk-media-pipelines = buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.9.0" "sha256-PsEsAjsehN5w5pV+ZHajY+r+9+9SCSutEKA5UGvePeY=";

  types-aiobotocore-chime-sdk-meetings = buildTypesAiobotocorePackage "chime-sdk-meetings" "2.9.0" "sha256-XDyk+ljdPfm8poC4A65rz30zviN5XqBo4Ud4K/SN8bY=";

  types-aiobotocore-chime-sdk-messaging = buildTypesAiobotocorePackage "chime-sdk-messaging" "2.9.0" "sha256-7MQKlLPYRS64OH0CA8SYXJhE52gT9v4BkCzoypV2I/k=";

  types-aiobotocore-chime-sdk-voice = buildTypesAiobotocorePackage "chime-sdk-voice" "2.9.0" "sha256-Do/nRj4qmUABDW20dkTU+KK8O/C7yhRIEjV6bCbfjGs=";

  types-aiobotocore-cleanrooms = buildTypesAiobotocorePackage "cleanrooms" "2.9.0" "sha256-wfLyaQu2gfOe2+GT+Umwo6VBo70wjmhpKF3qGquaoZo=";

  types-aiobotocore-cloud9 = buildTypesAiobotocorePackage "cloud9" "2.9.0" "sha256-tt+houhkHEPlRxagLzVKn/SVP4Uj9Sv1UsPyidSNLVM=";

  types-aiobotocore-cloudcontrol = buildTypesAiobotocorePackage "cloudcontrol" "2.9.0" "sha256-QIsTkVZnkkzFvZAOFYvF/erH2ov/F01lRDWFglY3Tmw=";

  types-aiobotocore-clouddirectory = buildTypesAiobotocorePackage "clouddirectory" "2.9.0" "sha256-gNcIZFG9zk+VZPcT9yxYYVjKPcqO2RJNFjpPNfbnK7E=";

  types-aiobotocore-cloudformation = buildTypesAiobotocorePackage "cloudformation" "2.9.0" "sha256-zdEa2iNNy8gFFkK15ifS3TO7lbauVxDfLyzM8a27NyI=";

  types-aiobotocore-cloudfront = buildTypesAiobotocorePackage "cloudfront" "2.9.0" "sha256-S7FeyJ8x4C+/PeeR4kXa1YhyDm5DX2XmoTk4AZMjxKo=";

  types-aiobotocore-cloudhsm = buildTypesAiobotocorePackage "cloudhsm" "2.9.0" "sha256-epgeZ3U179/91Qy4GZ/fLQGFyIQkn222wHoSOUE2+w0=";

  types-aiobotocore-cloudhsmv2 = buildTypesAiobotocorePackage "cloudhsmv2" "2.9.0" "sha256-wDbY2WENp0RgQ7TwJztZApfUyRQG1hXeMSLInRh5Ot8=";

  types-aiobotocore-cloudsearch = buildTypesAiobotocorePackage "cloudsearch" "2.9.0" "sha256-c+W60cxtipCAW8sM4QyTRLmZo8xZBm3FCyzqGNwK/Zc=";

  types-aiobotocore-cloudsearchdomain = buildTypesAiobotocorePackage "cloudsearchdomain" "2.9.0" "sha256-WR5b8vBbUxFmsH8tNnho4jqY6jrPsHYXljflL6y6JHc=";

  types-aiobotocore-cloudtrail = buildTypesAiobotocorePackage "cloudtrail" "2.9.0" "sha256-roSPY8CJBwX/wCMRd7qLLjLSkk0ys2HT3n4ZFpEE+VU=";

  types-aiobotocore-cloudtrail-data = buildTypesAiobotocorePackage "cloudtrail-data" "2.9.0" "sha256-t+1vtSNNEBhMieXbkdoUBEXCTPd5me1fDOdHaI5tNfE=";

  types-aiobotocore-cloudwatch = buildTypesAiobotocorePackage "cloudwatch" "2.9.0" "sha256-LxuZoxlhUwRorUAGDxTfAIhgTzJm4jMTUS13zMnfaZY=";

  types-aiobotocore-codeartifact = buildTypesAiobotocorePackage "codeartifact" "2.9.0" "sha256-eEI1k5dZpy0TuuoYDRFGp9OPWzFXg0mtx0HwB2H4OsM=";

  types-aiobotocore-codebuild = buildTypesAiobotocorePackage "codebuild" "2.9.0" "sha256-AyFoSrmu8DA8UFb7o8Bd4eoUSoTXvdHoADkKH5DBVxM=";

  types-aiobotocore-codecatalyst = buildTypesAiobotocorePackage "codecatalyst" "2.9.0" "sha256-IT7jtWd5QrAaeRG+kgu21KVcWtKiAyEB04E2BsDTPzQ=";

  types-aiobotocore-codecommit = buildTypesAiobotocorePackage "codecommit" "2.9.0" "sha256-8wsxzSNeMKOr1N0UJo9sn0Jcp+WCvLOufA67aL49FjQ=";

  types-aiobotocore-codedeploy = buildTypesAiobotocorePackage "codedeploy" "2.9.0" "sha256-7NsJWQv4gw2zBYQTxm9p0hEis70WnTNgT5isd55mnt8=";

  types-aiobotocore-codeguru-reviewer = buildTypesAiobotocorePackage "codeguru-reviewer" "2.9.0" "sha256-zzl4ICc11BaNsYjJZG3lK8ehQlVFi8fWDxunVK4y6wA=";

  types-aiobotocore-codeguru-security = buildTypesAiobotocorePackage "codeguru-security" "2.9.0" "sha256-gEYXn3oLTVMgskv43TJLnj4lC+RmiEQMO7ngz8a/dws=";

  types-aiobotocore-codeguruprofiler = buildTypesAiobotocorePackage "codeguruprofiler" "2.9.0" "sha256-mrEhrQcd/SmrBFs1AVv6ddPqWairhYHMdIxBeL/JiNI=";

  types-aiobotocore-codepipeline = buildTypesAiobotocorePackage "codepipeline" "2.9.0" "sha256-wLaqSsUgOosJ+0zUST9DVEPtW12QbPLQ4zHz6GAuJrQ=";

  types-aiobotocore-codestar = buildTypesAiobotocorePackage "codestar" "2.9.0" "sha256-TB+XKOtfpjEtyHpmlAggN8LlrPVU2J7J8dGOtNN0jGo=";

  types-aiobotocore-codestar-connections = buildTypesAiobotocorePackage "codestar-connections" "2.9.0" "sha256-fI+dnGtR3w87Pkqgk8my60jiB03gsEYFHtGGoU1/uYY=";

  types-aiobotocore-codestar-notifications = buildTypesAiobotocorePackage "codestar-notifications" "2.9.0" "sha256-xwE39rQ720hvrqAPosru14lVIJ84GI8CvN80NQVQA8o=";

  types-aiobotocore-cognito-identity = buildTypesAiobotocorePackage "cognito-identity" "2.9.0" "sha256-XuqXsgCd+loZYn6TMZUALvNJJv0WUdLsQuO6c0KW/bs=";

  types-aiobotocore-cognito-idp = buildTypesAiobotocorePackage "cognito-idp" "2.9.0" "sha256-/TKEYsj+xGxfw2FmQHdsXa5T96OIhiSukUjUStuW5eM=";

  types-aiobotocore-cognito-sync = buildTypesAiobotocorePackage "cognito-sync" "2.9.0" "sha256-nceU9SKeGSl5JuiuKTpBAfijsReTn7dRyboy8f74ecw=";

  types-aiobotocore-comprehend = buildTypesAiobotocorePackage "comprehend" "2.9.0" "sha256-meEKFbIuWqGrg9ZL7XJW8POWwgjiHxbIgXJPjIrkeU0=";

  types-aiobotocore-comprehendmedical = buildTypesAiobotocorePackage "comprehendmedical" "2.9.0" "sha256-5NmX7q2dBWUFR+MZ3L37nSKUofJnjQ4CUNzJ0buxwYo=";

  types-aiobotocore-compute-optimizer = buildTypesAiobotocorePackage "compute-optimizer" "2.9.0" "sha256-66KGrkc1LMXyJqCl4hLhEqYd5f4x5n+A1aiNmEeY0Ic=";

  types-aiobotocore-config = buildTypesAiobotocorePackage "config" "2.9.0" "sha256-Jal8H6TgvHWBMkTtGM3Gcth77cJfkiew6uIGmCIoZqA=";

  types-aiobotocore-connect = buildTypesAiobotocorePackage "connect" "2.9.0" "sha256-iQgYO2rjkaMI0xRslJRVAQ2HPcvj8tYM+/g2xQySY7I=";

  types-aiobotocore-connect-contact-lens = buildTypesAiobotocorePackage "connect-contact-lens" "2.9.0" "sha256-4dVbw+1XCJnxkJLNyxTpibr1u2KPnuM9aSzk1/UuBxc=";

  types-aiobotocore-connectcampaigns = buildTypesAiobotocorePackage "connectcampaigns" "2.9.0" "sha256-SpQk9aatNLlOxwNTghJYoOqlmv8NQBxVyMPsx0kDhFY=";

  types-aiobotocore-connectcases = buildTypesAiobotocorePackage "connectcases" "2.9.0" "sha256-CaU1bmYjX/4+rgDqkkoOihLpzTxOoiquriDEGxruxoE=";

  types-aiobotocore-connectparticipant = buildTypesAiobotocorePackage "connectparticipant" "2.9.0" "sha256-AsHLSsmfYb4WC0068U1VLvsA/h/V+IPpSsshPDj0yD8=";

  types-aiobotocore-controltower = buildTypesAiobotocorePackage "controltower" "2.9.0" "sha256-oUPutZNbGyiIOow0sjhdyCmrcymVtVUfmV22CTa3jk8=";

  types-aiobotocore-cur = buildTypesAiobotocorePackage "cur" "2.9.0" "sha256-PGAEGW5hQNiSvUmaO1c9ruV4p/geuSXuKUBBqfCn9h0=";

  types-aiobotocore-customer-profiles = buildTypesAiobotocorePackage "customer-profiles" "2.9.0" "sha256-6TkyPbfYX4l+rg5fYAxL7YRk+q7btyAnUmZsddEEMKI=";

  types-aiobotocore-databrew = buildTypesAiobotocorePackage "databrew" "2.9.0" "sha256-dMNEL+UBheYxenwHbopFigH8y/WaVN9W37Qsm8hj2LI=";

  types-aiobotocore-dataexchange = buildTypesAiobotocorePackage "dataexchange" "2.9.0" "sha256-+fQQWK+j80sUcm5+cm1x4dmexMyzYLj+/wwSs7doPGM=";

  types-aiobotocore-datapipeline = buildTypesAiobotocorePackage "datapipeline" "2.9.0" "sha256-Xbqot0kb2uRuzVw4mBDwXgUyxJmXNb7s00DfE12gnK0=";

  types-aiobotocore-datasync = buildTypesAiobotocorePackage "datasync" "2.9.0" "sha256-h1JZgAPPSynyE2R3ZFr94gql6NNBtAAZzT/vLu36974=";

  types-aiobotocore-dax = buildTypesAiobotocorePackage "dax" "2.9.0" "sha256-m5XoWZXVHsz/tnVJTJikanRovgdjn9YA6fqCih+J2FY=";

  types-aiobotocore-detective = buildTypesAiobotocorePackage "detective" "2.9.0" "sha256-u/RH0O+wJ+zSxENwkZ34qsvRyCLxYVcaXUwJSrRoWa8=";

  types-aiobotocore-devicefarm = buildTypesAiobotocorePackage "devicefarm" "2.9.0" "sha256-yZiJ42Tux6ElMCAonjsrlHIvIRMF8TndCgj8m2dqPgI=";

  types-aiobotocore-devops-guru = buildTypesAiobotocorePackage "devops-guru" "2.9.0" "sha256-YG4OKgu+APHPvnPJxWhb7F8P7mAzhg//0A5I34mL2WA=";

  types-aiobotocore-directconnect = buildTypesAiobotocorePackage "directconnect" "2.9.0" "sha256-hSaANopHROSG3tI1Oo76m+MMCN/BwlhdkIil5ej47b8=";

  types-aiobotocore-discovery = buildTypesAiobotocorePackage "discovery" "2.9.0" "sha256-4bT4zpTZ7dS2dnfIRCQO9kx4LxMqct+sGX0RwFYm3q4=";

  types-aiobotocore-dlm = buildTypesAiobotocorePackage "dlm" "2.9.0" "sha256-3CJqMAU6V6BnwImfNmDdTvvcbbhLTC6txb1rYsroiW8=";

  types-aiobotocore-dms = buildTypesAiobotocorePackage "dms" "2.9.0" "sha256-4LLK2nScAVX2XtHIj0ajO7MZhz7OV+xarlCr5Y2bjXU=";

  types-aiobotocore-docdb = buildTypesAiobotocorePackage "docdb" "2.9.0" "sha256-jBEpqZFqzAY8KOsG7RhBzg0HVEtfwkmc6KfrpOmHQJs=";

  types-aiobotocore-docdb-elastic = buildTypesAiobotocorePackage "docdb-elastic" "2.9.0" "sha256-WnGjpT3cf+KucO+p2uoerdyMvnW2vPEpSiPtSrPwqWg=";

  types-aiobotocore-drs = buildTypesAiobotocorePackage "drs" "2.9.0" "sha256-ZS7Ux9Oa24Yvwl2R4ahsJMJKK2+ZkB0Gl5vymbF1KuI=";

  types-aiobotocore-ds = buildTypesAiobotocorePackage "ds" "2.9.0" "sha256-LyM6Mu6f0Ophm5D7li+RORL3pPKMF31FGAjhKifFgK0=";

  types-aiobotocore-dynamodb = buildTypesAiobotocorePackage "dynamodb" "2.9.0" "sha256-11VNAEeYMpdv1QeHzfZF8s6eELfHAf+6kwZ98lZVtss=";

  types-aiobotocore-dynamodbstreams = buildTypesAiobotocorePackage "dynamodbstreams" "2.9.0" "sha256-V3KpPB/ZFn4ekwqCzAYlCd7Sm2eOmDSErKrW5Inq6bw=";

  types-aiobotocore-ebs = buildTypesAiobotocorePackage "ebs" "2.9.0" "sha256-P/xyl8314GuciTxaWNDqBxvTNIgBrmgwEGnf3ndFhhY=";

  types-aiobotocore-ec2 = buildTypesAiobotocorePackage "ec2" "2.9.0" "sha256-hZl7h0GbT4uW+xFrj+DrM78oBxVVkklUtdvPhiwD4IU=";

  types-aiobotocore-ec2-instance-connect = buildTypesAiobotocorePackage "ec2-instance-connect" "2.9.0" "sha256-bsREnDH2iIpXXJTaAeFpdqTFUW8NXFYrnilCldvsZeU=";

  types-aiobotocore-ecr = buildTypesAiobotocorePackage "ecr" "2.9.0" "sha256-aRogeu240sXzGG3SqtgPlMro/VgfZ+ab8mN8llrd0BM=";

  types-aiobotocore-ecr-public = buildTypesAiobotocorePackage "ecr-public" "2.9.0" "sha256-me4OICl7bpjD8So1+Fi3WAPStmHN03Iy/UpSKkJ9vjs=";

  types-aiobotocore-ecs = buildTypesAiobotocorePackage "ecs" "2.9.0" "sha256-j7Uii76S/VHqEaCwY0oazbiZPjhHGzgNpDftur9sAdQ=";

  types-aiobotocore-efs = buildTypesAiobotocorePackage "efs" "2.9.0" "sha256-RglLUdWAGoXqlhDeJ5YDuKRGBuN3L4/bX1ooiextOGM=";

  types-aiobotocore-eks = buildTypesAiobotocorePackage "eks" "2.9.0" "sha256-VrEKbEiAKCuBQyKBRCY/XYD/4akxVF/x2aHpwTsp/gk=";

  types-aiobotocore-elastic-inference = buildTypesAiobotocorePackage "elastic-inference" "2.9.0" "sha256-gkzqiodMq81O8d8WTwsSHcXVRdcsW+fcH0UDkWVm6NU=";

  types-aiobotocore-elasticache = buildTypesAiobotocorePackage "elasticache" "2.9.0" "sha256-v27Lu2Oe+kTjXR82WcJ+ocSSiYcepLt8J4E0e3gTSQQ=";

  types-aiobotocore-elasticbeanstalk = buildTypesAiobotocorePackage "elasticbeanstalk" "2.9.0" "sha256-2NBo1cUIyXTWkrMQaGt5oQfLovrhdZAtNIrA3KmyBNI=";

  types-aiobotocore-elastictranscoder = buildTypesAiobotocorePackage "elastictranscoder" "2.9.0" "sha256-eDz+7wmr8LIkO1LtxvLoHrfVllycbcQRHA8HLfK/Aig=";

  types-aiobotocore-elb = buildTypesAiobotocorePackage "elb" "2.9.0" "sha256-nj8CLLrTrGS7GOC90xGxDqVLhxK3mvmWthUucwcf7VU=";

  types-aiobotocore-elbv2 = buildTypesAiobotocorePackage "elbv2" "2.9.0" "sha256-ILngqOQ5oVsgGj6LRYlx/LrfKf85aakeRP+z96z2FnE=";

  types-aiobotocore-emr = buildTypesAiobotocorePackage "emr" "2.9.0" "sha256-pazXV8RBOciYO4DT8N5Ztl+prpSMqY4PtHTw6fpDVrk=";

  types-aiobotocore-emr-containers = buildTypesAiobotocorePackage "emr-containers" "2.9.0" "sha256-rgnCpxI5VF5PIks1ucO18odXbdJLY6avolYSSYM/ucs=";

  types-aiobotocore-emr-serverless = buildTypesAiobotocorePackage "emr-serverless" "2.9.0" "sha256-ONqc3bBUEpKy6+GlOtZf8Sqf+NaQXbRvVdu/NtA8g/U=";

  types-aiobotocore-entityresolution = buildTypesAiobotocorePackage "entityresolution" "2.9.0" "sha256-du/tPdrQIaCvndaZMU5Bz3biL8GxT1PQGR/rRbSioTk=";

  types-aiobotocore-es = buildTypesAiobotocorePackage "es" "2.9.0" "sha256-2zELfFO2ukQ3CIBA72Ktd67H+VtLSpXEJ8bAARb+Nas=";

  types-aiobotocore-events = buildTypesAiobotocorePackage "events" "2.9.0" "sha256-wluojbZEFpeJcLDmNqcBzVyAbXi2oe65MNDsSxizwbI=";

  types-aiobotocore-evidently = buildTypesAiobotocorePackage "evidently" "2.9.0" "sha256-y2ZTQ/N2YXFBylexjWfEoeUxlhSNEykUNqzhFvjDprE=";

  types-aiobotocore-finspace = buildTypesAiobotocorePackage "finspace" "2.9.0" "sha256-JJ1KeDC+sUkixipaE/eEPZLxu4e1IP+yaGrHr/eh2kQ=";

  types-aiobotocore-finspace-data = buildTypesAiobotocorePackage "finspace-data" "2.9.0" "sha256-9KCNrLD1vKELitGKWmEKLDsniQTZ+CSLPqJIXU/Ndkg=";

  types-aiobotocore-firehose = buildTypesAiobotocorePackage "firehose" "2.9.0" "sha256-NY8XyhCzze30cdDT76faqaFRuhwD43DjTc59h6LwN4M=";

  types-aiobotocore-fis = buildTypesAiobotocorePackage "fis" "2.9.0" "sha256-oVOz3nStBFvOrlJEy4v9kKjkBbM/cubP/01KUnGGKIk=";

  types-aiobotocore-fms = buildTypesAiobotocorePackage "fms" "2.9.0" "sha256-YdsSwRZitM81L1VrQ8MWLAo5OzMVYHhHlLn0cr+rX1M=";

  types-aiobotocore-forecast = buildTypesAiobotocorePackage "forecast" "2.9.0" "sha256-PSlAjO+J5FmGeerxaXGLblTsxCV/N3pgrp9YE+wbuLE=";

  types-aiobotocore-forecastquery = buildTypesAiobotocorePackage "forecastquery" "2.9.0" "sha256-6wtsWxphhZX6EXACPnQoOEk5jhYU2F0O6uQWd4YcmMU=";

  types-aiobotocore-frauddetector = buildTypesAiobotocorePackage "frauddetector" "2.9.0" "sha256-baWI2JgVwKt009qHelIWdlinITQx3PMmDL2GR4JYs7s=";

  types-aiobotocore-fsx = buildTypesAiobotocorePackage "fsx" "2.9.0" "sha256-9U5ZyZVlovbMhAEpdxatXMdG+4UiNDzCgOPcolFVz+o=";

  types-aiobotocore-gamelift = buildTypesAiobotocorePackage "gamelift" "2.9.0" "sha256-zMDERQRfFSDc1ULOKnxh0pCJFto19rc/S4MpPWp/AIQ=";

  types-aiobotocore-gamesparks = buildTypesAiobotocorePackage "gamesparks" "2.6.0" "sha256-9iV7bpGMnzz9TH+g1YpPjbKBSKY3rcL/OJvMOzwLC1M=";

  types-aiobotocore-glacier = buildTypesAiobotocorePackage "glacier" "2.9.0" "sha256-gwWW/i5HfpPyNOTW+B2oXm8RiTMBWrlzfdrS15ysR3g=";

  types-aiobotocore-globalaccelerator = buildTypesAiobotocorePackage "globalaccelerator" "2.9.0" "sha256-5w83+uCKnfu2JzAhyhNgyw2fJGHOzLOgS9ihuZ5mjXc=";

  types-aiobotocore-glue = buildTypesAiobotocorePackage "glue" "2.9.0" "sha256-UWnIh8+CcSpWPvAHnWJrLORqFKkMSHvxV2QIO2kLHxg=";

  types-aiobotocore-grafana = buildTypesAiobotocorePackage "grafana" "2.9.0" "sha256-LWncyuBU2zDhoF5ob81cg+NWlOI8QiZkbpUSRRolh9E=";

  types-aiobotocore-greengrass = buildTypesAiobotocorePackage "greengrass" "2.9.0" "sha256-pjBy3YHHblL5JWCycMfZxpFQdPyAGla9TVmLLceRsrY=";

  types-aiobotocore-greengrassv2 = buildTypesAiobotocorePackage "greengrassv2" "2.9.0" "sha256-IAlQveKtmaP02odHz8WQdNdWLFjz0gPr66HMSyOhnMs=";

  types-aiobotocore-groundstation = buildTypesAiobotocorePackage "groundstation" "2.9.0" "sha256-qcjfgSR8lbOus3bcx/zlPSuGJ53B/Kuo1GCyU4VsYMo=";

  types-aiobotocore-guardduty = buildTypesAiobotocorePackage "guardduty" "2.9.0" "sha256-ecsB0KFITMENFwZX2EKpmToi1iYTeeRtrooAX3zXfpc=";

  types-aiobotocore-health = buildTypesAiobotocorePackage "health" "2.9.0" "sha256-nz7sUPMH8gVy5Oz+eatRd8iLfHKxcDHFRIqh80EuZWE=";

  types-aiobotocore-healthlake = buildTypesAiobotocorePackage "healthlake" "2.9.0" "sha256-S8Ds3s45HY0b007saVNSd0bfmvP3lbSNXEWUSBCsD/8=";

  types-aiobotocore-honeycode = buildTypesAiobotocorePackage "honeycode" "2.9.0" "sha256-+D9MESYNaP60NSl/5OKLVyHQQqikU4AHR6CV+wb1J58=";

  types-aiobotocore-iam = buildTypesAiobotocorePackage "iam" "2.9.0" "sha256-b1VvcL7w/QC4svZCuDnP+OC+wOHWvrArUFLCw94S7Vw=";

  types-aiobotocore-identitystore = buildTypesAiobotocorePackage "identitystore" "2.9.0" "sha256-qsU85n679BxZn3QgC0iSXnX+GANPhdUNQuSn5/WIjq4=";

  types-aiobotocore-imagebuilder = buildTypesAiobotocorePackage "imagebuilder" "2.9.0" "sha256-U3PWbTbhSb48R1QPdzH1kLBI/Y6Iv1MnQz1IeuaQGj8=";

  types-aiobotocore-importexport = buildTypesAiobotocorePackage "importexport" "2.9.0" "sha256-vnnAftGX1FxCdqz9ROaWcuaugIDXPfySRWVJieU33VA=";

  types-aiobotocore-inspector = buildTypesAiobotocorePackage "inspector" "2.9.0" "sha256-4tYe+EtujEhaVYbddCBuVSoGzai0+oiJPxkZ+fxxz9M=";

  types-aiobotocore-inspector2 = buildTypesAiobotocorePackage "inspector2" "2.9.0" "sha256-VXniTrBibInkgj0jMWbb9RD8+Er9JUJ0xfAeWfwKdXE=";

  types-aiobotocore-internetmonitor = buildTypesAiobotocorePackage "internetmonitor" "2.9.0" "sha256-70lW/bzAirzq1ui/TtiFyKGesZMJ3Z8jwGgc3j0GoUk=";

  types-aiobotocore-iot = buildTypesAiobotocorePackage "iot" "2.9.0" "sha256-j8i0uB5Ul4pxxMjyPdR94ssh1lus4MAR1Il31ueJiw0=";

  types-aiobotocore-iot-data = buildTypesAiobotocorePackage "iot-data" "2.9.0" "sha256-9gblz4bopGjfFh3dgw0Jy7KVl8SNO+kE8l+l5mAgUws=";

  types-aiobotocore-iot-jobs-data = buildTypesAiobotocorePackage "iot-jobs-data" "2.9.0" "sha256-wykkgo48vdRg401bVR1TxCFFZXzESjeZM8Tc7wPVI6w=";

  types-aiobotocore-iot-roborunner = buildTypesAiobotocorePackage "iot-roborunner" "2.9.0" "sha256-ufnfEl+MjD/FAJ6ga2/rAvVrAbg+lCqwXxh58VDezxk=";

  types-aiobotocore-iot1click-devices = buildTypesAiobotocorePackage "iot1click-devices" "2.9.0" "sha256-8TF24GJwZT8c0XBV15XOJqP4/pMPdanURcxnbVu8gRg=";

  types-aiobotocore-iot1click-projects = buildTypesAiobotocorePackage "iot1click-projects" "2.9.0" "sha256-IV8WCyvx2BVG5R3JUM2Q8r5n+qlVd/JiLUneW6DcQTw=";

  types-aiobotocore-iotanalytics = buildTypesAiobotocorePackage "iotanalytics" "2.9.0" "sha256-00lziwTYF800ejKy11K26LL1GpFi3e+57OQwQk4KN4s=";

  types-aiobotocore-iotdeviceadvisor = buildTypesAiobotocorePackage "iotdeviceadvisor" "2.9.0" "sha256-/FnVwPFQTDi0XGYf1N5rzUUV9HLqy+xrDIdIlwbhEqY=";

  types-aiobotocore-iotevents = buildTypesAiobotocorePackage "iotevents" "2.9.0" "sha256-Tsj+xTdDp2iP3suK6Y09hLwOOA80xJ/HH76f6rmbsSI=";

  types-aiobotocore-iotevents-data = buildTypesAiobotocorePackage "iotevents-data" "2.9.0" "sha256-DPq/6llPXr+gUikXOqRuakoSL5pOLu21AXFabe2krk0=";

  types-aiobotocore-iotfleethub = buildTypesAiobotocorePackage "iotfleethub" "2.9.0" "sha256-C56Ab8SK7LVCL0rQ0MaykTpfh+7q1GWvNpO1T6QLxYw=";

  types-aiobotocore-iotfleetwise = buildTypesAiobotocorePackage "iotfleetwise" "2.9.0" "sha256-Sdnl//LbfuifTiQXyvDprkaZi9/MG1i51QijsKNyvp0=";

  types-aiobotocore-iotsecuretunneling = buildTypesAiobotocorePackage "iotsecuretunneling" "2.9.0" "sha256-d4/KliyqdzNJRICYyU6aTs1rrzF+W7B7xpywPG5KDik=";

  types-aiobotocore-iotsitewise = buildTypesAiobotocorePackage "iotsitewise" "2.9.0" "sha256-6+nlzU+QZYgNoaE39Md9hT0vYM3DLQoRl5jIEK2HiGQ=";

  types-aiobotocore-iotthingsgraph = buildTypesAiobotocorePackage "iotthingsgraph" "2.9.0" "sha256-Ou+3C8Gir/InKP5sLv08F6M9FOH51/bQSpqoAezjr44=";

  types-aiobotocore-iottwinmaker = buildTypesAiobotocorePackage "iottwinmaker" "2.9.0" "sha256-9fi9KvxlvSjBSDBtpvzKUQ8AA1Bl+awBgA4kckOF5+w=";

  types-aiobotocore-iotwireless = buildTypesAiobotocorePackage "iotwireless" "2.9.0" "sha256-GIPR7G7l1BTFVrURSJsJKwCwjXozrIyHZqdLzWrLj2A=";

  types-aiobotocore-ivs = buildTypesAiobotocorePackage "ivs" "2.9.0" "sha256-XXUYFZqxU9K6UZEpFxQORvqmpC/b3/JFOI3P1IX08kc=";

  types-aiobotocore-ivs-realtime = buildTypesAiobotocorePackage "ivs-realtime" "2.9.0" "sha256-HFRzKZmGZQJO//hoP6Buha2KH1JVbwvQW8N4IG69ZdA=";

  types-aiobotocore-ivschat = buildTypesAiobotocorePackage "ivschat" "2.9.0" "sha256-P+PaFBQs24/KTvcmAU7AtLeKW/sfePbRj++m8lQdgLY=";

  types-aiobotocore-kafka = buildTypesAiobotocorePackage "kafka" "2.9.0" "sha256-TCgBYbKAaohObSeBuJ8jOjHZASNJrS16RTVdSCFLOjc=";

  types-aiobotocore-kafkaconnect = buildTypesAiobotocorePackage "kafkaconnect" "2.9.0" "sha256-w8XWZ2J7LKHe9fmS/bI0tzX/Pp8ezHYZs6bgSeI0CxI=";

  types-aiobotocore-kendra = buildTypesAiobotocorePackage "kendra" "2.9.0" "sha256-4T9pwC8a61FQZgWj57NbH4uJBN3OeDAmOJLd/ZQOf04=";

  types-aiobotocore-kendra-ranking = buildTypesAiobotocorePackage "kendra-ranking" "2.9.0" "sha256-MYirajXde6U4Qy1gMT9WeZ8A778jVNeSV7ms4IWmwRA=";

  types-aiobotocore-keyspaces = buildTypesAiobotocorePackage "keyspaces" "2.9.0" "sha256-VMRYuJ97TdlvfYLbnzIzh/bDrYM5JfMS0eEHltXT1Hc=";

  types-aiobotocore-kinesis = buildTypesAiobotocorePackage "kinesis" "2.9.0" "sha256-EV//x+21dM7Olz876nZlUZVFlabuCothyxFrT7MpcqA=";

  types-aiobotocore-kinesis-video-archived-media = buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.9.0" "sha256-lP+YgnzAB5e1F2OAwFyPHslYiNZswc6tSLZ4F9OpfD4=";

  types-aiobotocore-kinesis-video-media = buildTypesAiobotocorePackage "kinesis-video-media" "2.9.0" "sha256-VvXlHziQ/ehNaZ7r8DRwXCviK1Zwi04805+josYiIjg=";

  types-aiobotocore-kinesis-video-signaling = buildTypesAiobotocorePackage "kinesis-video-signaling" "2.9.0" "sha256-essOlk7mViB1gaphCiybJncXX7USKk3K7Rt1r+ecTBk=";

  types-aiobotocore-kinesis-video-webrtc-storage = buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.9.0" "sha256-KGlU4WaBWQh7nvaqmktkpaSvyJSGtQ2//io9puKB9qA=";

  types-aiobotocore-kinesisanalytics = buildTypesAiobotocorePackage "kinesisanalytics" "2.9.0" "sha256-2SnuovecO3+lQwNfA1+CtifQWkuall8zQbMNvH7fQGo=";

  types-aiobotocore-kinesisanalyticsv2 = buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.9.0" "sha256-O0W2jEiHV1XCmZq+DtrkRZXJSIiUulsX7Tt+oVLjOcY=";

  types-aiobotocore-kinesisvideo = buildTypesAiobotocorePackage "kinesisvideo" "2.9.0" "sha256-tv1mzlK2ccp6Ea9bBNrTHo5E6gCWr1OHR/M7119bM00=";

  types-aiobotocore-kms = buildTypesAiobotocorePackage "kms" "2.9.0" "sha256-I3NUNatXbcd5bJJlwox92ZLHH8K0i7Eg05ygdPsgT8E=";

  types-aiobotocore-lakeformation = buildTypesAiobotocorePackage "lakeformation" "2.9.0" "sha256-jcCQw7bdwDGSkkPFI9t7vxvHpVRuqI99myHWzFG+ivc=";

  types-aiobotocore-lambda = buildTypesAiobotocorePackage "lambda" "2.9.0" "sha256-p0gG1HwHYTk7TuE6BiPPhxEcegoCqu4JLdXoFpyy5Ps=";

  types-aiobotocore-lex-models = buildTypesAiobotocorePackage "lex-models" "2.9.0" "sha256-iapgXNpWmUuQtDmSouZoBf770ZFFeBg2qCxkmhNR1lc=";

  types-aiobotocore-lex-runtime = buildTypesAiobotocorePackage "lex-runtime" "2.9.0" "sha256-9A47OeYzpWp+k02C77P8gHpdEHom7XmEH8JS2mh5TAA=";

  types-aiobotocore-lexv2-models = buildTypesAiobotocorePackage "lexv2-models" "2.9.0" "sha256-IqM3pr5JDBylz73YilEChhlEvvk1H9+lx24E0DvbPMA=";

  types-aiobotocore-lexv2-runtime = buildTypesAiobotocorePackage "lexv2-runtime" "2.9.0" "sha256-8Uuu8yCz7GkVoAyCAJGO8TdKyVAV9aScjLguHvPzMT0=";

  types-aiobotocore-license-manager = buildTypesAiobotocorePackage "license-manager" "2.9.0" "sha256-LFojS+okyetuWB/i2NBXWb2rAkqziigx0cq5xj+YSsk=";

  types-aiobotocore-license-manager-linux-subscriptions = buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.9.0" "sha256-XQC3AGX/PtX9/c5NmwuIBPsXIuaUobSf6Bn+WYgSvJw=";

  types-aiobotocore-license-manager-user-subscriptions = buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.9.0" "sha256-sdUnhXztbU0Ud39fzE/bWvOknrivY+qpLgSY5myURro=";

  types-aiobotocore-lightsail = buildTypesAiobotocorePackage "lightsail" "2.9.0" "sha256-tTrZxkme+JeyXeuyWI3F7lr9mB+thfJaukNmIyaPBZc=";

  types-aiobotocore-location = buildTypesAiobotocorePackage "location" "2.9.0" "sha256-5Tiufq/wTJ89p3K4x1k/40cbL89M0O3dF6POFYMNr4A=";

  types-aiobotocore-logs = buildTypesAiobotocorePackage "logs" "2.9.0" "sha256-FrDg0lFXFTwBE81DZ4VOICgZLvDscip0k5oOGVXdRQ0=";

  types-aiobotocore-lookoutequipment = buildTypesAiobotocorePackage "lookoutequipment" "2.9.0" "sha256-IhhEOxTZVrKs6HxrkjssZEjV33wYX9rCpPG7SdinTRw=";

  types-aiobotocore-lookoutmetrics = buildTypesAiobotocorePackage "lookoutmetrics" "2.9.0" "sha256-TKzrgxj0rLBfeolbqKTSPjjZIJa7BC0wdpV2pY1K2BA=";

  types-aiobotocore-lookoutvision = buildTypesAiobotocorePackage "lookoutvision" "2.9.0" "sha256-TZKj6Vo0pEmwN7jlC2JxXhm9/IX58FJDRHqZSILF0zk=";

  types-aiobotocore-m2 = buildTypesAiobotocorePackage "m2" "2.9.0" "sha256-7DFARf/Jd0cPLKl3sxttpLn2cBZpC/xMyzQZbIsiko0=";

  types-aiobotocore-machinelearning = buildTypesAiobotocorePackage "machinelearning" "2.9.0" "sha256-UPTKT53+mTHnVmuMSaGhBT+KEYsaTvOdBcQ1Em/SEis=";

  types-aiobotocore-macie = buildTypesAiobotocorePackage "macie" "2.6.0" "sha256-gbl7jEgjk4twoxGM+WRg4MZ/nkGg7btiPOsPptR7yfw=";

  types-aiobotocore-macie2 = buildTypesAiobotocorePackage "macie2" "2.9.0" "sha256-GmSUlIinWqaxsQpTsIWNgEsZXUdheMiDs/qpHfbGAUs=";

  types-aiobotocore-managedblockchain = buildTypesAiobotocorePackage "managedblockchain" "2.9.0" "sha256-8ZTWT2U0eMkXqCbOTCMkKWo7x2lIyEAbSYZ2P0ssp3c=";

  types-aiobotocore-managedblockchain-query = buildTypesAiobotocorePackage "managedblockchain-query" "2.9.0" "sha256-0KUY9/My/m2dcxtw59yFZJHdCSZcrSfkdzHDgxBtEnE=";

  types-aiobotocore-marketplace-catalog = buildTypesAiobotocorePackage "marketplace-catalog" "2.9.0" "sha256-Bj1SMCXCljNw+1nakhnyvzqinyWliaE5YzvOaWrThfc=";

  types-aiobotocore-marketplace-entitlement = buildTypesAiobotocorePackage "marketplace-entitlement" "2.9.0" "sha256-DDozTz6pHq/BHmU8ikS18G+uIXGldY2QsOOAMycvogA=";

  types-aiobotocore-marketplacecommerceanalytics = buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.9.0" "sha256-/QjGbtwTKhmADkR2NXN304fDH3+oiB3I1Ykvsajexl4=";

  types-aiobotocore-mediaconnect = buildTypesAiobotocorePackage "mediaconnect" "2.9.0" "sha256-kYZBNr9zEjtTFXgk69fw2ZpsDxw49XzmtCVoqmIRBpA=";

  types-aiobotocore-mediaconvert = buildTypesAiobotocorePackage "mediaconvert" "2.9.0" "sha256-HnCyx0mhKwwyKKF1gsMkUbHUSBXJURtZKL2krl3wPyY=";

  types-aiobotocore-medialive = buildTypesAiobotocorePackage "medialive" "2.9.0" "sha256-VGqfVzvxAgF12UktAKEEvp7gdwF/Uvs1wF0Fv23/o7U=";

  types-aiobotocore-mediapackage = buildTypesAiobotocorePackage "mediapackage" "2.9.0" "sha256-E/5E4rIgle3Ge8h1jXg0EImztJamLWGTx3unCS3i3Wo=";

  types-aiobotocore-mediapackage-vod = buildTypesAiobotocorePackage "mediapackage-vod" "2.9.0" "sha256-Ly2iBYcmbmfzFhjXwVpnVkLYiYBVnb2cIQLEQ1PHHPs=";

  types-aiobotocore-mediapackagev2 = buildTypesAiobotocorePackage "mediapackagev2" "2.9.0" "sha256-j7vEKKolHogemhfN8p3RDdLLUCIm4XK4LbgTN1RjHVc=";

  types-aiobotocore-mediastore = buildTypesAiobotocorePackage "mediastore" "2.9.0" "sha256-sijOkeKG3EZU2aMkgVHhfnEVJCw/6LjCj3yn514BxHE=";

  types-aiobotocore-mediastore-data = buildTypesAiobotocorePackage "mediastore-data" "2.9.0" "sha256-YmAiMfw/OPkzyFQCqutBCcPHLgGnTTd64zZA+IQktSQ=";

  types-aiobotocore-mediatailor = buildTypesAiobotocorePackage "mediatailor" "2.9.0" "sha256-fvf8n0wwbaJQd6T+zag7fLW4DYFs97YA7PS4LjvrK6g=";

  types-aiobotocore-medical-imaging = buildTypesAiobotocorePackage "medical-imaging" "2.9.0" "sha256-APuySk3bcst59XgijDYhuphIM2jqUFpjwiI1B9IcVA8=";

  types-aiobotocore-memorydb = buildTypesAiobotocorePackage "memorydb" "2.9.0" "sha256-k0gaSat1viRrS1vH+xuGxO8zUAY5BucpbKFshKR/Gv0=";

  types-aiobotocore-meteringmarketplace = buildTypesAiobotocorePackage "meteringmarketplace" "2.9.0" "sha256-MS5ZMEW0iaHhjIgqTXLNNuYEBN9L5djCQupJfayNLx4=";

  types-aiobotocore-mgh = buildTypesAiobotocorePackage "mgh" "2.9.0" "sha256-g0uAmEucyImVVykA5g4BBclrd/n8Cl9hm2vkPpL21Vo=";

  types-aiobotocore-mgn = buildTypesAiobotocorePackage "mgn" "2.9.0" "sha256-xNecFvFbcQGCeE4ImLQYAB+/gv7ThrQC/E0CPoslcdA=";

  types-aiobotocore-migration-hub-refactor-spaces = buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.9.0" "sha256-zPm3aK/YaBfrkcnU2l1zN1RMl+hdiqcsBke1zwlxbt4=";

  types-aiobotocore-migrationhub-config = buildTypesAiobotocorePackage "migrationhub-config" "2.9.0" "sha256-XG30N9nTD8JPdIsbRb3A1YgUpzZCFx4CH9Q6i5LOPJM=";

  types-aiobotocore-migrationhuborchestrator = buildTypesAiobotocorePackage "migrationhuborchestrator" "2.9.0" "sha256-umzeHkjT+3mMucBJ8Md4V2RCuv7K51gZ/bJniv00+9Q=";

  types-aiobotocore-migrationhubstrategy = buildTypesAiobotocorePackage "migrationhubstrategy" "2.9.0" "sha256-AkZAtkQXJ9ygWVerPMbd2qLmeaXpe0tztITkVlSjuzU=";

  types-aiobotocore-mobile = buildTypesAiobotocorePackage "mobile" "2.9.0" "sha256-KLXvbCcc3OAEC5vBeDeBzaVaK1Kxw0jjhUS/1OdwOb8=";

  types-aiobotocore-mq = buildTypesAiobotocorePackage "mq" "2.9.0" "sha256-mi26QEURtPYs0r1iCEOpDlcKl1ioESD3GDh6shUQUzw=";

  types-aiobotocore-mturk = buildTypesAiobotocorePackage "mturk" "2.9.0" "sha256-X9E9lrFhfRHqfPZmOj1PtAHMLlz+2elYsUrb10/Wgzc=";

  types-aiobotocore-mwaa = buildTypesAiobotocorePackage "mwaa" "2.9.0" "sha256-l0ObDU6cjOCZOdcs047zx/1yoaZ8KN/3HEjAwYe9VK8=";

  types-aiobotocore-neptune = buildTypesAiobotocorePackage "neptune" "2.9.0" "sha256-cTEuEXJU/SzRNgxH1XjfFi/r7JCcB2Pru7mKckjBQ7U=";

  types-aiobotocore-network-firewall = buildTypesAiobotocorePackage "network-firewall" "2.9.0" "sha256-WtJSxvpB1T9CCaKnjBpsOJSelZtP8ySwpWeYiaJD1MA=";

  types-aiobotocore-networkmanager = buildTypesAiobotocorePackage "networkmanager" "2.9.0" "sha256-tDkjd34+PRsaypovhsY9AER8VbnyrrCx/njtxO7CJEk=";

  types-aiobotocore-nimble = buildTypesAiobotocorePackage "nimble" "2.9.0" "sha256-JuAsL2FAqZL8n8ODVpmQo38YJKBKzHT2VRAWVmPgvzI=";

  types-aiobotocore-oam = buildTypesAiobotocorePackage "oam" "2.9.0" "sha256-GQVHH8NbG8Uzd0dPc5MaNpDIPGct/07JsokCwi3JfxY=";

  types-aiobotocore-omics = buildTypesAiobotocorePackage "omics" "2.9.0" "sha256-Aq/0h7leT1KU+nQZWjg+KNhgV3osRREQv+QTMpYTZek=";

  types-aiobotocore-opensearch = buildTypesAiobotocorePackage "opensearch" "2.9.0" "sha256-lHZbMOVxTMolfPUCikFyK2REkgjnCMY49P5U4W4g/Iw=";

  types-aiobotocore-opensearchserverless = buildTypesAiobotocorePackage "opensearchserverless" "2.9.0" "sha256-COWGlK+XlrEtq5Xqg7x+hrFO7HU7uCLEOXDE2p9U3aI=";

  types-aiobotocore-opsworks = buildTypesAiobotocorePackage "opsworks" "2.9.0" "sha256-8W8uYZ/HqFcFgJubslCwIp1CpbrUNza3Ef0Pk7V76zg=";

  types-aiobotocore-opsworkscm = buildTypesAiobotocorePackage "opsworkscm" "2.9.0" "sha256-b5K01pxx7Mc5ykpssw/bxY7/PBSSa7a/nIcbcd3oz7w=";

  types-aiobotocore-organizations = buildTypesAiobotocorePackage "organizations" "2.9.0" "sha256-H92GHj8b2aeN2REWpG1EvyLv2HWjFZxg2DgQXH9BbPg=";

  types-aiobotocore-osis = buildTypesAiobotocorePackage "osis" "2.9.0" "sha256-0Dxf0aa76MBWX5TSdSWoFemHJ7wKqzj+vPDgZ9yMQTY=";

  types-aiobotocore-outposts = buildTypesAiobotocorePackage "outposts" "2.9.0" "sha256-62W37n830OMhhCTsEP1r5mrCY8MZZM+OPgvZ/ox4S70=";

  types-aiobotocore-panorama = buildTypesAiobotocorePackage "panorama" "2.9.0" "sha256-OBQI+qRwV3nB29WFuIPxXIc2fV5RaMaaCiJtYTKp28A=";

  types-aiobotocore-payment-cryptography = buildTypesAiobotocorePackage "payment-cryptography" "2.9.0" "sha256-3qawANwA/wOWqNl3Q6RKS2CLb1pw8K6dbX4jW2MAHEc=";

  types-aiobotocore-payment-cryptography-data = buildTypesAiobotocorePackage "payment-cryptography-data" "2.9.0" "sha256-adLvjvZNRcNM07nvr3Frh5a2X7wgOuxdZ21iLnw9crU=";

  types-aiobotocore-personalize = buildTypesAiobotocorePackage "personalize" "2.9.0" "sha256-apNRfsAdZHuqs3SMUgnuZun8GbCog/5s7MSdyVIHz5Y=";

  types-aiobotocore-personalize-events = buildTypesAiobotocorePackage "personalize-events" "2.9.0" "sha256-sxcApDREahAvxXswhv7iZkrYXcjdOGa//SFSvtlHMJ0=";

  types-aiobotocore-personalize-runtime = buildTypesAiobotocorePackage "personalize-runtime" "2.9.0" "sha256-eurE8IY3eyuUjj3rhT59xu0KHRnbJy/OL05XKBov0Y8=";

  types-aiobotocore-pi = buildTypesAiobotocorePackage "pi" "2.9.0" "sha256-bWg/J1JyM4pkKalsMqUMPMYJ+T+SSzR4P0+VJTSodWM=";

  types-aiobotocore-pinpoint = buildTypesAiobotocorePackage "pinpoint" "2.9.0" "sha256-jKAsxMwQCI/DOY8HiRmmXdVqWAoVD4ULdwSoU18kmJs=";

  types-aiobotocore-pinpoint-email = buildTypesAiobotocorePackage "pinpoint-email" "2.9.0" "sha256-JgTZiFxdBNTAHT7X3LdTTEvI5Z+MjF6JcZ8zbjZxsSA=";

  types-aiobotocore-pinpoint-sms-voice = buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.9.0" "sha256-HGsiBhxwTVKUFQgGlx17n0/HUEL7/FIHgxKxFg4Vsc8=";

  types-aiobotocore-pinpoint-sms-voice-v2 = buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.9.0" "sha256-fXszL3FutdKRAkh3gWvu5xiGlvy3Nn/r0MCKYW5UAYg=";

  types-aiobotocore-pipes = buildTypesAiobotocorePackage "pipes" "2.9.0" "sha256-Qs9ndgWnw7yUvKJcI36i8c1imwWvX3isJocEYjj93Ls=";

  types-aiobotocore-polly = buildTypesAiobotocorePackage "polly" "2.9.0" "sha256-9PNsD5t7iZh+Bcnbqbq1RV7IMbDT/IptteaUsJB+AKs=";

  types-aiobotocore-pricing = buildTypesAiobotocorePackage "pricing" "2.9.0" "sha256-zYgDgmqCshI/LbmZYO+X9+sq1Bi3xlBDugnqVfewu1Q=";

  types-aiobotocore-privatenetworks = buildTypesAiobotocorePackage "privatenetworks" "2.9.0" "sha256-QX/fr036L4eVPdUnUexEDJc++oIx8WJRwI1YmnFuYqc=";

  types-aiobotocore-proton = buildTypesAiobotocorePackage "proton" "2.9.0" "sha256-zx4Zt8J/xgql2vu/tZgwmFLWq+2bhhq2u6q08L5nkBY=";

  types-aiobotocore-qldb = buildTypesAiobotocorePackage "qldb" "2.9.0" "sha256-0Ob22rt0ZfEuoez9knN5BegTWTI+T0cwH96rkKHWVWg=";

  types-aiobotocore-qldb-session = buildTypesAiobotocorePackage "qldb-session" "2.9.0" "sha256-TVm24eYojgTrdWzFKgL2pkjekx9Bd8cqTKVGybs+2Bw=";

  types-aiobotocore-quicksight = buildTypesAiobotocorePackage "quicksight" "2.9.0" "sha256-RTV8LwRM/lNYFCx4L2PnJhXHCjeDHKsMmHATcUOd2R8=";

  types-aiobotocore-ram = buildTypesAiobotocorePackage "ram" "2.9.0" "sha256-twdBnpMqPTyb+tVD7Qa37C29hds3UM7Y6/63qr4IBxM=";

  types-aiobotocore-rbin = buildTypesAiobotocorePackage "rbin" "2.9.0" "sha256-FxYiwMon/E3g5uphHutjXsZ4gvhyoy4BE7gfX9v9KOY=";

  types-aiobotocore-rds = buildTypesAiobotocorePackage "rds" "2.9.0" "sha256-4UwgKkbnHgSrDIjVgp729mt1LWtTTmr4Vqk+MGkyHDg=";

  types-aiobotocore-rds-data = buildTypesAiobotocorePackage "rds-data" "2.9.0" "sha256-1bOOeQqg9AdlHIuznEUF2Q8+1iN4ZwvFfRMnzAew9xQ=";

  types-aiobotocore-redshift = buildTypesAiobotocorePackage "redshift" "2.9.0" "sha256-uUhg8pu/tPO5ufx3oAA803ddLMIJb8ZRFqYYY7asprU=";

  types-aiobotocore-redshift-data = buildTypesAiobotocorePackage "redshift-data" "2.9.0" "sha256-HtJan10OMZZP0DTFw4b4iadl+ufHbbCGkypk6gTHevA=";

  types-aiobotocore-redshift-serverless = buildTypesAiobotocorePackage "redshift-serverless" "2.9.0" "sha256-TL4NDdKm50bgUZV+bkxqRY1P5C48tT7+E4wiNMgMLG4=";

  types-aiobotocore-rekognition = buildTypesAiobotocorePackage "rekognition" "2.9.0" "sha256-zAYEPrQ5SexvufL2aSagLLWx2VPFURLRu+YwL/m4cWA=";

  types-aiobotocore-resiliencehub = buildTypesAiobotocorePackage "resiliencehub" "2.9.0" "sha256-3C1PcG2DzbRT3Yrloipng73tZKdcGiYniU5n095Lodc=";

  types-aiobotocore-resource-explorer-2 = buildTypesAiobotocorePackage "resource-explorer-2" "2.9.0" "sha256-UzzHOnTX2tLVEY+xJVrDu4I8/RP8/rx2rNZcINs4DOM=";

  types-aiobotocore-resource-groups = buildTypesAiobotocorePackage "resource-groups" "2.9.0" "sha256-w7MJhBAtOsbZqZQlJdFiP4q8qpk7nc1YEXCgbw3Fd20=";

  types-aiobotocore-resourcegroupstaggingapi = buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.9.0" "sha256-dkRibrcQpSnU4ChhRSibjQbosbOy6wd42P91MVrD7+o=";

  types-aiobotocore-robomaker = buildTypesAiobotocorePackage "robomaker" "2.9.0" "sha256-n5zLgWXRlVz+dXVOeEg4ZVq2mCiBDB/4pJfHeFF6Z5Q=";

  types-aiobotocore-rolesanywhere = buildTypesAiobotocorePackage "rolesanywhere" "2.9.0" "sha256-HNjHfM7Oi4HKmYL5Sgwqjg2hWyKmLXYq1nDwhmVN6cs=";

  types-aiobotocore-route53 = buildTypesAiobotocorePackage "route53" "2.9.0" "sha256-d54iOVNPFrwS9Cw/uDZO7CCIsj2QzeKkgKy+cWehfcQ=";

  types-aiobotocore-route53-recovery-cluster = buildTypesAiobotocorePackage "route53-recovery-cluster" "2.9.0" "sha256-MLPzjWP6xBrczesskwbvKVbjFT8ZC8MV7jgkR/AAxu0=";

  types-aiobotocore-route53-recovery-control-config = buildTypesAiobotocorePackage "route53-recovery-control-config" "2.9.0" "sha256-nl1PsCKbjiizg+oPVkYvkb1iuN/egoBQp6EN1BWcrQw=";

  types-aiobotocore-route53-recovery-readiness = buildTypesAiobotocorePackage "route53-recovery-readiness" "2.9.0" "sha256-cFWmcjptrX/infPksVRugvHdnKFU0SG/90OU+HPl5ZY=";

  types-aiobotocore-route53domains = buildTypesAiobotocorePackage "route53domains" "2.9.0" "sha256-1LucO4/jgl1YpMlbYuIJXrhxkLx6tdKTMaoMAWTDybM=";

  types-aiobotocore-route53resolver = buildTypesAiobotocorePackage "route53resolver" "2.9.0" "sha256-s8DoTrQEjGpqwwYlwEkoCNopDow+M7rbQZCqU2aBdZ4=";

  types-aiobotocore-rum = buildTypesAiobotocorePackage "rum" "2.9.0" "sha256-dRncp/7Z8FeJ/sBqHFHO7z4XZKgWeOuRPGzXf4djzg4=";

  types-aiobotocore-s3 = buildTypesAiobotocorePackage "s3" "2.9.0" "sha256-KwNH+X1Kl61L+iuK+XtZWGhTl71RpHyJhCfB+Hw1IyU=";

  types-aiobotocore-s3control = buildTypesAiobotocorePackage "s3control" "2.9.0" "sha256-/earpJzKe0zF+fjxUa/Z6JKmxxWfOlMngxlia6aTFxs=";

  types-aiobotocore-s3outposts = buildTypesAiobotocorePackage "s3outposts" "2.9.0" "sha256-lLp/gUu5jrOJ6ZXQ4qKVfREsN4WYl/h9zgfgTUtYiiQ=";

  types-aiobotocore-sagemaker = buildTypesAiobotocorePackage "sagemaker" "2.9.0" "sha256-kAunITSH13bGe6XWTlG/QSelzDFnINih/o/zuFR34us=";

  types-aiobotocore-sagemaker-a2i-runtime = buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.9.0" "sha256-U9cVOg2CkVclCqSqr4okJJSC0ZmGIH390KTNKMJUBhw=";

  types-aiobotocore-sagemaker-edge = buildTypesAiobotocorePackage "sagemaker-edge" "2.9.0" "sha256-Oe78n3fu201OmZpPb4cjhLY1x1KTT5MYLXdy9M4KkOE=";

  types-aiobotocore-sagemaker-featurestore-runtime = buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.9.0" "sha256-xmRI5TMR99TROVf1CPif60NeLhCqNpb6Lt662fGK+WY=";

  types-aiobotocore-sagemaker-geospatial = buildTypesAiobotocorePackage "sagemaker-geospatial" "2.9.0" "sha256-OPIq8UKHJNDe7lMbHkHt4z57k3L7y6ys0a9TSJiiFIg=";

  types-aiobotocore-sagemaker-metrics = buildTypesAiobotocorePackage "sagemaker-metrics" "2.9.0" "sha256-oyBG62dmdxbZaIAIb5cXq+qWYD/yDPHvHu6Z+wOg9Jc=";

  types-aiobotocore-sagemaker-runtime = buildTypesAiobotocorePackage "sagemaker-runtime" "2.9.0" "sha256-KDkf3G/inaFjLe0jfgdUQ31ugbj8mmgYzJKvb1W15lA=";

  types-aiobotocore-savingsplans = buildTypesAiobotocorePackage "savingsplans" "2.9.0" "sha256-f4DbYsiuX1xrLMZ9foOyJC5NhVtMym3mnj8RD+MvlIo=";

  types-aiobotocore-scheduler = buildTypesAiobotocorePackage "scheduler" "2.9.0" "sha256-HuXw6MBuBzaDpf6HfR++F8LC+5WgpThF+BQz2nO1LHQ=";

  types-aiobotocore-schemas = buildTypesAiobotocorePackage "schemas" "2.9.0" "sha256-du/fn168xn0Nzox8vbEOJXnIcRBWatgihJZRGTzy4pE=";

  types-aiobotocore-sdb = buildTypesAiobotocorePackage "sdb" "2.9.0" "sha256-zgWv9fUOlUWDeBSZwHLG1Oc8CRY7uK/Hu3EJAJsVcEQ=";

  types-aiobotocore-secretsmanager = buildTypesAiobotocorePackage "secretsmanager" "2.9.0" "sha256-fdnSUH7SuYoKqWohGCmJRbKVJwkNgalBIdL+ZSA95uY=";

  types-aiobotocore-securityhub = buildTypesAiobotocorePackage "securityhub" "2.9.0" "sha256-i02XTjgEgzXFnsHqgReWb/p+OhWdXA90pduejrStXug=";

  types-aiobotocore-securitylake = buildTypesAiobotocorePackage "securitylake" "2.9.0" "sha256-tZq7D3UPg/G05ZHl0btwePfrKz69vfo4Kpwf5haepv4=";

  types-aiobotocore-serverlessrepo = buildTypesAiobotocorePackage "serverlessrepo" "2.9.0" "sha256-6Z4f/NRtoFtdiFFcVc+3a908H8JcRKNzcImAVPk4quo=";

  types-aiobotocore-service-quotas = buildTypesAiobotocorePackage "service-quotas" "2.9.0" "sha256-U3S8VoxZD2YIW9yHUU+jk9QqG6gI+wiJBaeXEx964p0=";

  types-aiobotocore-servicecatalog = buildTypesAiobotocorePackage "servicecatalog" "2.9.0" "sha256-xYV3AUOEcU1fuzntpgoNT2gFykL2CmvYi7AnVoTrtjA=";

  types-aiobotocore-servicecatalog-appregistry = buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.9.0" "sha256-1fYP1lZcVAdtOjmN4hfLJbZ1526Gaf7xqxj0xmqZimA=";

  types-aiobotocore-servicediscovery = buildTypesAiobotocorePackage "servicediscovery" "2.9.0" "sha256-SPAmhlm5j8zhyJeERoHo4oaJ73PSdTpQWbseY21jJw8=";

  types-aiobotocore-ses = buildTypesAiobotocorePackage "ses" "2.9.0" "sha256-GM3RaxZuprL1PBlTbk3UOO9M5pu1nQekIcUzrCbSXC8=";

  types-aiobotocore-sesv2 = buildTypesAiobotocorePackage "sesv2" "2.9.0" "sha256-bn0DLwQuzoyrZ8odMQcDfFApt/GTnPNdeT693yF/k3s=";

  types-aiobotocore-shield = buildTypesAiobotocorePackage "shield" "2.9.0" "sha256-g2WTDLMdIrSJLQj87lHT9aO54Nuo8IVSzqkpuQqqJBE=";

  types-aiobotocore-signer = buildTypesAiobotocorePackage "signer" "2.9.0" "sha256-4izCsd6sv53hqImdd5eYJmBg8zSvHkQ6rcqOLfKJF44=";

  types-aiobotocore-simspaceweaver = buildTypesAiobotocorePackage "simspaceweaver" "2.9.0" "sha256-3cJaY6BwMo1G6BguoEYjbUHNb0OkWOIcyh8kxN06t3E=";

  types-aiobotocore-sms = buildTypesAiobotocorePackage "sms" "2.9.0" "sha256-PsLWqcPoKDgofkcIeC1P9DKzFVdkhq9A9IjA7uavoIk=";

  types-aiobotocore-sms-voice = buildTypesAiobotocorePackage "sms-voice" "2.9.0" "sha256-+AyzDu7C0wnniV5dphcvlswRDjktAJS9JPc52Jy5Mqk=";

  types-aiobotocore-snow-device-management = buildTypesAiobotocorePackage "snow-device-management" "2.9.0" "sha256-boSrX4EczJXDyxYFDFcn4uaTJ1GJfWHV47Mt0iWUYXY=";

  types-aiobotocore-snowball = buildTypesAiobotocorePackage "snowball" "2.9.0" "sha256-5ofD5IlGtmtd4k0Tja/qXOn2cWddeqMSvorIAv0mfIE=";

  types-aiobotocore-sns = buildTypesAiobotocorePackage "sns" "2.9.0" "sha256-6yF9zXzRUyi+EvmIeEt1sjsyOkwoT0bKdr3Dtz4q9oE=";

  types-aiobotocore-sqs = buildTypesAiobotocorePackage "sqs" "2.9.0" "sha256-bN1OXfRr0M9TGdOxZ3hzF4yVRo8qLtdJ1GIqp1WwY8g=";

  types-aiobotocore-ssm = buildTypesAiobotocorePackage "ssm" "2.9.0" "sha256-IdkwP86TCIY2v6ZV35SYMmxUqW204y7HXTFtoA3Z/A4=";

  types-aiobotocore-ssm-contacts = buildTypesAiobotocorePackage "ssm-contacts" "2.9.0" "sha256-xyQkxMnmInrwXdTcjv+2V5BUYS1OrQXbZLPjgMOIvwQ=";

  types-aiobotocore-ssm-incidents = buildTypesAiobotocorePackage "ssm-incidents" "2.9.0" "sha256-DhGvTnJzNCZgSSZ63kjWhPYnH/SF+S2QHMU/0fgx8Mg=";

  types-aiobotocore-ssm-sap = buildTypesAiobotocorePackage "ssm-sap" "2.9.0" "sha256-j1QoIAprz33FLjIAmHj+v+2SYFQnL4XFEc+hyMLt78U=";

  types-aiobotocore-sso = buildTypesAiobotocorePackage "sso" "2.9.0" "sha256-TQxkfWv0SiS1smEPwlBKgtbhJhU+7ieokyx5zilAlNU=";

  types-aiobotocore-sso-admin = buildTypesAiobotocorePackage "sso-admin" "2.9.0" "sha256-1vMwGFdAnCgwgwlV1fS0/w+o9gza4bokOIRmnse+Zh0=";

  types-aiobotocore-sso-oidc = buildTypesAiobotocorePackage "sso-oidc" "2.9.0" "sha256-iTJyIepGMJ5NUX/khzrdliVl4/uJkDmXfTBdHk4k9mo=";

  types-aiobotocore-stepfunctions = buildTypesAiobotocorePackage "stepfunctions" "2.9.0" "sha256-mdunNfOw87uR9BYgy/XILp5KoJRIUHWQvdoYTPY4i0M=";

  types-aiobotocore-storagegateway = buildTypesAiobotocorePackage "storagegateway" "2.9.0" "sha256-Ag1LkXIdiQGyMP5V3c1M5DFtarjcnUX5+UN6oEPf8nk=";

  types-aiobotocore-sts = buildTypesAiobotocorePackage "sts" "2.9.0" "sha256-51P6hpVcVTUtLxN9/QGVCAWnv5Lnb9pMNE7WzKq5U9w=";

  types-aiobotocore-support = buildTypesAiobotocorePackage "support" "2.9.0" "sha256-c1Nip/gBkVabW4oFq4B6fdi9DauiYZfOLHD4LUR9fLw=";

  types-aiobotocore-support-app = buildTypesAiobotocorePackage "support-app" "2.9.0" "sha256-8A6p38j1R6e/2ptWRfKkvpAnjeZPUWgciHpj7Sg0N60=";

  types-aiobotocore-swf = buildTypesAiobotocorePackage "swf" "2.9.0" "sha256-1QtnA3BohFWVLso1DdbNO0ZOOAODhXmfT6r/Espp/vI=";

  types-aiobotocore-synthetics = buildTypesAiobotocorePackage "synthetics" "2.9.0" "sha256-1Cr8kzYLGroxGtHxx9eiyRW3I6sbyNIRweW6pAW6pFQ=";

  types-aiobotocore-textract = buildTypesAiobotocorePackage "textract" "2.9.0" "sha256-hSWUOXPsqVpQ0a6jOMll17W43wEbKv6i4fllIo0xLzw=";

  types-aiobotocore-timestream-query = buildTypesAiobotocorePackage "timestream-query" "2.9.0" "sha256-a+fTXaX82nlaUvDmkDUIW+t/wsNXWZx7BqQj7H/jnVM=";

  types-aiobotocore-timestream-write = buildTypesAiobotocorePackage "timestream-write" "2.9.0" "sha256-YGZa1FOkq9snM5K1DZQv7efgBvMx8axCKbsoviJWSrE=";

  types-aiobotocore-tnb = buildTypesAiobotocorePackage "tnb" "2.9.0" "sha256-afMNaqyMd84FTSTTLTpBQ/jfUuCvVmpyg7rdXavOJPQ=";

  types-aiobotocore-transcribe = buildTypesAiobotocorePackage "transcribe" "2.9.0" "sha256-jFdJigP2fLlRtw9WzhaSFicg4TBTfD3wVZEV8PeOqcM=";

  types-aiobotocore-transfer = buildTypesAiobotocorePackage "transfer" "2.9.0" "sha256-rXLszhZTZBPCMlGwqZWsdCnoNy2MTyzzH+IrQ75Jxu0=";

  types-aiobotocore-translate = buildTypesAiobotocorePackage "translate" "2.9.0" "sha256-6CJeDPdwIWQMGBkAtxO8PJclkXGeY5iTbpNlWgGFcKs=";

  types-aiobotocore-verifiedpermissions = buildTypesAiobotocorePackage "verifiedpermissions" "2.9.0" "sha256-abQQMTXvqkZ4V/82XnYRA4HXqPqYVDFlyn97stA6/6Y=";

  types-aiobotocore-voice-id = buildTypesAiobotocorePackage "voice-id" "2.9.0" "sha256-f66AVRU3jXSzWWiDO1CWS+F742WmhcGlf2IXvAOPwjI=";

  types-aiobotocore-vpc-lattice = buildTypesAiobotocorePackage "vpc-lattice" "2.9.0" "sha256-sA6mKo/co3Z9hPha4kHHUud9AO/CLhEijh66wlp2uOk=";

  types-aiobotocore-waf = buildTypesAiobotocorePackage "waf" "2.9.0" "sha256-Js6x76EgqKu4IJcgG8FpMge4nfhlKj/7HRZjgi/f5tA=";

  types-aiobotocore-waf-regional = buildTypesAiobotocorePackage "waf-regional" "2.9.0" "sha256-YCTW8axxeeDNCH57xUSKsRXNyproIYsUqHN7Kb/c9Lc=";

  types-aiobotocore-wafv2 = buildTypesAiobotocorePackage "wafv2" "2.9.0" "sha256-8lZTtK93+IQyfQ/QQ3WSgpD3VlzPq5aQn/Avife21nI=";

  types-aiobotocore-wellarchitected = buildTypesAiobotocorePackage "wellarchitected" "2.9.0" "sha256-BzafdUAL6TrYMuP1TwPXTS/aOlhjZbM99ZtEQ3wxQV0=";

  types-aiobotocore-wisdom = buildTypesAiobotocorePackage "wisdom" "2.9.0" "sha256-WkpW8vk7U4WkqeX13RhzahEtZrdQ49X2NoeSIpRQMQM=";

  types-aiobotocore-workdocs = buildTypesAiobotocorePackage "workdocs" "2.9.0" "sha256-kLp8nHOB6A47nmAd9jXwr+nXS8xnv10eGkI/zd53wRI=";

  types-aiobotocore-worklink = buildTypesAiobotocorePackage "worklink" "2.9.0" "sha256-4g39qn3h//b4/Dd+C0zasVvmyENfkvhPIj+EklHf9iY=";

  types-aiobotocore-workmail = buildTypesAiobotocorePackage "workmail" "2.9.0" "sha256-WSAQekT3lmS/2miTbK0eYWde7eDIleY7yP+1HdMcCXM=";

  types-aiobotocore-workmailmessageflow = buildTypesAiobotocorePackage "workmailmessageflow" "2.9.0" "sha256-Y7scQU1qMyGMrkOdmpJuRKdxR9nlsKsoiDCBT1Qa1F4=";

  types-aiobotocore-workspaces = buildTypesAiobotocorePackage "workspaces" "2.9.0" "sha256-AIIU5d6D+hVd36Qo0hpq8tNakoCVpmqjYKVgGUjtVOU=";

  types-aiobotocore-workspaces-web = buildTypesAiobotocorePackage "workspaces-web" "2.9.0" "sha256-fchpLQ4yB6LzpzvKJBraHIFEMKsMltWoMzihUkwUedg=";

  types-aiobotocore-xray = buildTypesAiobotocorePackage "xray" "2.9.0" "sha256-L+y55NnvYeTgXVp+DJ/dgKPQYBIFsu48qgRjwAX7nBs=";
}
