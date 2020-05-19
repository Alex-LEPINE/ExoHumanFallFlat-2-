using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BateauRespawn : MonoBehaviour 
{
    Vector3 IniPos;
    Quaternion IniRot;
    Rigidbody rb;
    GameObject parent;

    void Start() 
    {
        parent = GetComponentInParent<Transform>().gameObject;
        rb = GetComponentInParent<Rigidbody>();
        IniPos = parent.transform.position;
        IniRot = parent.transform.rotation;
    }
    void OnTriggerExit(Collider col)
    {
        if (col.gameObject.layer == 9)
        {
            parent.transform.position = IniPos;
            parent.transform.rotation = IniRot;
            rb.velocity = new Vector3(0f, 0f, 0f);            
        }
    }
}
