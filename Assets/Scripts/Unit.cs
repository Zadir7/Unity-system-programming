using System;
using System.Collections;
using UnityEngine;

public class Unit : MonoBehaviour
{
    [SerializeField] private int health;
    
    private const float HealingTime = 3.0f;
    private const float HealingDelay = 0.5f;
    
    private void Awake()
    {
        StartCoroutine(ReceiveHealing());
    }

    private IEnumerator ReceiveHealing()
    {
        float remainingHealTime = 3.0f;
        while (health <= 100 && remainingHealTime > 0.0f)
        {
            health += 5;
            remainingHealTime -= HealingDelay;
            yield return new WaitForSeconds(HealingDelay);
        }
        yield break;
    }
}
