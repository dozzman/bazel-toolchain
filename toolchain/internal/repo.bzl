# Copyright 2021 The Bazel Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load(
    "//toolchain/internal:common.bzl",
    _os = "os",
)
load(
    "//toolchain/internal:llvm_distributions.bzl",
    _download_llvm_preconfigured = "download_llvm_preconfigured",
)

def llvm_repo_impl(rctx):
    os = _os(rctx)
    if os == "windows":
        rctx.file("BUILD", executable = False)
        return

    rctx.file(
        "BUILD.bazel",
        content = rctx.read(Label("//toolchain:BUILD.llvm_repo")),
        executable = False,
    )

    _download_llvm_preconfigured(rctx)

    # darwin may use local 'ld' so symlink it to bin directory to help
    # other programs locate it when called directly (e.g. rustc)
    if os == "darwin":
        rctx.symlink("/usr/bin/ld", "bin/ld")
