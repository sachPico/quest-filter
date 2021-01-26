using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using OVRTouchSample;

public class OVRVisionTest : MonoBehaviour
{
    public GameObject thermalLens;
    public GameObject thermalFilterDisplay;
    public GameObject nightFilterDisplay;
    public Material filterDisplayMaterial;

    public void SetFilter()
    {
        thermalLens.SetActive(!thermalLens.activeInHierarchy);
        if(thermalLens.activeInHierarchy)
        {
            thermalFilterDisplay.SetActive(true);
            nightFilterDisplay.SetActive(false);
        }
        else
        {
            thermalFilterDisplay.SetActive(false);
            nightFilterDisplay.SetActive(true);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(OVRInput.GetDown(OVRInput.Button.One))
        {
            SetFilter();
        }
    }
}
