//+------------------------------------------------------------------+
//|                                        Settings_260315_0350T.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                         Settings_260315_0350.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                        Settings_260315_0350.mqh  |
//|                                Copyright 2026, CSticker EA       |
//+------------------------------------------------------------------+
// =========================================================
// 🚨 [C2 절대 규칙] 0 = ON (스캘핑/본절)! 끄는 건 오직 'X' (is_x)
// 💡 금지 조항: value <= 0 조건으로 로직 막는 꼰대 코딩 절대 금지!
// =========================================================
#property description "⚙️ [C2 세팅] 4대장 전술(~) & 궁극의 X(고정) 문법 완벽 탑재!"
#property description "🤖 [C2 사령관] 렉 제로 하이브리드 전광판 & 워커 족보 완벽 정리!"
#property description "🚨 **'X 혁명'** 표준 도입! Start! (0=ON 국룰 파괴, 범용 X 스위치 이식)"
#property description "**'X 혁명'** 표준 도입! Start! (H 스텔스 암살 모드 추가)"
#property description "'모드 재벌(만수르)테스트 세팅해더 0350T!"
#property link        "https://drive.google.com/drive/folders/1bwB7EKOcvwpjJm7BDw0VU0-U0znlI2tw?usp=sharing"
#property version   "2.00" 
#property strict

#ifndef TF_SETTINGS_260315_0350T_MQH
#define TF_SETTINGS_260315_0350T_MQH

// ==================================================================
// 🧩 1. 필수 열거형 (Enum) 정의 (세로 정렬 복구)
// ==================================================================
enum ENUM_SM_SYMBOL_MODE { 
   SM_CURRENT_SYMBOL, 
   SM_ALL_SYMBOLS 
};

enum ENUM_BASE_CAPITAL {
   BASE_BALANCE   = 0, // B  (양날의 검: 물타기/전사자 발생 시 선 유연하게 이동)
   BASE_EQUITY    = 1, // E  (양날의 검: 물타기/전사자 발생 시 선 유연하게 이동)
   BASE_X_BALANCE = 2, // XB 🚨 (안전 모드: 전진 허용, 후퇴 절대 불가!)
   BASE_X_EQUITY  = 3  // XE 🚨 (안전 모드: 전진 허용, 후퇴 절대 불가!)
};

enum ENUM_WORKER_MODE { 
   WORKER_NORMAL   = 0,  // [순정] 각자도생 (개별 핍 단위 방어)
   WORKER_MUTANT   = 1,  // [변태] 순정 + 오프셋 (각자도생 편대 비행!)
   WORKER_ONEBOAT  = 2,  // [원보트] 사령관 통합선 & 핵폭탄 
   WORKER_NBANG    = 3,  // [N빵] 공산주의! (100% 간격 유지 평행 비행)
   WORKER_CAPITAL  = 4,  // [자본주의] 제로섬 가두리! 진입가 갭 50% 압축 꼬리 자르기!
   WORKER_NBBANG_3 = 5,  // [짬짜면] 약육강식 독박! (N빵 3버전)
   WORKER_PARALLEL = 6,  // ✈️ 6번: 찐 편대비행 (순정 오프셋 100% 기억)
   WORKER_MUTANT_P = 7,  // 👽 7번: [순정] 내 진입가 기준 + 변태 배율
   WORKER_MUTANT_N = 8   // 🐙 8번: [엔빵] 평균 단가 기준 + 변태 배율 (NEW!)  
}; 

enum ENUM_CUSTOM_PRICE {
   CUSTOM_PRICE_TAIL = 1, // [순정 꼬리] 롱: Low / 숏: High
   CUSTOM_PRICE_BODY,     // [몸통 끝단] 롱: Min(O,C) / 숏: Max(O,C)
   CUSTOM_PRICE_SIMPLE,   // [몸통 중앙] (O + C) * 0.5
   CUSTOM_PRICE_MEDIAN    // [캔들 중앙] (H + L) * 0.5     
};

