/*  $Header: /dist/CVS/fzclips/src/clsltpsr.h,v 1.3 2001/08/11 21:04:21 dave Exp $  */

   /*******************************************************/
   /*      "C" Language Integrated Production System      */
   /*                                                     */
   /*               CLIPS Version 6.10  04/13/98          */
   /*                                                     */
   /*                                                     */
   /*******************************************************/

/*************************************************************/
/* Purpose:                                                  */
/*                                                           */
/* Principal Programmer(s):                                  */
/*      Brian L. Donnell                                     */
/*                                                           */
/* Contributing Programmer(s):                               */
/*                                                           */
/* Revision History:                                         */
/*                                                           */
/*************************************************************/

#ifndef _H_clsltpsr
#define _H_clsltpsr

#if OBJECT_SYSTEM && (! BLOAD_ONLY) && (! RUN_TIME)

#define MATCH_RLN            "pattern-match"
#define REACTIVE_RLN         "reactive"
#define NONREACTIVE_RLN      "non-reactive"

#ifndef _H_object
#include "object.h"
#endif

typedef struct tempSlotLink
  {
   SLOT_DESC *desc;
   struct tempSlotLink *nxt;
  } TEMP_SLOT_LINK;

#ifdef LOCALE
#undef LOCALE
#endif

#ifdef _CLSLTPSR_SOURCE_
#define LOCALE
#else
#define LOCALE extern
#endif

LOCALE TEMP_SLOT_LINK *ParseSlot(char *,TEMP_SLOT_LINK *,PACKED_CLASS_LINKS *,int,int);
LOCALE void DeleteSlots(TEMP_SLOT_LINK *);

#ifndef _CLSLTPSR_SOURCE_
#endif

#endif

#endif





