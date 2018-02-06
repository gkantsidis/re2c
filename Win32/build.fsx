#r "packages/FAKE/tools/FakeLib.dll"
open Fake
open System.IO

//
// Properties
//
let buildDir = Path.Combine(__SOURCE_DIRECTORY__, "build")

let properties = [
    "Configuration", "Release";
    "OutDir", buildDir
]

//
// Targets
//
Target "Clean" (fun _ ->
    CleanDir buildDir
    !! "re2c/re2c.sln"
      |> MSBuild buildDir "Clean" properties
      |> ignore
)

Target "BuildRe2C" (fun _ ->
    trace "Building re2c"
    !! "re2c/re2c.sln"
        |> MSBuild buildDir "Build" properties
        |> Log "AppBuild-Output: "
)

Target "Default" (fun _ ->
    trace "Start building re2c"
)

//
// Dependencies
//
"Clean"
  ==> "BuildRe2C"
  ==> "Default"

RunTargetOrDefault "Default"
