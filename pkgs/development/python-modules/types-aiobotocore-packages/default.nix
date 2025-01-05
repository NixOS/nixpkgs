{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName oldStylePackages then
            "types-aiobotocore-${serviceName}"
          else
            "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        boto3
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = licenses.mit;
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "2.16.1"
      "sha256-doY8AmelQadbd7aKQHxultg7+yCOarXkzu83L7sTmCU=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.16.1"
      "sha256-NbmCX/Bk3HWom7sZFFxO/Rk4U2J38NVJJApuyRVNaPo=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.16.1"
      "sha256-eq8uSOhX2g+1ZhE/QX12TShP5Ulwj/UfBGJdkoWL7OM=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.16.1"
      "sha256-EZ/4dUk7zraiHY085OKD5tylmtVP/eEj7JU9hvQe2Qk=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.16.1"
      "sha256-bJ8unDyBIRxQFzYUG/ruR2fS3+bjpbV6oblJfWukiXQ=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.16.1"
      "sha256-9gKzw6vx+gZKkA5hDCSzzqdaRVFn4Agb9Jm1i6ifGvM=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.16.1"
      "sha256-Imqcvi5B05g27py31TR1x4vS0fUA+ARERj2uE0h5Ttc=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.16.1"
      "sha256-A2xLzMakoCpapZjWFghPGI2bSfvoLAPGG30aSiuakQA=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.16.1"
      "sha256-NDee6RjnaZSORsuFdpAXb/QTVWrDh8NdiTLTBAn50J0=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.16.1"
      "sha256-ziWe8zlBUrhMVwLXuT5bQtu+/WGd4dbiYcAYf1QlTgk=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.16.1"
      "sha256-DuEobaZnv8CV6BL6kINxPVo3tjHirAikYB25yT11BcM=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.16.1"
      "sha256-ltG2QlzjaD5pD7OgM5Ot2wMVe0g9QNsssFSAvChzaGA=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.16.1"
      "sha256-eTRT4X8qKre9h/tiuAbpySLAscWkrHLNaUJPeZxQwKE=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.16.1"
      "sha256-JwuVPGjXQbWLLQEb4/1vX9q1olWuaUdmk/nXv8Qi8Xs=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.16.1"
      "sha256-8M376jX+tRjMlC3AuCjaxT+dGo62UzEIiRYt78cuD9Q=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.16.1"
      "sha256-aYNLx+etGhhcB/VvYBw7rVB6ammdsLTSfvLdWiDbK3g=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.16.1"
      "sha256-QwWOx5gs0wVzXL8j460OrUmhgl9VU2S1KLqqamcB41g=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.16.1"
      "sha256-2qnMHtFNymq3GXqq0t/5512PzYbl0qwBU3MPmhB6R8g=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.16.1"
      "sha256-aa3+jrjAgs3cb4HfExSdjDKBUcnZvkz+a6K8NkDlSFM=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.16.1"
      "sha256-posFLbWGs50P4XszM79xQJP0rcilejOFi13O0UpKxKA=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.16.1"
      "sha256-pxjhJjaA8Ye8dw680UCAHftZSGR1r8bsgJUgTNjtgmY=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.16.1"
      "sha256-aE5vbkfgsPb5fkf3bbQhGqEojU69K00KyrRd//02vK0=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.16.1"
      "sha256-U9/Yvqmouk1DlhCY1qWoL/5skp0ngLoedy0rcUex3Ro=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.16.1"
      "sha256-PiMxhaKiLQkQmqF1UagO9icS92nq8P+7Hn58Cjz9Qog=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.16.1"
      "sha256-e9X0Z0SaeY3RvaM5NwNOvpuV/yWJ6KXPrrO9z9dq9mg=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.16.1"
      "sha256-vpNQXCy8G9U2MxUi5fYUOfNagXkhUXJe+Z5wjQ0Vyxc=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.16.1"
      "sha256-GANZJLmX2z95dXv1673rGGvfeK7561+25yHdAzBrmjk=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.16.1"
      "sha256-RlQdaAq+XETN1pA2DWeywJu13pL009KQBxTeX+WtSAM=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.16.1"
      "sha256-tFvoZE7laY54RFZZBccwJ0C9ZIvV89AeTDd4zb7baXw=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.16.1"
      "sha256-P8pueiqXA/6jcfB3nByYXmtFOkB/ArREtYJxJf4CDEM=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.16.1"
      "sha256-wE9BaHSNjEhiyPnTC4RZC5sjVXZJr39LQpvIxg7N63k=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.16.1"
      "sha256-KheKLpT6hQ7mMR6Vz/KEjahfrMCZKcHYDlCu8LM/fr8=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.16.1"
      "sha256-3rLxbn4BUONKAwtJognzRTr3L6g79rw4/uT7qDNqI5c=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.16.1"
      "sha256-b3ZKSr8WPbAttxb6avQEMnDFvY+DwC3WpUHFI80nk20=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.16.1"
      "sha256-9rZaoWPhGSoMebnhbn69MwcOSFtq3jo7MqwVgMdMBDo=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.16.1"
      "sha256-Q4t4cRQNqX8Dqy5fJyCsVp5vcQnLC3bt+a8Bj0u0vMg=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.16.1"
      "sha256-Z+EoRS14ctc9+UJtn4f04B/uhbzSqnxn8VNv/URKfRo=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.16.1"
      "sha256-9hXClh2H+Ij8m85oVu+H6esEe2MepViDwEyyMJRxyVc=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.16.1"
      "sha256-QsEtiAWF5qt+8bcyyuIe9oJiHZIkGCAkqstimh7q/kg=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.16.1"
      "sha256-npTWNeikCpt9Q+H8e8zMZ6Oa8NEbmJ7Ec20j1gdnqUk=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.16.1"
      "sha256-Tzh8Fh0L9Na+D8kq6Cb8dULKjhmdV7prja7DOHHLSxQ=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.16.1"
      "sha256-QPkxjr033r5KUof9xLLFm7SDiuoVKR6feOpywWaEeT0=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.16.1"
      "sha256-6FEd39Mjrh5y34AMcjULGbDjFxOuwWnb2wa8mS+x148=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.16.1"
      "sha256-6Bmf2tD9ddzcUHhfTOyH/BCD0e4inGVddSwj3b28wPY=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.16.1"
      "sha256-P2G0HUovHruZcvQCKZ6Men+oy9J1vB571epu9+NiiwA=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.16.1"
      "sha256-TSYiLPtFLokFn6vD1zsh7XxP5Pj0dgCF5c6w51d6c1A=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.16.1"
      "sha256-D2cooRwBlMoHsYjQ0Cy5IPBZDDcGDyxOepQZ+slHwao=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.16.1"
      "sha256-Qq14+CX5zWV9UjwLAhmh9tjeuWB6rmmYdq6wEcZ19BI=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.16.1"
      "sha256-HmUVDEPkU/ef37Tqh4U15KrevLzDpt07oOOEzSJCxZA=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.16.1"
      "sha256-QZPmEm6V9nB8VszJyW6HOsRNne/AV+78SSegKfmLEkw=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.16.1"
      "sha256-ocNSmapCkM/5UlKz9wXGxejoUodGugxW3ju4jFBFqV0=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.16.1"
      "sha256-I/fyAC2EFYBFONoyHFggdZbHYNCCF8c7XV16vCw/kfI=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.16.1"
      "sha256-aaEhjVOvMsVQg8yJOn0iN/qpC2LsflfTjaTqEYs5lFg=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.16.1"
      "sha256-1OQHz4H3yCirsek/PAfJy2HrsTXJ++OPhSe7Q5EtgkE=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.16.1"
      "sha256-DqMikrn5AGPXeX5lf1+NcsR3pOQ+AYFB9sfICLV5R0Y=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.16.1"
      "sha256-GZTyDa0zx77uqfKklxhozcALkJK37xqiLXrPaps5bRI=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.16.1"
      "sha256-f5AZO5Ge9nHn/NxrglEF00inlnFJ7ESCpGMyo8ZFDx0=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.16.1"
      "sha256-EpXd1zxtoq0e5/94/x6qbqd/TYaOItWGt1DczQEhVrU=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.16.1"
      "sha256-S95O9PVDZa4BDHwVjhMhy4pAnoA7YDTy8VUYKDNu5b0=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.16.1"
      "sha256-NGgWudvt57kjkDS8QG4KfPPlqDjp5CUb9N7eNYMd4RQ=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.16.1"
      "sha256-hMTDJx9Qx9jqbnxyJtxciZOceBE95tupIV9I830Vhcc=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.16.1"
      "sha256-O7bKiCckjLw5WEQVCrOkMEUix6vb4xoUnYjNsBjVip4=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.16.1"
      "sha256-7nHM1ruRyC3Lrp5z0N51pUPvlYWrFon882/SFy0EMsA=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.16.1"
      "sha256-gsIDnhC96LBLmxrgb18qDgeAZAGIbaViV3vj6XKArJM=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.16.1"
      "sha256-wInYPxRCAR9/GE6YnrqU/kS0m4PyclYJCnYeDxs4M1I=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.16.1"
      "sha256-YkeS42V3NGMvMunPnQvZL262A5Nj1oyqNpqiTEepuPA=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.16.1"
      "sha256-mhYTHekut+W77A00z9aVtN5xC+49ZHpy27KHAOS2duQ=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.16.1"
      "sha256-8jQaw0HfbGKTtHFbO1c5xxm+6+UngSeL8mUdu2HuxYM=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.16.1"
      "sha256-TF1rxBcdz0czqim6ZqY1Wrb29evhHa1OBQzfqmPh+xE=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.16.1"
      "sha256-BykDFBWRoZirxYV3BGWyTOK64BOdA+1yezkO2PBfqBw=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.16.1"
      "sha256-zfPHMjUDq3sziXSHKc0ZZirCQ03NWzlgbO6nPXGisiY=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.16.1"
      "sha256-0cVa9bZG5bsrMO9603g7wU9+SwR6yEzha0DVI3AuYuQ=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.16.1"
      "sha256-b5kwna8iwn7EPrHbRmDTidCsz40WdxpwYqXCCWjlDF0=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.16.1"
      "sha256-Fhnc2rtww0AqD6hOwDe66+c+SKk4OE7rugafzr3MPxo=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.16.1"
      "sha256-5s8BCMpbLBxCvqVy0NZesXNcsTvdtitNfknX7mzytTk=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.16.1"
      "sha256-+Jy+WrKdFWtIL+z/QUw4CkCaaZAH8YHKvYa6Yivxn5g=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.16.1"
      "sha256-nCN/d9zqeiVcVIJ7G6i7R3MWhDdsW+CAdXQCR+w6cQE=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.16.1"
      "sha256-JqD1Bs/BxvNL6O61HkOUwsEIG2x/0OrLsu9QYN+dNp0=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.16.1"
      "sha256-LBX0dbqnYuJlU44fOqwpkpzapkC2M32jl9Z/yHMcxMk=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.16.1"
      "sha256-SXxG4/gOZuYVGrFTDZSrSlb0+couEBLLHWGrduZInao=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.16.1"
      "sha256-ncy825XkE8YklJnvB9+/bd/OVC8flFyApYXpuPq7ZKg=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.16.1"
      "sha256-YR/EwYMiEgRDLGJUv4aBR/Cm1rBbYu8Z4XY/Ibtn3Q4=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.16.1"
      "sha256-uldnhjvzvWwM0pGR9UslHhsPcC497CAzpCEhYrLh1Q8=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.16.1"
      "sha256-ivO8Zp59pyLQtH0NOAAjBBQ6AliIBeoQ+uUgXRCo+3E=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.16.1"
      "sha256-C4Fx5iPfSapMrXWo7zYxM5cPumdxElumy3RCdaVq6fI=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.16.1"
      "sha256-vMmDqCYC3KjzX/ImgGdfZ9l7XZQyPuUNzFdak5+AASI=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.16.1"
      "sha256-9jjV20LFv+4qX4UOIIiuh2TtdJzL+L97rKAEwcv9JAw=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.16.1"
      "sha256-U3uc0wTw4RZv0r9yag7OnVj/1amkCATb17ZKvhVXyws=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.16.1"
      "sha256-DgQOcy4W1PN9yJOT/bfIx6QjlSBqyw2VGIRZWR3wBxA=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.16.1"
      "sha256-kLgt/UaNJI+TFpezw7MW7IL1RP0YzaKQUYJOJUg7seM=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.16.1"
      "sha256-5rLltmKgeOnGH55MYyuQmrbP5FviwThrBvcO0mOfGMQ=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.16.1"
      "sha256-BY8MpyHNLxBpZ0OWr5AmbHlk+u5L17wyjSYSgbI5bqw=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.16.1"
      "sha256-HvWU/b4lha09YT94S41j7IU3APvEQ8AHv40335i5eEs=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.16.1"
      "sha256-cfKC37+KbRhcw7R5pOFreXiumArbkBxAlIyH0NEMA7c=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.16.1"
      "sha256-tOUjZIuGSO0+5zCB3kcl5gp/VUvoySBKH2X4IJ3QGDc=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.16.1"
      "sha256-mUwAj57JC6S4YKhK+7voWydirM5Ig3gUnOgyBAGZ0n8=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.16.1"
      "sha256-9s5M9A3K8aAnFDFzCbUrNbFgOVe+VnkFXJSw05j2bJc=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.16.1"
      "sha256-RGyytY0VMq3rRPIeGB1UVObl21d5rd8ZBYq6sn7KZ+4=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.16.1"
      "sha256-98uCGqdNbHOoe+AOIchfEnOI1Jxg97DfEzQJhoBCXdE=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.16.1"
      "sha256-FGWWraJJ5PkvYK7Tv8GIe7Ln5aBZH90Tl8U69ixlrHI=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.16.1"
      "sha256-Z36SdWkXQqQqWk3VTJSJZrBQYHF+SUXWH4AoPPtnthc=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.16.1"
      "sha256-I751OclOawiCcZjvifZnVYDTRS3bttn9HMBaVr4Ow78=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.16.1"
      "sha256-Gv2O3KCNoJoMY+2KjW1yqwiP+Ku64K1OHtDlpj+W76w=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.16.1"
      "sha256-a7e0BgCM7n3HBL3dbPm4sGQI/KsuNHAd4uqsa9lpjZo=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.16.1"
      "sha256-p2ChQIiY3TlbfOKf6VyVkmAz6A3zlrHdgDeQzViWx+I=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.16.1"
      "sha256-xW/nPikzNXyYee9w81awCAH7aDfQY0VLbptzBwGgB/I=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.16.1"
      "sha256-NBi0x+5EsTimSBuZuIAkLs+kYqHXXfwOwqEeIyAPXz0=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.16.1"
      "sha256-yU0ok+wHBawttUQx/yqI70HvT350ZJhNh7Lfjb7sdMs=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.16.1"
      "sha256-6A8bVHd23CKrxETzWf2RFTCWmtV/GAzGuiXObGIdgHY=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.16.1"
      "sha256-qxLF0Of43t4mRbwQkhiSsl7W8SntzGDueP/fiMtILPE=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.16.1"
      "sha256-0YH02mZxxUfSjOihy9DmruCtphraUa7rRXKuFnmw1ws=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.16.1"
      "sha256-HaErMmxbja+1mwUhtXFKEJiEc8PEC9BHMWibfainG0c=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.16.1"
      "sha256-l+c0pCYaHEfRRGCr/E/oK0VcD8GK4giuv/LNdyplu0M=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.16.1"
      "sha256-3BOEw3LC9JXESrw3JEkjqHH0OkOknc1pWCMmJ3oie3Q=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.16.1"
      "sha256-d2ADgNp+uO6oa0OzFFtUy0YLmZVdGqQfOyMqB5/gUqY=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.16.1"
      "sha256-DkqFfCUKck4CFle4uzCYnqEQYqKgckyzXYDDUio36KA=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.16.1"
      "sha256-8E9GFagIDK8KLWttoUYL57Jss5A3mEC7DDGckvt/vl8=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.16.1"
      "sha256-fMlkj46uOVezpK34YwFykEMFyWQzoP1TyNZ5H6cuEM4=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.16.1"
      "sha256-JKU6ITkGeXWua7E8Ub0YAXtwR3XCrxxbAY2UC1Yu4cU=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.16.1"
      "sha256-7k+fV+2I33Mg5oBnuZye00SmAGL1aI5Xno1Vnq3TPFc=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.16.1"
      "sha256-c7GtCY9AJ9YsBVMeUss+wgXtV3VfMRfMJKUaPPNlmuY=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.16.1"
      "sha256-WL1xPdyhzHC9luD2VFnwNJ9IxBNB+H5PURJcEh69N6M=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.16.1"
      "sha256-JTXWB/CJTEk14kmYzN/FlNF/ITWZQ9sh2Engdw/V5zs=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.16.1"
      "sha256-OYwHcxvDsMjOC17v/Mb9t6IKkzlhwj2H7V6DWehtauU=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.16.1"
      "sha256-4tHIOsJ2Ih3hS+RB06msDfzpSuM0MGc23uD6YiVg/pE=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.16.1"
      "sha256-50acjssEPDW4DYBehUUWxCG+giNL8+l+JQ9rcvCQOCY=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.16.1"
      "sha256-NQMyUMf4ID+dK/RcJ65J7nQNN46eGQlIvWTK2Piinz0=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.16.1"
      "sha256-XqN5khInF+qncJIzl4YMM7M8rEa8FREoLbWOLPpcvow=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.16.1"
      "sha256-SJxH6EjwfZKvwJVkdTW8FjbKREg0iJxOUSPtCwNhlko=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.16.1"
      "sha256-LepslRAdneYZPVNQiEmausD/Y5/HMOfkAPXmhIjIw4A=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.16.1"
      "sha256-ITXiWy7GzoGEKHFb1pajCL89GVhnBKtDWcj43qhZ768=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.16.1"
      "sha256-fnMIvH9unMz2uPKMefD2ABw49WthI8X5ktUNheRlGyk=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.16.1"
      "sha256-wYhyn4fR+oSsgj1qtwLuVushIqfJONFG+evhjjDdeoQ=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.16.1"
      "sha256-8fqmuqJVMSLf3UxF6FlTKz6WxVclWdVjnVoEJhaAzFQ=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.16.1"
      "sha256-4fdlZyp99nR6m8xXQow+CeFbigjhMRJ71pMFL59hDU8=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.16.1"
      "sha256-TXBsGkcd00IagtK2hQzhZRs7Qn+OiQRzRAKXJgnGegM=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.16.1"
      "sha256-B5KJpsnTZXcyvrg0WuA7e/Sf3/SILXwh1lWNl0guihI=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.16.1"
      "sha256-mfFLAeofQRQ9uGK0aSFj9AybPvm5zmCEvCw7mP64ceU=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.16.1"
      "sha256-qN9vtHX5Jcv7hNjwuDMQ4C48pux2YsEc0ShqRTxiXfo=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.16.1"
      "sha256-4aKEcZRzPFgSYSLbDcQmkVXm8sEJWYQscZoFXN/F6YQ=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.16.1"
      "sha256-MOue0b/CZzmpwumQjscBNhtI05S8MH4t/Ep9B/z0gcs=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.16.1"
      "sha256-XWGeB3l6jywfCKyOl0LDXwwV+gAeDTbRK1FoOEgYC8U=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.16.1"
      "sha256-2MPirVdqF9rhH1TurPfhCLXNI2a4rFGiQwuhtNYycV0=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.16.1"
      "sha256-UaQJVu8lq94VLhHhHehdq0CqsnOfUoFxsvB3zQx9OBQ=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.16.1"
      "sha256-PXzLUMVV9FtgsPld39JOR9tiCaJ/zO+QasRRPbsqHrY=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.16.1"
      "sha256-HcT1N7yWdiTZ5axgc9U0MU2QzO922znwzOWxbMWU0cc=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.16.1"
      "sha256-cUhEBnHa/+vubDSejTkUV8VsEAno3/6I5HSZaS1vVUY=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.16.1"
      "sha256-Lg+yns2Ca6XTbFt7ilfgfF8zgfw6bfh5YmJleY8pReY=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.16.1"
      "sha256-KWFHRAtpeKXsAqQ+gGuaEwkHWAWpAM1Jk6S2zSZ5gyk=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.16.1"
      "sha256-gnQZJMw+Q37B3qu1eYDNxYdEyxNRRZlqAsa4OgZbb40=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.16.1"
      "sha256-qK5dPunPAbC7xIramYINSda50Zum6yQ4n2BfuOgLC58=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.16.1"
      "sha256-/SzlFsNAYCT2Dpuwti2VU/Qmjh/zOD24Mj2yv/c7S4Y=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.16.1"
      "sha256-C9/nlBKbhkm7dOwEQraKJrfs0ZgXx9yOhgcp/gVXVQ8=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.16.1"
      "sha256-9S8qVLbKla8BK4ZVRa815xMt76mfrGrNQmWWJfFxEZ0=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.16.1"
      "sha256-0lbWstRe91rwAthi4sHpO6QaEuI4DPy7uyeaYlryRnk=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.16.1"
      "sha256-DdFKieL3fcnbmy3j1uMSLw80N+ZU4jigBwja2SWpLFg=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.16.1"
      "sha256-md9B6RN+LKtkkWKKzlzPUassufTBmz3ww5RI/T5Q/aA=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.16.1"
      "sha256-v5e5eOPveetJZrir0l5nEvpo4MtHKPiRUxsSswmDVjk=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.16.1"
      "sha256-akB8q2KiKOJEK7weBOn5KUil1zx5o+GfCEVq3G9ufXI=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.16.1"
      "sha256-A645c5umplXed8TcsNia5k9BNH///DuysP4xE1BYOc0=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.16.1"
      "sha256-yO6MWhShYoWnvTRSLLzo6BCWQrgDUdr764Z66obaOIU=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.16.1"
      "sha256-UHGD+3lA/EAGKIKeygI+0H6Q2Dz1pylT23j2gBFpPJo=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.16.1"
      "sha256-aTDfSIBRk9hvU8mW393bQA/p58p6LBe/R1+YtbzyND0=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.16.1"
      "sha256-XxG2avjxD+pnvODRqznDHzZmaXZvV6pHUlGKEZ878pY=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.16.1"
      "sha256-T09T8BkiaRNW9HQAIYc1PsXLaOVp355Fg0d1CJKftjY=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.16.1"
      "sha256-7U8UQ8H1OSObb9luFZTgzHiBsQKGfxsp6ZSns50fvWw=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.16.1"
      "sha256-vzID2ETp5uXEq7/Q2OXIerSeOkRCBdfuHYeGv0cGrcM=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.16.1"
      "sha256-TyZw3OsFIleQHwElrnsEXQJTutMNFyCaLlyg75PehVE=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.16.1"
      "sha256-K4/qZ286Ep39eJvxBXB5o9/+gtqCZB1JYEOLMZg9A/Y=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.16.1"
      "sha256-qyxXeqeLWXTAiuGZNpPEWX8PXg85mqI/DK5jjutv88g=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.16.1"
      "sha256-t+JTpTwU0WeHa4F56GyoAbiHVy/bdq6T0NRiv3ujrPc=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.16.1"
      "sha256-SCBjbo/C6TlXDK6b0lkh2Nkuz+7j4vhQAUfgsIWHOvw=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.16.1"
      "sha256-E4MgD5vbW8Xx7xzhQrMQzBDgfqSMHa0Iyny3THWYNu0=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.16.1"
      "sha256-zfmjKO7UBy//w/iOsOpmry/z+jxp9B1pAIZkr63m2oM=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.16.1"
      "sha256-PhTGa+fyZ6gQZ12YVqavRdUR+32roQHZmX2uogwKTk4=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.16.1"
      "sha256-4fBFmdNcipHdvBoQ/SVbCJUSUk17srJegwa1b3VVokY=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.16.1"
      "sha256-nZPozPNXwCB65twSH8FmulSyvptAxaX0+cu5tyFSE3o=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.16.1"
      "sha256-fGOH71oxNS+a6YX1T0DR9h0z7xSw3oybz/kLEuRfjXo=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.16.1"
      "sha256-u3BbPUNjDxjsWgVDVKNuaPF9bC34x/a7VErO8/t7TeA=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.16.1"
      "sha256-TWj53shADVKpmaZNRTHdS1uy7x5wJO3sDGI8pbNA5PY=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.16.1"
      "sha256-jaFt9v+El5lIM1bE1vygh/M+FLI24fBfYKoL0FT/13A=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.16.1"
      "sha256-8v8UxJfVQwr2vcYP1jNUcOd4JTy7I0Ez1XYftiVRivk=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.16.1"
      "sha256-jwQIimOO4KpnGBDgW9b1zl7RHKqA8fUdUclMy5lbtjo=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.16.1"
      "sha256-wnklTEXuuO0yVZLWv+alCLo87mRMgZhK7WMffj5KRVE=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.16.1"
      "sha256-187pvk2L2tHEj8YXBKi8PwitoQcDZo0N5nFILQJ0muk=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.16.1"
      "sha256-9kkKsFhu+Zqd9DsoJCYFfc/9I8ND+UkpZlRpmB6QxLw=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.16.1"
      "sha256-jtJcRV8VhGsM9aLtoZS32elM9/2cgEaclQ6oppsjAiM=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.16.1"
      "sha256-TFXVQXbYxzQWZvVOPhAvNiZImeNDe3J4haZ2glufefE=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.16.1"
      "sha256-R7thWsBK2ia6YgEBC9/K7vr+0YkHjLQQ388I+8skMlM=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.16.1"
      "sha256-ZZSEoBpE/dwn8cvwviQfwxTJHl106OwRlNs4bs6akro=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.16.1"
      "sha256-8jG1DIoMWld5Z5KFtDiME8jBfmKN5V5LF8d6vCLroXg=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.16.1"
      "sha256-lvdjoqrXncqUQoGVU9+snFt8L4T2EK5MPOflZTnYXrc=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.16.1"
      "sha256-5/jWon55MuqhhCROVnmh5mDfxN5rG8C9KA3lJNVAI8I=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.16.1"
      "sha256-V4CJHKfrUQ3H2r2eX2q1Wv3i07hAMRicIYcu6PyPHr4=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.16.1"
      "sha256-pkSqFV1IYCI4qDR4+aPdZwRtELfpNrATolGiaZqxAiU=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.16.1"
      "sha256-f8XoLNsBYw+ZH6nQrFP7131arQMvuV5LySQ20bEH/NQ=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.16.1"
      "sha256-mruK15BIW66LQ3pyph+7MplBHpNSSyfviXc6N9RL7w8=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.16.1"
      "sha256-49vF+m3w64QG3fXIyo6jjO8NvqbfZZIYI5odJsP4jHQ=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.16.1"
      "sha256-7BXvNNzCGNbHV8QCBn0qJBIeugMq/n9+c7Dy4xZZdsQ=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.16.1"
      "sha256-ys2Mlp9mT/hoqlqXSYznTBDZAsWjGVPI2S5LbJk6xVQ=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.16.1"
      "sha256-x5hp+bfwtrL1iu7sV/UPNK8My7ZmL8ZHoyWjgpanhc0=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.16.1"
      "sha256-rpgZr0lkmz2PTCMo9JYhcU6Z+fFfrJR9mfnRkb5uNzs=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.16.1"
      "sha256-EUikizS09eZ6YdXHK/QLltc9QZuT8+BgQ53LRJtt4Uo=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.16.1"
      "sha256-LVq/ymHNH1PXia8ZD7zC2ryYLhv2yAbzFqyvo/AAOrw=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.16.1"
      "sha256-3uiLDtVf2e2yXJexXmQHJda9HBbcStVwKmoYF4pZ388=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.16.1"
      "sha256-5XmennLwXBdMZdApboxz9WcwYYBeEdu7PHW/ihkQf+4=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.16.1"
      "sha256-3Ky9qTwsPT+jMutetSdxirtF175242GgFnHgnuB2ldk=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.16.1"
      "sha256-bjE1CahBugCXPJ6nGPerdOSnB8GrItKM05w7gTqvAMk=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.16.1"
      "sha256-cVGONW1ACuWVHxHlyBiCOJLUdUpYcbZ71WvxlOvcMV8=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.16.1"
      "sha256-FH8cVwDCTbF/7JUAvkauKUZPsS/maw3Zr8IUgDOk7nM=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.16.1"
      "sha256-lmw0wl3CSjxYrnpt5b6iTmh+GjY/CTnSmw6HTM3cguA=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.16.1"
      "sha256-MA1mAohwmbCEortzrIfjSZABfAZiDShv2vPnGzWbnpo=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.16.1"
      "sha256-mkODTF7Mjv2ydy2aDlpPoZ1SVDdSmlBnLIDOtYBmHhU=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.16.1"
      "sha256-3llqTJ5ktjYgpN0LKNNVFZoQgNXsnRbBwscQX9N4ZiI=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.16.1"
      "sha256-q46+8nuKTZWSwCp/5M2oPlUB0fZr264S8u+I/hlLn6g=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.16.1"
      "sha256-laTIn22OOkhgKqbSTfGzsxxKD5aHQXeOtnMCB7e3TjE=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.16.1"
      "sha256-+491loQgRLlsayvLWM1eWrJcXJzYdOt9E44kNDX8h6E=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.16.1"
      "sha256-O4iYWxuSmoP2Nn/nP3u4b//LSzNtAhbyTuZUUS48VXc=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.16.1"
      "sha256-aw3s/NCWMpK/EooplJf2vvp+DTfvPbnnaAu2zFbX1ag=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.16.1"
      "sha256-UYLMBxfD1tOiCx/UzV5R51SF+cRVdJSgMTBcXZAxv9s=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.16.1"
      "sha256-xL0nYQV4PhCZPHAj5Lf1oo3u3YucciY7+/SE5NW2Zjc=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.16.1"
      "sha256-IBlBip7f9J7Vd+hIt6igqSo5GqBtPd9IlWi9w12cfgQ=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.16.1"
      "sha256-1yGvX/HmDH2Aaa0InThUARE3nMmnNzWUkgFgnlCA8NA=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.16.1"
      "sha256-QmML7TW4TeLzZWAkpk6TvdRBYaAx1EPrGf1D9DpwNbQ=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.16.1"
      "sha256-ksMaFzQvX0DUrQBRXiGmV00HKctkAmymCne3pr2S7Fk=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.16.1"
      "sha256-4yhU0DZTVP3rZn4tSh81KRmk3OKvXRKaps/YDqOM6GY=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.16.1"
      "sha256-5L3qpYKseHP8bBlLmPrTYnML71Tx8Vr8lPBxqg9oUGs=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.16.1"
      "sha256-4brOphfeYakyImKhuVsJDCLIsf/QqcbB3BkM9nq94RE=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.16.1"
      "sha256-IxvV4r5sba+0ogasHpp8rNOzHJZX2Xv6ivMrb0crAGk=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.16.1"
      "sha256-zvqcYN1SXpueqhJK+IChNcAbxb2d+Nl+Yuu9MsCjbBM=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.16.1"
      "sha256-vE67UKA6Wd9+i2jCwZ/sUcErKLMpfMBqT+LQDgatR+U=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.16.1"
      "sha256-SLlapdT6NvEqYvY3vPg8TmSlSWSx8dIM1U2K1c3mc8w=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.16.1"
      "sha256-v4ar6EbAVaIdp6buEo+GpoPk21QtRX1c3TFkALkjzPY=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.16.1"
      "sha256-tv5uLKOVbCfvPohKMtUhuuFlayunkHoBM0vuKrRwbFY=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.16.1"
      "sha256-QOFs7qfnfD+IEjrzoKqCZC3rpkMGxk0wSrBiH9RQFw4=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.16.1"
      "sha256-FGdLeG2t2efnLEwQJmx5hWKbX1ThqgSGempO3tXIxsE=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.16.1"
      "sha256-B4DSmGPUP+7N0JODtQb0izvOnn7KcgqCot5x7rkZZrQ=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.16.1"
      "sha256-fuZptCJ51KTqUNM0FEI3og7mN2yLA2EgW6/U8oWAp1Q=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.16.1"
      "sha256-t6wwCaST3J+l/3MAujho8JIOS8tXqPWF7hNiH2vCft8=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.16.1"
      "sha256-1x7ibRmIG2jpQ4EuC4qAXLiK7hylaHAtGKbxc8IooDw=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.16.1"
      "sha256-YOc5hTN4gJV8QobfJH7y7nPSSCxqKXr7Xml0ixw3B5U=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.16.1"
      "sha256-tztZaEuiaOgi2hl3LmPheJK01jMxGwaLwkOPqFQfFMU=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.16.1"
      "sha256-n1vENl5V9B926RatEa9m1yArpXWdT6rdWcgXFapHGyw=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.16.1"
      "sha256-d+v17F/vkCsLqrwFmliiclpMAHbqAhxqehQJbIiTou8=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.16.1"
      "sha256-YfJJH61k+YvYXAHirbEjhQbqG5nTatopS87Jh4o+2LQ=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.16.1"
      "sha256-aENtnm1E7/aDlge+8oJEW/R+8pInuMokgkXXYV56EQg=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.16.1"
      "sha256-VDghzaS1OLVuFc8HXlzU/oFdb5P/z9oUhmLxf2oi7oI=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.16.1"
      "sha256-i8neWOsxMMFwT4AL1lrrUeKDWNE0CGSTBrIhwO7oqAg=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.16.1"
      "sha256-ZiJuYRH5ku0lhl37aDmjNazDSl3+3fFIlj1KWJLZsc8=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.16.1"
      "sha256-jeZHe/tQywrKw9V4giu1Sw2sO5MC7QP0p1d/yBBe4JI=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.16.1"
      "sha256-a5tFB3Inekpy3Qoqx2CA8vcufyUihKiJc4bjPIgrB/U=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.16.1"
      "sha256-mj/9WGvZhqRUiX8O/DCqbAGgpWOfuZlJnwwmlsQ6b54=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.16.1"
      "sha256-6biGTU3zWo6PY24wBEouhHyn0lgnKHK8p1i/u39huXQ=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.16.1"
      "sha256-9N75BmubyH8fahPAgGvX5Z9q5K1/dHLXgeJQr4I/PsQ=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.16.1"
      "sha256-XoFqXVAcHkwGnJrmyo/OC8s8GqgtN17TkE1wyAvImgo=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.16.1"
      "sha256-wukMBQs3Z1FI2QqcV358Th0tDOKzJaa1JCobGRfiBX0=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.16.1"
      "sha256-t1itcHl24a3120eocO9C+6qY0kOK1Fy0TxUy/0Km5aI=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.16.1"
      "sha256-18hP25l/g8By2PI5wfULcpPhXUiS5P1CvrxSk44JerQ=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.16.1"
      "sha256-2WLBSObPlnyERUPM59cKhbGtkJS1vugteK0kEB886fU=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.16.1"
      "sha256-/O7ZL9BrR7gdBxZTpVvL/nuQOfXJ4i2t4cSOCTXAMvg=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.16.1"
      "sha256-RL/dNDiraCjK7mgitpfM04PVDH0+kpIvjC8/Rbn1KXc=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.16.1"
      "sha256-vcyIxyRkfL53xIKPzTdN/pv1Hv3qMighe/LPxqhcJCU=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.16.1"
      "sha256-BkJowkEc334bBLleHDSzlGRkKlkmfd0psdpR02Jwi8w=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.16.1"
      "sha256-L+v+mgbZnFyC+JfcRZV088JjK/QeqOqT1oAKNTVAJZk=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.16.1"
      "sha256-7EwPLXpb4cFjiPh4pWvbNwR7FVjs5xqjIbQ8J+MVzUw=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.16.1"
      "sha256-EHte9JHOLsUGf2THO8xSjuJF+TiLYdfg9Myg0UxLK3s=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.16.1"
      "sha256-+QmxEY54UXCzawGyPeZzt+ryzZFVWOl+/8IEpBhaRvc=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.16.1"
      "sha256-XvWfZl2KTzGnNHV78DMSde0QYYdz34/QEFhQxQo/3MI=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.16.1"
      "sha256-ypuAMi67VyU/ZRNrF2eKnsginv6vq/PCx02Tvgr7ejc=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.16.1"
      "sha256-2sH0JvpOoPqmbdPwK5+ef5SaZrUOjNHfKt557X4w+zU=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.16.1"
      "sha256-gQwxTpYlGohjSP6Qbi98N+CqAWTDOXm/ttZPDXa7P+U=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.16.1"
      "sha256-WvG+1+JhAqWzWYRJkG10dWQgC5r3Pnc0DlRgf6HGbIc=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.16.1"
      "sha256-eYDJ0liyThpKd6uOiYrGwxLPeaHoHY+P/vcYr7DUhYk=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.16.1"
      "sha256-1AQ9hZs4jkAHRheiCbz+1nfgZkvYSMCO9bl0oJEtBl0=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.16.1"
      "sha256-HerFjmCshovEMC7lat+NnY0Qges4eL5i7wLKhf9KOb8=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.16.1"
      "sha256-i+zk96mqcppXytsrLOJCWk+InoZRlIibyoZV7mFDcbA=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.16.1"
      "sha256-GQTLf7dK0fus+OKCvqdQIWCQSnUSWkOD1lVvG539AAU=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.16.1"
      "sha256-8jm0LUR69xbuNjKLThUDSx4hpLw+SkcVOTsELMX1BQI=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.16.1"
      "sha256-hJveBWOTcmpG5V0jUKrA6ZxZpatVYI3b5vicnyxyINk=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.16.1"
      "sha256-NaVi32E4saPqBmA0rqKDh1MVcVgVarrEa2Y1SZrEVs0=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.16.1"
      "sha256-7vHiGHR8mPl+7P+0/sn+KIw6gtS4TvNsoL9KtEBQY10=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.16.1"
      "sha256-sV7mRhAIbl0QMuaRe4Vd6nbnUwZgn/iM1InQfctgtSU=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.16.1"
      "sha256-K6TiK8J2O69DhV09CK60h8e1IG9UUHMo7rzxbKg/LKA=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.16.1"
      "sha256-jbhXPtZZtpyq9PT9dmlG5+JRBiwWHEeKyxYXxc1c+hI=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.16.1"
      "sha256-yzKvSHy7X473/IUPBR6Ur/ZgQ6Cw9lQe2YQ/m0WQY5o=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.16.1"
      "sha256-cAU3EQ3N75SSuatzKnpdEFwJf1bBiUost3Ue/Faff3g=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.16.1"
      "sha256-qU2jK+H8a/9aqZsgfR3jwzrf4aHC9d0JZECG4O1T5z0=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.16.1"
      "sha256-fLYt7pl/seSEgwlasnERG9sSqHv1VzezVtBVAQnY2xQ=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.16.1"
      "sha256-2hTIRUWQAerrbd3B8ixVZd75gMbSD9R0KItNNx2Jj1g=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.16.1"
      "sha256-uFXrKDzWTRToAtMrhRc96tK2zIcCnCD+StgXumBrNOI=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.16.1"
      "sha256-9aNpePlXBw8YcG8NoKg4Eopg6D328YJ1iRPmJnrPYcQ=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.16.1"
      "sha256-VmUefYDP5+nHJEFYucUO6LZxmrO2WfET3ktvtWQ6aLw=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.16.1"
      "sha256-X1lw2GKNyVH+Vkc4jcEjENQnIrp2nr1QXE4q765Dw70=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.16.1"
      "sha256-nZnYH9igfqqpOsYB2Pwpgq/e95Poyyn2KeE4O1DNt24=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.16.1"
      "sha256-p43nokMEDMos3HUkFQkQXfIXasqhNDkuWI/f+NMwP1I=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.16.1"
      "sha256-MYUUxkg4ttefUYHY818nmg/hapMWgWucGEZLFTiFOvY=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.16.1"
      "sha256-2NoNdPuoyfCbmKjUv/VWRKymGBlqlRDHkWakZ56FMsA=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.16.1"
      "sha256-Dzqxlf9goRR06XDZ9vAvKKCl64xkSeu8Qr4qkAkOmD4=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.16.1"
      "sha256-65YZycYxHz//YA7w6oHyNEb5oMSC1Duyeze/g6H0WXM=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.16.1"
      "sha256-T0j5ggKTmGm4GIszWE8jOWWRWpvsaQ4WQ2c0D+lesQ0=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.16.1"
      "sha256-eAxhBnVrlQLx0JofXpxiJ8k/Ni8AYGR9Wo8bHfuWRzQ=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.16.1"
      "sha256-DzqktKnjsJJIJMsWZ718PxD/paVqsoq3PIW7aSQ6WWQ=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.16.1"
      "sha256-9ruXDDN7RGAJhAijFJUlHrXZR5ke6Wcf2rCBcG+4dAU=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.16.1"
      "sha256-tVF/XBnqTelpgF7pakzPAX7UgeKM8jkzjZUzB82pOPY=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.16.1"
      "sha256-qsgronxbNo6gfK50e800MK4bkQOH8qGoKrR38Q7YgJ0=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.16.1"
      "sha256-ixxZIWxp8sKenZES//hfCv76uRG2h2Y8EbjU4A46/9Q=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.16.1"
      "sha256-TV3mRzlOpdqGQBhVKEsU8CTZdST+O//l+sS2QInRfrk=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.16.1"
      "sha256-K5/5swB+ThHs1GBgXNDuk2vBtgJllSbau4/2N5qgcqE=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.16.1"
      "sha256-Wy/5SvDO5r87WHuyDkaqIu2m3eatN1314KBEIyx+YWs=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.16.1"
      "sha256-qY7dVvxERG8rWyik55JM7N/cL0JlmgPcpvpoVG2pdas=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.16.1"
      "sha256-bsgzZLxLU3PgMVYAF051jRkayTOTLC+Eje+eFVYJWF0=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.16.1"
      "sha256-6JU9bsrHj40YMCQZC10vCcLvh5qAUVxev2Q7zISofOg=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.16.1"
      "sha256-QjRBD92mNjG3WGk1wqFtkleyXLBESEnaGtpl8X8pVhc=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.16.1"
      "sha256-+yKFTwSOsTlJODn4GA5IVQLUMb8ioetQv5K5Gb9ZDd8=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.16.1"
      "sha256-HVoAOgp4pJxfqLpncjrwh/HZnLWKtr+8ZLbPmVjj/Ss=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.16.1"
      "sha256-gYZTGKnMTTH9Nxq2mmfFaX0z3IlorHYBf9kgDc4TSF8=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.16.1"
      "sha256-lrUPH+M6Vv9zz3GxuWvkQZXk6btV8FeaYROEnNyvcp4=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.16.1"
      "sha256-ZSPRkJ1fa+ASYS0EzAR+W+qmeAbKL+arT0o4K3oVatU=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.16.1"
      "sha256-GzA6OMFnXCQd4bXaKJAgSS5H7r+J6HK5hqo9mgFAKuo=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.16.1"
      "sha256-l1hiBamuX5dpyB1eivnrmL1DTkS+LRHXMnJb1ZdZGPk=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.16.1"
      "sha256-bXn6DKlpB0q+i/fdcUMMET+R23uq+H+xzFaD7eOwX90=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.16.1"
      "sha256-dcKknFpinoHO8JceRRmzUdraPNvxf5Yw8+652S1IoRw=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.16.1"
      "sha256-FAsgN/gMB3rP1k8jV477V3UIzP8p/QwLsVUOOxOBcrM=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.16.1"
      "sha256-VO5+M6WLBTaQcubqT2Xqzfdfw2qBH9AbWhJJSyR78MU=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.16.1"
      "sha256-biyVdaW/KAElIfI52aANIYWZ+cBIGuIE/jWpmML33Es=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.16.1"
      "sha256-RIxSUfp+V8dcsckgryF4eXVxghFL6eOhHH2P4mDKin8=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.16.1"
      "sha256-cHEklYW+KogoXXDSxccf24UUGIUaMxbVZq9+QRlr8dk=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.16.1"
      "sha256-6hy6M802H5Q985rY+G5Rj+6VMxk3LgBsN3AmxZ6/jps=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.16.1"
      "sha256-/By9xH4mFqCG9S/2qrAEQzIq5n77PVTGKkwmGYBG2e0=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.16.1"
      "sha256-x73dVNp+Zt4agmarTvFFRghuzHbu/vetoM612u6V9fQ=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.16.1"
      "sha256-1uHhIw/p5Vd6BloaUy0ZWcZltHLpFrjDzsOdcVqOK8c=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.16.1"
      "sha256-Lp0F7xFOvn6CbcGeiw9zrNcn12zdgQFnSzYHgnFLsvs=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.16.1"
      "sha256-Len4reIJG0WeQDbzf0f8ynEIb6plr/xe667oThy5gM4=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.16.1"
      "sha256-9CLPoH+kR+Mci2egJwKC9vBYVTDVzYbiT/rQSE5zfDc=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.16.1"
      "sha256-HvYVVBrXRTalQXYBhgKb2Huf7pxWcfnYoZblUDr3jRo=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.16.1"
      "sha256-cEBirPszsYkZAVdWYXTi2dN07lcylijHGvL5p1/LnQI=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.16.1"
      "sha256-GgcNkm8r9u6QwVw8yqKOPLqanOqUVvrcKmc9WkEcdaU=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.16.1"
      "sha256-pFrdCaDE0b9+7d55AMi2JVV/kGWgKUMtsOVoq2Au5+I=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.16.1"
      "sha256-muJRy+MxIpmbhm0V3apUwVpDuS4GuSMEraE+2gq2WzE=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.16.1"
      "sha256-oM6ciy3iJ1wzAYeA/M9dCkwvgCyMHhkLVtBxH8jGLCs=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.16.1"
      "sha256-h6oeyfJ5yChzSMJQ8yeePrbVzhwZQt3oWsf6Pe1oOl8=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.16.1"
      "sha256-hplxKUwqV2iRmocLnNosy4ElDdAoCt91IQsCC7P/dL8=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.16.1"
      "sha256-EuL90z0MUUycZ99Ivsxk6Fy0QvAuCxG04GznXO1rItQ=";
}
