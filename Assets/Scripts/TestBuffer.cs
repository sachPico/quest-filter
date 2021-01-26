using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestBuffer : MonoBehaviour
{
    ComputeBuffer buffer;
    //int[] bufferData = new int[Screen.width * Screen.height];
    // Start is called before the first frame update
    void Awake()
    {
        buffer = new ComputeBuffer(Screen.width * Screen.height, 4);
        GetComponent<MeshRenderer>().material.SetBuffer("ambientTempBuffer", buffer);
    }

    // Update is called once per frame
    void Update()
    {
        //buffer.GetData(bufferData);
        //Debug.Log(bufferData.Length);
    }
}
