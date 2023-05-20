#!/bin/bash
# Copyright Epic Games, Inc. All Rights Reserved.

START_DIR=`pwd`
cd "$1"

IS_DOTNET_INSTALLED=0
DOTNET_VERSION_PATH=$(command -v dotnet) || true

if [ "$UE_USE_SYSTEM_DOTNET" == "1" ] && [ ! $DOTNET_VERSION_PATH == "" ] && [ -f $DOTNET_VERSION_PATH ]; then
  IS_DOTNET_INSTALLED=1
fi

# Setup bundled Dotnet if cannot use installed one
if [ $IS_DOTNET_INSTALLED -eq 0 ]; then
  echo Setting up bundled DotNet SDK
CUR_DIR=`pwd`
  export UE_DOTNET_DIR=$CUR_DIR/../../../Binaries/ThirdParty/DotNet/Linux
  export PATH=$UE_DOTNET_DIR:$PATH
  export DOTNET_ROOT=$UE_DOTNET_DIR
else
  export IS_DOTNET_INSTALLED=$IS_DOTNET_INSTALLED
fi

cd "$START_DIR"
