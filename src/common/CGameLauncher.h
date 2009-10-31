/*
 * CGameLauncher.h
 *
 *  Created on: 22.09.2009
 *      Author: gerstrong
 */

#ifndef CGAMELAUNCHER_H_
#define CGAMELAUNCHER_H_

#include "../dialog/CDialog.h"
#include "../common/CMap.h"
#include "../fileio/CExeFile.h"
#include <string>
#include <vector>
#include <ostream>

#define SUBDIR_MAX      2
#define DEFAULT_ROOT    "."
#define GAMESCFG_ROOT   "&Root="
#define GAMESCFG_DIR    "&Dir="
#define GAMESCFG_NAME   "/Name="
#define GAMESCFG        "games.cfg"
#define KEENEXE1        "keen1.exe"
#define KEENEXE2        "keen2.exe"
#define KEENEXE3        "keen3.exe"

struct GameEntry {
    std::string path;
    std::string name;
    Uint16 version;
    Uint16 episode;
    bool crcpass;
};

class CGameLauncher {
public:
	CGameLauncher();
	virtual ~CGameLauncher();

	typedef std::vector<std::string> DirList;
	typedef std::vector<std::string> ExeList;

	bool init();
    void cleanup();

    bool drawMenu();
	void process();
	Uint8 retrievetEpisode(short chosengame);

	unsigned char getChosengame(){ return m_chosenGame; }
	bool setChosenGame(unsigned char chosengame) { m_chosenGame = chosengame; return (m_hasbeenchosen=true); }
	bool waschosen(){ return m_hasbeenchosen; }
	void letchooseagain() { m_hasbeenchosen=false; }

	bool getQuit(){ return m_mustquit; }
	std::string getDirectory(Uint8 slot) { return m_Entries.at(slot).path; }
	Uint8 getEpisode(Uint8 slot) { return m_Entries.at(slot).episode; }
	std::string getEP1Directory() { return m_Entries.at(m_ep1slot).path; }

	Uint8 m_numGames;

private:

	bool m_mustquit;
	short m_chosenGame;
	bool m_hasbeenchosen;
	Uint8 m_episode;
	DirList m_DirList;
	ExeList m_ExeList;
	Sint8 m_ep1slot;
	Sint8 m_SearchDepth;
	std::string m_Root;
    std::vector<GameEntry> m_Entries;
	std::vector<std::string> m_Paths;
	std::vector<std::string> m_Names;
	CDialog *mp_LaunchMenu;
	CMap *mp_map;

    Uint8 scanDirectories(const std::string& path, DirList& dir);
	bool scanSubDirectories(const std::string& root);
	bool scanExecutables(const std::string& path);

    void getLabels();
    std::string scanLabels(const std::string& path);
    void putLabels();
};

#endif /* CGAMELAUNCHER_H_ */
