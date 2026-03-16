//+------------------------------------------------------------------+
//|                                            Panel_260315_0350.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                            Panel_260315_0350.mqh |
//|                     Copyright 2026, CSticker Hybrid EA Framework |
//+------------------------------------------------------------------+
// =========================================================
// 🚨 [C2 절대 규칙] 0 = ON (스캘핑/본절)! 끄는 건 오직 'X' (is_x)
// 💡 금지 조항: value <= 0 조건으로 로직 막는 꼰대 코딩 절대 금지!
// =========================================================
#property copyright "Copyright 2026, CSticker EA"
#property description "🎨 [C2 패널] 렉 제로(0%) 하이브리드 전광판 & H(Half) 반익절 스나이퍼"
#property description "파일명 타임스탬프: Panel_260315_0350.mqh (버전 관리)"
#property description "**'X 혁명'** 표준 도입! Start! (H 스텔스 모드 호환)"
#property link      "https://drive.google.com/drive/folders/1bwB7EKOcvwpjJm7BDw0VU0-U0znlI2tw?usp=sharing"
#property strict

#ifndef TF_PANEL_260315_0350_MQH
#define TF_PANEL_260315_0350_MQH

#include <Trade\Trade.mqh>
//#include <TF\Settings_260315_0350.mqh>

// 🚨변태 배율 조절기추가된  8모드 테스트 인클루드.
#include <TF\Settings_260315_0350T.mqh> //'모드 재벌(만수르)세팅해더!'


class CStickerPanel
{
private:
   CStickerSettings *m_set; 
   CTrade            m_trade;
   string            m_pre;
   
   int               m_kb;
   int               m_ks;
   int               m_kc;
   int               m_ku;
   int               m_kd;
   int               m_kcl;
   int               m_kcs;
   int               m_kw;
   int               m_kl;
   int               m_kh; 
   
   bool              m_sdown;
   bool              m_exp;
   bool              m_drag;
   
   int               m_bx;
   int               m_by;
   int               m_dmx;
   int               m_dmy;
   int               m_dox;
   int               m_doy;
   
   double            m_vol_step;
   double            m_vol_min;
   double            m_vol_max; 
   int               m_vol_dig;

   bool              m_eq_drag; 
   int               m_eq_x;
   int               m_eq_y;
   int               m_eq_dox;
   int               m_eq_doy;

public:
   CStickerPanel() : 
      m_pre("SP_"), 
      m_sdown(false), 
      m_exp(true), 
      m_drag(false), 
      m_bx(130), 
      m_by(0), 
      m_eq_drag(false), 
      m_eq_x(-1), 
      m_eq_y(-1) 
   {
   }
   
   ~CStickerPanel() 
   {
   }

   void SetSettings(CStickerSettings *s) 
   { 
      m_set = s; 
   }
   
   int S(int v) 
   { 
      return (int)(v * m_set.UIScale); 
   } 

   bool Init(string suffix="")
   {
      m_pre = suffix + "_";
      
      m_trade.SetExpertMagicNumber(m_set.MagicNumber);
      m_trade.SetDeviationInPoints(m_set.Slippage);
      m_trade.SetTypeFillingBySymbol(_Symbol);
      m_trade.SetAsyncMode(m_set.UseAsync);

      string k;
      k = m_set.BuyKey;        
      if(k != "") { StringToUpper(k); m_kb = StringGetCharacter(k, 0); } else m_kb = 0;
      
      k = m_set.SellKey;       
      if(k != "") { StringToUpper(k); m_ks = StringGetCharacter(k, 0); } else m_ks = 0;
      
      k = m_set.CloseKey;      
      if(k != "") { StringToUpper(k); m_kc = StringGetCharacter(k, 0); } else m_kc = 0;
      
      k = (m_set.LotUpKey == "")   ? "U" : m_set.LotUpKey;   
      StringToUpper(k); 
      m_ku = StringGetCharacter(k, 0);
      
      k = (m_set.LotDownKey == "") ? "D" : m_set.LotDownKey; 
      StringToUpper(k); 
      m_kd = StringGetCharacter(k, 0);
      
      k = m_set.CloseLongKey;  
      if(k != "") { StringToUpper(k); m_kcl = StringGetCharacter(k, 0); } else m_kcl = 0;
      
      k = m_set.CloseShortKey; 
      if(k != "") { StringToUpper(k); m_kcs = StringGetCharacter(k, 0); } else m_kcs = 0;
      
      k = m_set.CloseWinKey;   
      if(k != "") { StringToUpper(k); m_kw = StringGetCharacter(k, 0); } else m_kw = 0;  
      
      k = m_set.CloseLossKey;  
      if(k != "") { StringToUpper(k); m_kl = StringGetCharacter(k, 0); } else m_kl = 0;  
      
      k = m_set.CloseHalfKey;  
      if(k != "") { StringToUpper(k); m_kh = StringGetCharacter(k, 0); } else m_kh = 0;
      
      m_vol_step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
      m_vol_min  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
      m_vol_max  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
      m_vol_dig  = (int)MathMax(0, -MathLog10(m_vol_step));
      
      if(m_eq_x == -1) m_eq_x = m_set.EquityXOffset;
      if(m_eq_y == -1) m_eq_y = m_set.EquityYOffset;

      ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
      Draw();
      ChartRedraw();
      
      return true;
   }
   
