using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Flash : MonoBehaviour {
	public SpriteRenderer spriteRenderer;
	// Use this for initialization
	private bool flashing;
	void Start () {
		spriteRenderer = GetComponent<SpriteRenderer> ();



	}
	void Update(){
		if (Input.GetKeyDown (KeyCode.A))
			StartCoroutine (TakeDamage ());
	}
	IEnumerator TakeDamage(){
		if (flashing)
			yield break;
		flashing = true;
		float t = 1;
		while (t > 0) {
			t -= Time.deltaTime;
			spriteRenderer.material.SetFloat ("_Opaque",t);
			yield return new WaitForEndOfFrame ();
		}
	
		flashing = false;

	}

}
