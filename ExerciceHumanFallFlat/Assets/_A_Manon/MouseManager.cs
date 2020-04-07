using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseManager : MonoBehaviour {

	bool isActive;

	void Start()
	{
		isActive = false;
	}
	void Update ()
	{
		if (Input.GetKeyDown("1"))
		{
			if (!isActive)
			{
				Cursor.lockState = CursorLockMode.Locked;
				Cursor.visible = false;
				isActive = true;
			}
			else if (isActive)
			{
				Cursor.lockState = CursorLockMode.None;
				Cursor.visible = true;
				isActive = false;
			}
		}
	}
}