   void Deinit(const int r) 
   { 
      if(r == REASON_REMOVE) {
         ObjectsDeleteAll(0, m_pre); 
      } else {
         string btns[] = {"CL", "CS", "W", "L", "E", "C", "S", "B", "TOG", "EQ_TXT"}; 
         for(int i = 0; i < 10; i++) {
            ObjectDelete(0, m_pre + btns[i]);
         }
      }
      ChartSetInteger(0, CHART_MOUSE_SCROLL, true); 
      ChartRedraw(); 
   }

   void CloseAll() 
   { 
      m_trade.SetAsyncMode(m_set.UseAsync); 
      for(int i = PositionsTotal() - 1; i >= 0; i--) { 
         ulong t = PositionGetTicket(i); 
         if(t > 0 && PositionGetString(POSITION_SYMBOL) == _Symbol && (m_set.MagicNumber == -1 || PositionGetInteger(POSITION_MAGIC) == m_set.MagicNumber)) {
            m_trade.PositionClose(t, m_set.Slippage); 
         }
      } 
      ChartSetInteger(0, CHART_BRING_TO_TOP, true); 
   }
   
   void CloseBySide(ENUM_POSITION_TYPE type) 
   { 
      m_trade.SetAsyncMode(m_set.UseAsync); 
      for(int i = PositionsTotal() - 1; i >= 0; i--) { 
         ulong t = PositionGetTicket(i); 
         if(t > 0 && PositionGetInteger(POSITION_TYPE) == type && PositionGetString(POSITION_SYMBOL) == _Symbol && (m_set.MagicNumber == -1 || PositionGetInteger(POSITION_MAGIC) == m_set.MagicNumber)) {
            m_trade.PositionClose(t, m_set.Slippage); 
         }
      } 
      ChartSetInteger(0, CHART_BRING_TO_TOP, true); 
   }
   
   void CloseWinAll() 
   { 
      m_trade.SetAsyncMode(m_set.UseAsync); 
      for(int i = PositionsTotal() - 1; i >= 0; i--) { 
         ulong t = PositionGetTicket(i); 
         if(t > 0 && PositionGetString(POSITION_SYMBOL) == _Symbol && (m_set.MagicNumber == -1 || PositionGetInteger(POSITION_MAGIC) == m_set.MagicNumber) && PositionGetDouble(POSITION_PROFIT) > 0) {
            m_trade.PositionClose(t, m_set.Slippage); 
         }
      } 
      ChartSetInteger(0, CHART_BRING_TO_TOP, true); 
   }
   
   void CloseLossAll() 
   { 
      m_trade.SetAsyncMode(m_set.UseAsync); 
      for(int i = PositionsTotal() - 1; i >= 0; i--) { 
         ulong t = PositionGetTicket(i); 
         if(t > 0 && PositionGetString(POSITION_SYMBOL) == _Symbol && (m_set.MagicNumber == -1 || PositionGetInteger(POSITION_MAGIC) == m_set.MagicNumber) && PositionGetDouble(POSITION_PROFIT) < 0) {
            m_trade.PositionClose(t, m_set.Slippage); 
         }
      } 
      ChartSetInteger(0, CHART_BRING_TO_TOP, true); 
   }
   
