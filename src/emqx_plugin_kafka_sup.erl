%%--------------------------------------------------------------------
%% Copyright (c) 2020 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emqx_plugin_kafka_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-export([start_kafka/0]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% 在插件启动时初始化 brod
start_kafka() ->
    Hosts = [{"192.168.88.100", 9092}],
    %% 启动 brod 客户端
    ok = brod:start_client(Hosts, kafka_client, _Config = []),
    %% 启动生产者
    ok = brod:start_producer(kafka_client, <<"test_topic">>, _ProducerConfig = []).


init([]) ->
    {ok, { {one_for_all, 0, 1}, []} }.

