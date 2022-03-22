using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;


public class PauseMenu : MonoBehaviour
{

        [SerializeField] GameObject pauseMenu;
        GameObject MusicToggle;
    

    public void Pause()
    {
        pauseMenu.SetActive(true);
        Time.timeScale=0f;
    }

    public void Resume()
    {
        pauseMenu.SetActive(false);
        Time.timeScale=1f;
    }

    public void Home(int sceneId)
    {
        Time.timeScale=1f;
        SceneManager.LoadScene(sceneId);
    }

    public void Music(Toggle music)
    {
        if (music.isOn) {
            //music on
            music.GetComponentInChildren<Text> ().text = "Music is on";
        } else {
            //music off
            music.GetComponentInChildren<Text> ().text = "Music is off";
        }
    }

    public void Difficulty(Slider diff) {
        int sliderVal = (int)diff.value;
        if (sliderVal == 1) {
            diff.GetComponentInChildren<Text> ().text = "Easy";
        } else if (sliderVal == 2) {
            diff.GetComponentInChildren<Text> ().text = "Medium";
        } else {
            diff.GetComponentInChildren<Text> ().text = "Hard";
        }
    }
}