#define SM_TAG_MANUAL "MANUAL"
#define SM_TAG_AUTO   "AUTO"
#define SM_VK_SCROLL  145

enum ENUM_RISK_MODE { 
   RISK_NONE, 
   RISK_PIP, 
   RISK_MONEY, 
   RISK_PCT 
};

struct RiskSetting {
   double         value;       
   ENUM_RISK_MODE mode;        
   bool           is_shadow;   
   bool           is_worker;   
   bool           is_x;        
   bool           is_hidden;   // 👻 [C2 혁명] H: 스텔스 모드 (계산은 하되 화면에서 선을 숨김!)
};

// ==================================================================
// 🗄️ 2. 세팅 클래스 본체
// ==================================================================
class CStickerSettings
{
public:
   double   StartLots;
   double   UIScale;
   double   MutantScale; // 👽 [추가] 변태 배율 조절기

   string   InpAlert;          
   
   string   AlertSound;
   string   BuyKey;
   string   SellKey;
   string   CloseKey;
   string   CloseLongKey;
   string   CloseShortKey;
   string   LotUpKey;
   string   LotDownKey;
   string   CloseWinKey;   
   string   CloseLossKey;
   string   CloseHalfKey;      
   
   string   InpStopLoss;
   string   InpTakeProfit;
   
   string   InpPLStart;  
   string   InpPLLock;         
   string   InpTSStart;  
   string   InpTS_Gap;         
   string   InpTTPStart; 
   string   InpTTP_Gap;        
   
   string   InpCandleStart;    
   string   InpCandleBuffer;   
   
   string   InpHardSL;         
   string   InpHardTP;         
   string   InpHardJump;       
   string   InpHardGap;        

   string   InpAbsTarget;
   string   InpAbsStop;
   string   InpRelTarget;
   string   InpRelLoss;
   string   InpPctTarget;
   string   InpPctLoss;

   bool     is_popup;
   bool     is_sound;

   RiskSetting SL;
   RiskSetting TP;
   
   RiskSetting PL_S;
   RiskSetting PL_Lock_S;      
   RiskSetting TS_S;
   RiskSetting TS_Gap;         
   RiskSetting TTP_S;
   RiskSetting TTP_Gap;        
   
   RiskSetting Candle_S;        
   RiskSetting CandleBuffer_S; 
   
   RiskSetting HardSL_S;       
   RiskSetting HardTP_S;       
   RiskSetting HardJump_S;     
   RiskSetting HardGap_S;      
   
   RiskSetting AbsTarget_S;
   RiskSetting AbsStop_S;
   RiskSetting RelTarget_S;
   RiskSetting RelLoss_S;
   RiskSetting PctTarget_S;
   RiskSetting PctLoss_S;

   int      MagicNumber;
   int      SymbolMode;
   int      WorkerMode;        
   int      BaseCapital; 
   int      Slippage;
   
   int                CandleTrail_N;      
   ENUM_TIMEFRAMES    CandleTF;            
   ENUM_CUSTOM_PRICE  CandleAppliedPrice; 
   
   int      TextOffset;
   int      WorkerFontSize;   
   int      CmdFontSize;      
   int      EquityXOffset;
   int      EquityYOffset;
   int      EquityFontSize;
   
   int      StopLoss;         
   int      TakeProfit;       
   
   color    ColorSL;
   color    ColorTP;
   color    ColorLineText;
   
   color    CmdColorAbsTp;
   color    CmdColorAbsSl;
   color    CmdColorRelTp;
   color    CmdColorRelSl;
   color    CmdColorPctTp;
   color    CmdColorPctSl;
   color    CmdColorLineText; 
   
   color    ColorBtnBg;
   color    ColorBtnText;
   color    EquityTextColor;
   
   int      WorkerLineStyle;  
   int      WorkerLineWidth;  
   int      CmdLineStyle;     
   int      CmdLineWidth;     

