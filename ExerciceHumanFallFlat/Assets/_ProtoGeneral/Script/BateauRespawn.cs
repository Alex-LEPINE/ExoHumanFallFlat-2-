using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BateauRespawn : MonoBehaviour 
{
    Vector3 IniPos;
    Quaternion IniRot;
    Rigidbody rb;

    void Start() 
    {
        IniPos = gameObject.transform.position;
        IniRot = gameObject.transform.rotation;
    }
    void OnTriggerExit(Collider col)
    {
        if (col.gameObject.layer == 9)
        {
            gameObject.transform.position = IniPos;
            gameObject.transform.rotation = IniRot;
            rb.velocity = new Vector3(0f, 0f, 0f);            
        }
    }
}
