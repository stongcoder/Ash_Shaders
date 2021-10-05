using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScannerEffect : MonoBehaviour
{
    #region ×Ö¶Î
    public Material mat;
    public float velocity = 5;

    [SerializeField] private bool isScanning;
    [SerializeField] private float allTime;

    private Camera cam;
    #endregion
    private void OnValidate()
    {
        cam = GetComponent<Camera>();
        allTime = 1 / velocity;
    }
    private void Awake()
    {
        cam = GetComponent<Camera>();
    }
    private void Start()
    {
        cam.depthTextureMode = DepthTextureMode.Depth;
    }

    private float t = 0;
    private float dis;
    private void Update()
    {
        if(Input.GetKeyDown(KeyCode.Space))
        {
            isScanning = true;
            t = 0;
        }
        if (isScanning)
        {
            dis = t * velocity;
            t += Time.deltaTime;
            if (t >= allTime)
            {
                isScanning = false;
                t = 0;
            }
        }
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        mat.SetFloat("_ScanDis", dis);
        Graphics.Blit(source, destination, mat);
    }
}
