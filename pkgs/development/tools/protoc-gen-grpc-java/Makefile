# Adapted from https://github.com/grpc/grpc-web/blob/master/javascript/net/grpc/web/generator/Makefile
#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CXX ?= g++
CPPFLAGS += -pthread
CXXFLAGS += -std=c++11
LDFLAGS += -lprotoc -lprotobuf -lpthread -ldl
PREFIX ?= /usr/local
MIN_MACOS_VERSION := 10.7 # Supports OS X Lion
STATIC ?= yes

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  CXXFLAGS += -stdlib=libc++ -mmacosx-version-min=$(MIN_MACOS_VERSION)
else ifeq ($(UNAME_S),Linux)
  ifeq ($(STATIC),yes)
    LDFLAGS += -static
  endif
endif

all: protoc-gen-grpc-java

protoc-gen-grpc-java: java_plugin.o java_generator.o
	$(CXX) $^ $(LDFLAGS) -o $@

install: protoc-gen-grpc-java
	mkdir -p $(PREFIX)/bin
	install protoc-gen-grpc-java $(PREFIX)/bin/protoc-gen-grpc-java

clean:
	rm -f *.o protoc-gen-grpc-java
