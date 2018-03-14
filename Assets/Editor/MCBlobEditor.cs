using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(MCBlob))]
public class MCBlobEditor : Editor {
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        MCBlob blob = (MCBlob)target;
        if (GUILayout.Button("Build Object"))
        {
            blob.BuildMesh();
        }
    }
}
