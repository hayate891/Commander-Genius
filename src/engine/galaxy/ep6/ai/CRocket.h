#ifndef CROCKET_H
#define CROCKET_H
#include <engine/galaxy/common/ai/CGalaxyActionSpriteObject.h>
#include <engine/galaxy/common/ai/CMoveTarget.h>
#include <engine/galaxy/common/ai/CPlayerBase.h>

namespace galaxy
{

class CRocket : public CGalaxyActionSpriteObject, public CMoveTarget
{
    
public:
	CRocket(CMap *pmap, const Uint16 foeID, const Uint32 x, const Uint32 y);

	/**
	 * When it is moving normally
	 */
	void processSitting();
	
	void processFlying();
	
	void process();

	/**
	 * What happens if it gets touched by another object
	 */
	void getTouchedBy(CSpriteObject &theObject);
	
private:
	CPlayerBase *mpCarriedPlayer;
};

};

#endif // CROCKET_H