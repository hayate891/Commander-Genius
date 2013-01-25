#include "Autogun.h"
#include "engine/galaxy/common/ai/CPlayerBase.h"

namespace galaxy
{  

AutoGun::AutoGun(CMap *pmap, const Uint16 foeID, const Uint32 x, const Uint32 y, 
		 direction_t horDir, direction_t vertDir, int basesprite) :
CGalaxySpriteObject(pmap, foeID, x, y),
mTimer(0)
{
  // Coding for autogun. It covers Keen 4 Darts in Pyramids and the auto shooting guns in Keen 5
  
  const int ep = g_pBehaviorEngine->getEpisode();
  
  xDirection = horDir;
  yDirection = vertDir;
  
  mBaseSprite = basesprite;
  
  if(xDirection == LEFT && yDirection == CENTER)
  {
      if(ep == 4)
      {
	m_Pos.x += (1<<CSF);    
	m_Pos.y += (7<<STC);
      }
  }
  else if(xDirection == CENTER && yDirection == UP)
  {
      if(ep == 4)
      {
	m_Pos.y -= (1<<CSF);    
	m_Pos.x += (7<<STC);
      }
  }
  else if(xDirection == RIGHT && yDirection == CENTER)
  {
      if(ep == 4)
      {
	m_Pos.x -= (1<<CSF);
	m_Pos.y += (7<<STC);
      }
  }
  else if(xDirection == CENTER && yDirection == UP)
  {
      if(ep == 4)
	m_Pos.x += (7<<STC);
  }
  
  if(ep == 5)
  {
    mNumAnimSprites = 4;
  }
  else
  {
    mNumAnimSprites = 2;
  }

  processState = &AutoGun::waiting;  
  sprite = mBaseSprite;
  dontdraw = true;
  
  origin = getPosition();   
  
  performCollisions();
  
}

void AutoGun::waiting()
{
    const int ep = g_pBehaviorEngine->getEpisode();
    if(ep == 5)
    {
	if(sprite < mBaseSprite + mNumAnimSprites + 1)
	    sprite++;
	else
	{
	    sprite = mBaseSprite;
	    dontdraw = true;
	}
    }
    
  if( mTimer < WAIT_TIME )
  {
    mTimer++;
    return;
  }
  
  if(m_Pos != origin)
  {
    moveToForce(origin);  
    onslope = blockedd = blockedl = blockedr = blockedu = false;
  }

  sprite = mBaseSprite;
  mTimer = 0;
  processState = &AutoGun::flying;
  
  if(ep == 4)
  {
    playSound(SOUND_DARTGUN_SHOOT);
  }
  else
  {
      playSound(SOUND_ROBORED_SHOOT); // Yeah, it is the same sound!
  }  
  
  dontdraw = false;
}


void AutoGun::getTouchedBy(CSpriteObject &theObject)
{
    if(processState != &AutoGun::flying)
	return;
    
  if(CPlayerBase *Player = dynamic_cast<CPlayerBase*>(&theObject))
  {
    Player->kill();
  }
}



void AutoGun::setWaitStatus()
{        
    // wait! in keen 4 it has to return        
    processState = &AutoGun::waiting;
    if(g_pBehaviorEngine->getEpisode() == 5)
    {
	sprite = mBaseSprite + mNumAnimSprites;
    }
}



// When autogun is waiting to shoot!
void AutoGun::flying()
{    
  moveXDir(xDirection*FLY_SPEED);
  moveYDir(yDirection*FLY_SPEED);
    
  sprite = mBaseSprite + (mTimer % mNumAnimSprites);
  
  if(yDirection == DOWN && blockedd)
    setWaitStatus();
  else if(yDirection == UP && blockedu)
    setWaitStatus();

  if(xDirection == LEFT && blockedl)
    setWaitStatus();
  else if(xDirection == RIGHT && blockedr)
    setWaitStatus();  
  
  if(onslope)
      setWaitStatus();
}

// When autoguns bullet is flying over the screen!
void AutoGun::process()
{
    mTimer++;
    
  (this->*processState)();
}

};