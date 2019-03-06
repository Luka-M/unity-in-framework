using UnityEngine;
using System.Collections;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;

public static class Build {

    public static void BuildPlayerIOS() {
        EditorSceneManager.OpenScene("Assets/_Complete-Game/Scenes/Done_Main.unity");
        string[] scenes = { "Assets/_Complete-Game/Scenes/Done_Main.unity" };
        BuildPipeline.BuildPlayer( scenes, "PlayerBuild", BuildTarget.iOS, BuildOptions.None); 
    }
}
