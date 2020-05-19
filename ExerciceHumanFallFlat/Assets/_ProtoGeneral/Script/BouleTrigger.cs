using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BouleTrigger : MonoBehaviour 
{
    Rigidbody rb;

    void Start()
    {
        rb = GetComponentInChildren<Rigidbody>();

    }


    void OnTriggerEnter(Collider col)
    {
        if (col.gameObject.layer == 9)
        {
            Debug.Log(col);
            rb.constraints = RigidbodyConstraints.None;
        }
    }
}
