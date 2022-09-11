using System.Threading;
using System.Threading.Tasks;
using UnityEngine;

public class Tasks : MonoBehaviour
{
    private async void Awake()
    {
        using var cancelTokenSource = new CancellationTokenSource();
        var token = cancelTokenSource.Token;
        var task1 = Task1(token);
        var task2 = Task2(60, token);
        bool isFirstFaster = await WhatTaskFasterAsync(task1, task2, token);
        Debug.Log(isFirstFaster);
    }

    private async Task Task1(CancellationToken cancellationToken)
    {
        await Task.Delay(1000, cancellationToken);
        
        Debug.Log("Task1 finished");
    }

    private async Task Task2(int frames, CancellationToken cancellationToken)
    {
        while (frames > 0)
        {
            frames--;
            await Task.Yield();
        }
        Debug.Log("Task2 finished");
    }
    
    private static async Task<bool> WhatTaskFasterAsync(Task task1, Task task2, CancellationToken cancellationToken)
    {
        if (cancellationToken.IsCancellationRequested) return false;
        Task firstFinishedTask = await Task.WhenAny(task1, task2);
        return firstFinishedTask == task1;
    }
}