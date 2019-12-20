#/bin/bash
# Copyright (c) 2019 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License"); # you may not use this file except in compliance with the License.
# You may obtain a copy of the License at #
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software # distributed under the License is distributed on an "AS IS" BASIS, # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and # limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
#

source ./configure

curl localhost:8000/api/workflows/v1/query 2>/dev/null | json_pp>cromwell_stop

diff -urN cromwell-monitor/cromwell_start cromwell_stop > cromwell_diff
count=`cat cromwell_diff | grep  + | grep status | grep Running | wc -l`
finish=`cat cromwell_diff | grep + | grep status | grep Succeeded | wc -l`
failed=`cat cromwell_diff | grep + | grep status | grep Failed| wc -l`
echo running: $count  finished: $finish  failed:  $failed