   void CloseHalfAll()
   {
      m_trade.SetAsyncMode(m_set.UseAsync);
      m_trade.SetDeviationInPoints(m_set.Slippage); 
      
      double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
      double min_vol = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
      
      for(int i = PositionsTotal() - 1; i >= 0; i--) {
         ulong t = PositionGetTicket(i);
         if(t <= 0) continue;
         if(m_set.SymbolMode == SM_CURRENT_SYMBOL && PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
         if(m_set.MagicNumber != -1 && PositionGetInteger(POSITION_MAGIC) != m_set.MagicNumber) continue;
         
         double vol = PositionGetDouble(POSITION_VOLUME);
         if(vol <= min_vol) continue; 
         
         double half_vol = MathRound((vol * 0.5) / step) * step;
         if(half_vol >= min_vol) {
            m_trade.PositionClosePartial(t, half_vol);
         }
      }
      ChartSetInteger(0, CHART_BRING_TO_TOP, true);
   }
   
   void UpdateEquity()
   {
       string name = m_pre + "EQ_TXT";
       if(!m_set.ShowEquityText) { 
          if(ObjectFind(0, name) >= 0) ObjectDelete(0, name); 
          return; 
       }

       double eq = AccountInfoDouble(ACCOUNT_EQUITY);
       double pnl = AccountInfoDouble(ACCOUNT_PROFIT); 
       int spread = (int)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD); 

       static double last_eq = -1.0; 
       static double last_pnl = -1000000.0; 
       static int last_spread = -1;
       
       bool is_changed = (MathAbs(eq - last_eq) > DBL_EPSILON || MathAbs(pnl - last_pnl) > DBL_EPSILON || spread != last_spread);
       if(!is_changed && ObjectFind(0, name) >= 0) return; 

       if(ObjectFind(0, name) < 0) {
           ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
           ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
           ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
           ObjectSetString(0, name, OBJPROP_FONT, "Arial Bold");
           ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false); 
           ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
           ObjectSetInteger(0, name, OBJPROP_FONTSIZE, m_set.EquityFontSize);
           ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_eq_x);
           ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_eq_y);
       }

       double bal = AccountInfoDouble(ACCOUNT_BALANCE);
       double pct = (bal > 0) ? (pnl * (100.0 / bal)) : 0.0; 
       string txt; 
       color c = m_set.EquityTextColor; 

       if(pnl > 0) { 
          txt = StringFormat("[SP:%3d] EQ: $%.2f  [ +$%.2f (+%.2f%%) ]", spread, eq, pnl, pct); 
          c = clrLime; 
       } 
       else if(pnl < 0) { 
          txt = StringFormat("[SP:%3d] EQ: $%.2f  [ -$%.2f (%.2f%%) ]", spread, eq, MathAbs(pnl), pct); 
          c = clrTomato; 
       } 
       else { 
          txt = StringFormat("[SP:%3d] EQ: $%.2f", spread, eq); 
       }

       ObjectSetString(0, name, OBJPROP_TEXT, txt);
       ObjectSetInteger(0, name, OBJPROP_COLOR, c); 
       ChartRedraw();
       
       last_eq = eq; 
       last_pnl = pnl; 
       last_spread = spread;
   }

   void OnChartEvent(const int id, const long &lp, const double &dp, const string &sp)
   {
      if(id == CHARTEVENT_KEYDOWN)
      {
         int k_code = (int)lp;
         if(k_code >= 96 && k_code <= 105) k_code -= 48; 
         
         if(m_set.UseScrollLock && lp == SM_VK_SCROLL) { m_sdown = true; return; }
         if(m_set.UseScrollLock && !m_sdown) return; 
         
         if(k_code == m_ku) { ChgLot(1); return; }
         if(k_code == m_kd) { ChgLot(-1); return; }
         if(k_code == m_kcl) { CloseBySide(POSITION_TYPE_BUY);  return; }
         if(k_code == m_kcs) { CloseBySide(POSITION_TYPE_SELL); return; }
         if(k_code == m_kw) { CloseWinAll();  return; }
         if(k_code == m_kl) { CloseLossAll(); return; }
         if(k_code == m_kh) { CloseHalfAll(); return; }
         
         if(k_code == m_kb) Entry(ORDER_TYPE_BUY);
         else if(k_code == m_ks) Entry(ORDER_TYPE_SELL);
         else if(k_code == m_kc) CloseAll(); 
         return;
      }
      
      if(id == CHARTEVENT_KEYUP && m_set.UseScrollLock && lp == SM_VK_SCROLL) { 
         m_sdown = false; 
         return; 
      }

      if(id == CHARTEVENT_MOUSE_MOVE)
      {
         if(sp == "1")
         {
            if(m_drag)
            {
               m_bx = m_dox - ((int)lp - m_dmx);
               m_by = m_doy + ((int)dp - m_dmy);
               if(m_bx < 0) m_bx = 0; 
               if(m_by < 0) m_by = 0;
               Draw();
            }
            else if(m_eq_drag)
            {
               m_eq_x = m_eq_dox - ((int)lp - m_dmx);
               m_eq_y = m_eq_doy + ((int)dp - m_dmy);
               if(m_eq_x < 0) m_eq_x = 0; 
               if(m_eq_y < 0) m_eq_y = 0;
               
               string eqName = m_pre + "EQ_TXT";
               ObjectSetInteger(0, eqName, OBJPROP_XDISTANCE, m_eq_x);
               ObjectSetInteger(0, eqName, OBJPROP_YDISTANCE, m_eq_y);
               ChartRedraw();
            }
            else
            {
               string togName = m_pre + "TOG";
               if(ObjectFind(0, togName) >= 0)
               {
                  long chartW = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
                  int ox = (int)ObjectGetInteger(0, togName, OBJPROP_XDISTANCE);
                  int oy = (int)ObjectGetInteger(0, togName, OBJPROP_YDISTANCE);
                  int ow = (int)ObjectGetInteger(0, togName, OBJPROP_XSIZE);
                  int oh = (int)ObjectGetInteger(0, togName, OBJPROP_YSIZE);
                  int left = (int)chartW - ox - ow;
                  int right = (int)chartW - ox;
                  if((int)lp >= left && (int)lp <= right && (int)dp >= oy && (int)dp <= oy + oh)
                  {
                     m_drag = true;
                     m_dmx = (int)lp; 
                     m_dmy = (int)dp;
                     m_dox = m_bx;    
                     m_doy = m_by;
                     ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
                  }
               }
               
               string eqName = m_pre + "EQ_TXT";
               if(m_set.ShowEquityText && ObjectFind(0, eqName) >= 0)
               {
                  long chartW = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
                  int ox = (int)ObjectGetInteger(0, eqName, OBJPROP_XDISTANCE);
                  int oy = (int)ObjectGetInteger(0, eqName, OBJPROP_YDISTANCE);
                  
                  int ow = (int)ObjectGetInteger(0, eqName, OBJPROP_XSIZE);
                  int oh = (int)ObjectGetInteger(0, eqName, OBJPROP_YSIZE);
                  if(ow <= 0) ow = 120; 
                  if(oh <= 0) oh = 20;

                  int left = (int)chartW - ox - ow;  
                  int right = (int)chartW - ox;      
                  int top = oy;                      
                  int bottom = oy + oh;              
                  
                  if((int)lp >= left && (int)lp <= right && (int)dp >= top && (int)dp <= bottom)
                  {
                     m_eq_drag = true;
                     m_dmx = (int)lp; 
                     m_dmy = (int)dp;
                     m_eq_dox = m_eq_x; 
                     m_eq_doy = m_eq_y;
                     ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
                  }
               }
            }
         }
         else 
         { 
            if(m_drag) { 
               m_drag = false; 
               ChartSetInteger(0, CHART_MOUSE_SCROLL, true); 
            }
            if(m_eq_drag) { 
               m_eq_drag = false; 
               ChartSetInteger(0, CHART_MOUSE_SCROLL, true); 
            }
         }
      }
      else if(id == CHARTEVENT_OBJECT_CLICK && !m_drag && !m_eq_drag)
      {
         if(StringFind(sp, m_pre) == 0) { 
            ObjectSetInteger(0, sp, OBJPROP_STATE, false); 
            ChartRedraw(); 
         }
         
         if(sp == m_pre + "TOG") { 
            m_exp = !m_exp; 
            Draw(); 
            ChartSetInteger(0, CHART_BRING_TO_TOP, true); 
         }
         else if(sp == m_pre + "CL") CloseBySide(POSITION_TYPE_BUY); 
         else if(sp == m_pre + "CS") CloseBySide(POSITION_TYPE_SELL);
         else if(sp == m_pre + "W")  CloseWinAll(); 
         else if(sp == m_pre + "L")  CloseLossAll(); 
         else if(sp == m_pre + "B")  Entry(ORDER_TYPE_BUY);
         else if(sp == m_pre + "S")  Entry(ORDER_TYPE_SELL);
         else if(sp == m_pre + "C")  CloseAll();
      }
      else if(id == CHARTEVENT_OBJECT_ENDEDIT && sp == m_pre + "E") { 
         ChartSetInteger(0, CHART_BRING_TO_TOP, true); 
      }
   }