   bool     UseAsync;          
   bool     ShowEquityText;
   bool     UseScrollLock;

   // ==================================================================
   // 🛠️ 3. 마법의 생성자 (초기화)
   // ==================================================================
   CStickerSettings()
   {
      MagicNumber       = 0; 
      UseAsync          = true;
      SymbolMode        = 0; 
      StartLots         = 0.5;
      MutantScale       = 1.0; // 👽 [추가] 기본은 1.0 (순정 오프셋 100%)
      WorkerMode        = WORKER_MUTANT; 
      BaseCapital       = BASE_BALANCE; 
      Slippage          = 10;
      
      InpStopLoss       = "0X"; 
      InpTakeProfit     = "0X";
      
      InpPLStart        = "0X";  
      InpPLLock         = "0X";     
      InpTSStart        = "0X";  
      InpTS_Gap         = "1000"; 
      InpTTPStart       = "0X";  
      InpTTP_Gap        = "1000"; 
      
      InpHardSL         = "X5000"; 
      InpHardTP         = "0X";       
      InpHardJump       = "1000";     
      InpHardGap        = "W2000"; 
      
      CandleTF           = PERIOD_CURRENT;
      CandleTrail_N      = 1;
      InpCandleStart     = "0X";   
      InpCandleBuffer    = "180X";    
      CandleAppliedPrice = CUSTOM_PRICE_TAIL; 
      
      InpAbsTarget       = "0X"; 
      InpAbsStop         = "0X";
      InpRelTarget       = "5.0X"; 
      InpRelLoss         = "5.0X";
      InpPctTarget       = "5.0X"; 
      InpPctLoss         = "5.0X";
      
      InpAlert           = "SP";        
      AlertSound         = "tick.wav";
      BuyKey             = "1";  
      SellKey            = "2";  
      CloseKey           = "0";
      CloseLongKey       = "4";  
      CloseShortKey      = "5";  
      CloseHalfKey       = "3";
      CloseLossKey       = "6";  
      CloseWinKey        = "7"; 
      LotUpKey           = "8";  
      LotDownKey         = "9"; 
      UseScrollLock      = false; 
      
      UIScale            = 1.0;   
      TextOffset         = 0; 
      ShowEquityText     = true; 
      EquityXOffset      = 0;    
      EquityYOffset      = 20;   
      EquityFontSize     = 10;   
      
      ColorBtnBg         = clrBlack;     
      ColorBtnText       = clrWhite;     
      EquityTextColor    = clrGold;      
      ColorLineText      = clrPink;
      CmdColorLineText   = clrPink;      
      
      WorkerFontSize     = 9;              
      CmdFontSize        = 10;             
      
      ColorSL            = clrRed;            
      ColorTP            = clrLimeGreen;      
      WorkerLineStyle    = STYLE_DOT;         
      WorkerLineWidth    = 1;                 
      
      CmdColorAbsTp      = clrDodgerBlue;
      CmdColorAbsSl      = clrOrangeRed;
      CmdColorRelTp      = clrDeepSkyBlue;
      CmdColorRelSl      = clrMagenta;
      CmdColorPctTp      = clrMediumPurple;
      CmdColorPctSl      = clrDeepPink;
      CmdLineStyle       = STYLE_SOLID;        
      CmdLineWidth       = 1;                  
      
      StopLoss           = 0; 
      TakeProfit         = 0;
   }

