using System;
using System.Collections;
using UnityEngine;

public class Unit : MonoBehaviour
{
    [SerializeField] private int health;
    
    private const float HealingTime = 3.0f;
    private const float HealingDelay = 0.5f;

    private float _remainingHealTime = 3.0f;
    
    private void Awake()
    {
        StartCoroutine(ReceiveHealing());
    }

    private void Update()
    {
        Debug.Log(health);
    }

    private IEnumerator ReceiveHealing()
    {
        while (health <= 100 && _remainingHealTime > 0.0f)
        {
            health += 5;
            _remainingHealTime -= HealingDelay;
            yield return new WaitForSeconds(HealingDelay);
        }
        _remainingHealTime = HealingTime;
        yield break;
    }
}