private:
   double GetPanelDistance(int mode, double value, double vol, double base_cap) 
   {
      if(value < 0) return 0; 
      
      double pt = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      if(mode == RISK_PIP) return value * pt;
      
      double tickVal = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
      double tickSiz = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      if(tickVal == 0 || tickSiz == 0 || vol <= 0) return 0;
      
      double target_money = (mode == RISK_PCT) ? base_cap * (value * 0.01) : value;
      return target_money / (vol * (tickVal / tickSiz));
   }

   void Entry(ENUM_ORDER_TYPE t)
   {
      m_trade.SetAsyncMode(m_set.UseAsync);
      
      double v = StringToDouble(ObjectGetString(0, m_pre + "E", OBJPROP_TEXT));
      double p = (t == ORDER_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
      
      double hard_sl = 0.0;
      double hard_tp = 0.0;
      
      bool use_sl = !m_set.HardSL_S.is_x; 
      bool use_tp = !m_set.HardTP_S.is_x; 
      
      if(use_sl || use_tp) 
      {
         double base_cap = AccountInfoDouble(ACCOUNT_BALANCE);
         
         double sl_dist = GetPanelDistance(m_set.HardSL_S.mode, m_set.HardSL_S.value, v, base_cap);
         double tp_dist = GetPanelDistance(m_set.HardTP_S.mode, m_set.HardTP_S.value, v, base_cap); 
         
         if(t == ORDER_TYPE_BUY) {
            if(use_sl && !m_set.HardSL_S.is_hidden) hard_sl = p - sl_dist; 
            if(use_tp && !m_set.HardTP_S.is_hidden) hard_tp = p + tp_dist; 
         } else {
            if(use_sl && !m_set.HardSL_S.is_hidden) hard_sl = p + sl_dist; 
            if(use_tp && !m_set.HardTP_S.is_hidden) hard_tp = p - tp_dist; 
         }
      }
      
      if(t == ORDER_TYPE_BUY ? m_trade.Buy(v, _Symbol, p, hard_sl, hard_tp) : m_trade.Sell(v, _Symbol, p, hard_sl, hard_tp)) 
      {
         ChartSetInteger(0, CHART_BRING_TO_TOP, true);
      }
   }

   void Draw()
   {
      int h = 22;
      int w = 30;
      int Y = m_by;
      int cx = m_bx;
      color bg = m_set.ColorBtnBg; 

      if(m_exp)
      {
         Btn("CL", "CL", cx, Y, S(w), S(h), bg, false); cx += S(w);
         Btn("CS", "CS", cx, Y, S(w), S(h), bg, false); cx += S(w);
         Btn("W",  "W",  cx, Y, S(w), S(h), bg, false); cx += S(w);
         Btn("L",  "L",  cx, Y, S(w), S(h), bg, false); cx += S(w);
         Edit("E",       cx, Y, S(w), S(h));            cx += S(w);
         Btn("C",  "X",  cx, Y, S(w), S(h), bg, false); cx += S(w);
         Btn("S",  "S",  cx, Y, S(w), S(h), bg, false); cx += S(w);
         Btn("B",  "B",  cx, Y, S(w), S(h), bg, false); cx += S(w);
         Btn("TOG", "◀", cx, Y, S(w), S(h), bg, true);
      }
      else
      {
         string btns[] = {"CL", "CS", "W", "L", "E", "C", "S", "B"};
         for(int i = 0; i < 8; i++) {
            HideBtn(btns[i]);
         }
         Btn("TOG", "▶", m_bx, Y, S(w), S(h), bg, true);
      }
      ChartRedraw();
   }

   void ChgLot(double d) 
   { 
      bool shift = (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0); 
      double step = m_vol_step * (shift ? 10.0 : 1.0); 
      double v = StringToDouble(ObjectGetString(0, m_pre + "E", OBJPROP_TEXT)) + (step * d); 
      
      v = MathMax(m_vol_min, MathMin(m_vol_max, v)); 
      
      ObjectSetString(0, m_pre + "E", OBJPROP_TEXT, DoubleToString(v, m_vol_dig)); 
      ChartRedraw(); 
   }
   
   void Btn(string n, string t, int x, int y, int w, int h, color c, bool d) 
   { 
      string o = m_pre + n; 
      if(ObjectFind(0, o) < 0) { 
         ObjectCreate(0, o, OBJ_BUTTON, 0, 0, 0); 
         ObjectSetInteger(0, o, OBJPROP_CORNER, CORNER_RIGHT_UPPER); 
         ObjectSetInteger(0, o, OBJPROP_FONTSIZE, S(8)); 
         ObjectSetString(0, o, OBJPROP_FONT, "Arial Bold"); 
         ObjectSetInteger(0, o, OBJPROP_BORDER_COLOR, clrNONE); 
         ObjectSetInteger(0, o, OBJPROP_SELECTABLE, false); 
         ObjectSetInteger(0, o, OBJPROP_HIDDEN, false); 
         ObjectSetInteger(0, o, OBJPROP_COLOR, m_set.ColorBtnText); 
         ObjectSetInteger(0, o, OBJPROP_XSIZE, w); 
         ObjectSetInteger(0, o, OBJPROP_YSIZE, h); 
         ObjectSetInteger(0, o, OBJPROP_BGCOLOR, c); 
      } 
      
      if(ObjectGetInteger(0, o, OBJPROP_XDISTANCE) != x) ObjectSetInteger(0, o, OBJPROP_XDISTANCE, x); 
      if(ObjectGetInteger(0, o, OBJPROP_YDISTANCE) != y) ObjectSetInteger(0, o, OBJPROP_YDISTANCE, y); 
      if(ObjectGetString(0, o, OBJPROP_TEXT) != t) ObjectSetString(0, o, OBJPROP_TEXT, t); 
   }
   
   void Edit(string n, int x, int y, int w, int h) 
   { 
      string o = m_pre + n; 
      if(ObjectFind(0, o) < 0) { 
         ObjectCreate(0, o, OBJ_EDIT, 0, 0, 0); 
         ObjectSetInteger(0, o, OBJPROP_CORNER, CORNER_RIGHT_UPPER); 
         ObjectSetInteger(0, o, OBJPROP_FONTSIZE, S(9)); 
         ObjectSetString(0, o, OBJPROP_FONT, "Arial Bold"); 
         ObjectSetInteger(0, o, OBJPROP_ALIGN, ALIGN_CENTER); 
         ObjectSetInteger(0, o, OBJPROP_BGCOLOR, clrWhiteSmoke); 
         ObjectSetInteger(0, o, OBJPROP_SELECTABLE, false); 
         ObjectSetInteger(0, o, OBJPROP_HIDDEN, false); 
         ObjectSetInteger(0, o, OBJPROP_COLOR, clrBlack); 
         ObjectSetString(0, o, OBJPROP_TEXT, DoubleToString(m_set.StartLots, 2)); 
         ObjectSetInteger(0, o, OBJPROP_XSIZE, w); 
         ObjectSetInteger(0, o, OBJPROP_YSIZE, h); 
      } 
      
      if(ObjectGetInteger(0, o, OBJPROP_XDISTANCE) != x) ObjectSetInteger(0, o, OBJPROP_XDISTANCE, x); 
      if(ObjectGetInteger(0, o, OBJPROP_YDISTANCE) != y) ObjectSetInteger(0, o, OBJPROP_YDISTANCE, y); 
   }
   
   void HideBtn(string n) 
   { 
      string o = m_pre + n; 
      if(ObjectFind(0, o) >= 0) { 
         ObjectSetInteger(0, o, OBJPROP_XDISTANCE, -1000); 
         ObjectSetInteger(0, o, OBJPROP_YDISTANCE, -1000); 
      } 
   }
};

#endif // TF_PANEL_260315_0350_MQH