   // ==================================================================
   // 🪄 4. [C2 핵심] 문자열 번역 파서 (H 스텔스 완벽 추가!)
   // ==================================================================
   RiskSetting ParseRiskString(string str)
   {
      RiskSetting res;
      res.value     = 0.0;
      res.mode      = RISK_NONE;
      res.is_shadow = false; 
      res.is_worker = false; 
      res.is_x      = false; 
      res.is_hidden = false; // 👻 H: 스텔스 암살 초기화
      
      StringToLower(str); 
      if(str == "") return res; 
      
      // 🛑 1. 'x' 감지 (전원 차단)
      if(StringFind(str, "x") >= 0) {
         res.is_x = true;
         StringReplace(str, "x", ""); 
      }
      
      // 👻 2. 'h' 감지 (스텔스 암살 모드)
      if(StringFind(str, "h") >= 0) {
         res.is_hidden = true;
         StringReplace(str, "h", ""); 
      }
      
      // 🌊 3. 섀도우(목줄) 감지 ('s' 또는 '~')
      if(StringFind(str, "s") >= 0 || StringFind(str, "~") >= 0) {
         res.is_shadow = true;
         StringReplace(str, "s", ""); 
         StringReplace(str, "~", ""); 
      }
      
      // 🤖 4. 워커 기준 감지 ('w')
      if(StringFind(str, "w") >= 0) {
         res.is_worker = true;
         StringReplace(str, "w", ""); 
      }
      
      // 🎯 5. 단위 판별 (순서가 생명!!!)
      if(StringFind(str, "po") >= 0) { 
         res.mode = RISK_PIP; 
         StringReplace(str, "po", ""); 
      }
      //else if(StringFind(str, "p") >= 0) {
      else if(StringFind(str, "p") >= 0 || StringFind(str, "%") >= 0) { 
         res.mode = RISK_PCT; 
         StringReplace(str, "p", "");
         StringReplace(str, "%", ""); 
      }
      else if(StringFind(str, "$") >= 0) { 
         res.mode = RISK_MONEY; 
         StringReplace(str, "$", ""); 
      }
      else { 
         res.mode = RISK_MONEY; 
      }
      
      // 🔫 6. 값 변환 및 0.0 기관총 안전망 
      res.value = StringToDouble(str); 
      if(res.value < 0 && !res.is_shadow) return res; 
      
      return res;
   }
      
   // ==================================================================
   // 🧠 5. EA 시작 시 단 한 번만 번역해두는 통합 함수
   // ==================================================================
   void ParseAllStrings()
   {
      SL = ParseRiskString(InpStopLoss);
      TP = ParseRiskString(InpTakeProfit);
      
      PL_S = ParseRiskString(InpPLStart);
      PL_Lock_S = ParseRiskString(InpPLLock);
      
      TS_S = ParseRiskString(InpTSStart);
      TS_Gap = ParseRiskString(InpTS_Gap);      
      
      TTP_S = ParseRiskString(InpTTPStart);
      TTP_Gap = ParseRiskString(InpTTP_Gap);     
      
      Candle_S = ParseRiskString(InpCandleStart);
      CandleBuffer_S = ParseRiskString(InpCandleBuffer);
      
      HardSL_S = ParseRiskString(InpHardSL);
      HardTP_S = ParseRiskString(InpHardTP);
      HardJump_S = ParseRiskString(InpHardJump);
      HardGap_S = ParseRiskString(InpHardGap);
      
      AbsTarget_S = ParseRiskString(InpAbsTarget);
      AbsStop_S = ParseRiskString(InpAbsStop);
      RelTarget_S = ParseRiskString(InpRelTarget);
      RelLoss_S = ParseRiskString(InpRelLoss);
      PctTarget_S = ParseRiskString(InpPctTarget);
      PctLoss_S = ParseRiskString(InpPctLoss);

      StopLoss   = (int)SL.value;
      TakeProfit = (int)TP.value;

      string s_alert = InpAlert;
      StringToUpper(s_alert);
      
      if (StringFind(s_alert, "X") >= 0) {
          is_popup = false;
          is_sound = false;
      } else {
          is_sound = (StringFind(s_alert, "S") >= 0);
          is_popup = (StringFind(s_alert, "P") >= 0);
      }
   }
};

#endif // TF_SETTINGS_260315_0350T_MQH

