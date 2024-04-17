;/////////////////////////////////////////////////////////////////////////////////
;// Code Generator: BoostC Compiler - http://www.sourceboost.com
;// Version       : 6.97
;// License Type  : Full License
;// Limitations   : PIC12,PIC16 max code size:Unlimited, max RAM banks:Unlimited, Non commercial use only
;/////////////////////////////////////////////////////////////////////////////////

	include "P12F675.inc"
; Heap block 0, size:38 (0x00000039 - 0x0000005E)
__HEAP_BLOCK0_BANK               EQU	0x00000000
__HEAP_BLOCK0_START_OFFSET       EQU	0x00000039
__HEAP_BLOCK0_END_OFFSET         EQU	0x0000005E
; Heap block 1, size:0 (0x00000000 - 0x00000000)
__HEAP_BLOCK1_BANK               EQU	0x00000000
__HEAP_BLOCK1_START_OFFSET       EQU	0x00000000
__HEAP_BLOCK1_END_OFFSET         EQU	0x00000000
; Heap block 2, size:0 (0x00000000 - 0x00000000)
__HEAP_BLOCK2_BANK               EQU	0x00000000
__HEAP_BLOCK2_START_OFFSET       EQU	0x00000000
__HEAP_BLOCK2_END_OFFSET         EQU	0x00000000
; Heap block 3, size:0 (0x00000000 - 0x00000000)
__HEAP_BLOCK3_BANK               EQU	0x00000000
__HEAP_BLOCK3_START_OFFSET       EQU	0x00000000
__HEAP_BLOCK3_END_OFFSET         EQU	0x00000000
gbl_indf                         EQU	0x00000000 ; bytes:1
gbl_tmr0                         EQU	0x00000001 ; bytes:1
gbl_pcl                          EQU	0x00000002 ; bytes:1
gbl_status                       EQU	0x00000003 ; bytes:1
gbl_fsr                          EQU	0x00000004 ; bytes:1
gbl_gpio                         EQU	0x00000005 ; bytes:1
gbl_pclath                       EQU	0x0000000A ; bytes:1
gbl_intcon                       EQU	0x0000000B ; bytes:1
gbl_pir1                         EQU	0x0000000C ; bytes:1
gbl_tmr1l                        EQU	0x0000000E ; bytes:1
gbl_tmr1h                        EQU	0x0000000F ; bytes:1
gbl_t1con                        EQU	0x00000010 ; bytes:1
gbl_cmcon                        EQU	0x00000019 ; bytes:1
gbl_adresh                       EQU	0x0000001E ; bytes:1
gbl_adcon0                       EQU	0x0000001F ; bytes:1
gbl_option_reg                   EQU	0x00000081 ; bytes:1
gbl_trisio                       EQU	0x00000085 ; bytes:1
gbl_pie1                         EQU	0x0000008C ; bytes:1
gbl_pcon                         EQU	0x0000008E ; bytes:1
gbl_osccal                       EQU	0x00000090 ; bytes:1
gbl_wpu                          EQU	0x00000095 ; bytes:1
gbl_ioc                          EQU	0x00000096 ; bytes:1
gbl_iocb                         EQU	0x00000096 ; bytes:1
gbl_vrcon                        EQU	0x00000099 ; bytes:1
gbl_eedata                       EQU	0x0000009A ; bytes:1
gbl_eeadr                        EQU	0x0000009B ; bytes:1
gbl_eecon1                       EQU	0x0000009C ; bytes:1
gbl_eecon2                       EQU	0x0000009D ; bytes:1
gbl_adresl                       EQU	0x0000009E ; bytes:1
gbl_ansel                        EQU	0x0000009F ; bytes:1
gbl_swVal                        EQU	0x00000023 ; bytes:2
gbl_timer                        EQU	0x00000025 ; bytes:1
gbl_seconds                      EQU	0x00000026 ; bytes:1
gbl_minutes                      EQU	0x00000027 ; bytes:1
gbl_milliseconds                 EQU	0x00000028 ; bytes:1
gbl_TMRFlag                      EQU	0x00000029 ; bytes:1
gbl_max_seconds                  EQU	0x0000002A ; bytes:1
gbl_tmrOffset                    EQU	0x0000002B ; bytes:1
gbl_oldseconds                   EQU	0x0000002C ; bytes:1
startTimer_00011_arg_maxMinutes  EQU	0x0000002F ; bytes:1
sound_00000_arg_period           EQU	0x00000031 ; bytes:1
sound_00000_arg_cycles           EQU	0x00000032 ; bytes:1
sound_00000_arg_duration         EQU	0x00000033 ; bytes:1
sound_00000_1_j                  EQU	0x00000034 ; bytes:2
sound_00000_2_i                  EQU	0x00000036 ; bytes:2
startTimer_00000_arg_maxvalue    EQU	0x0000002D ; bytes:1
CompTempVarRet19                 EQU	0x0000002E ; bytes:1
CompTempVarRet20                 EQU	0x0000002E ; bytes:1
getKeyPres_00012_1_value         EQU	0x0000002D ; bytes:1
notifyFini_00013_arg_lastSecs    EQU	0x0000002F ; bytes:1
notifyFini_00013_arg_secsI_00014 EQU	0x00000030 ; bytes:1
delay_us_00000_arg_del           EQU	0x00000038 ; bytes:1
Int1Context                      EQU	0x0000005F ; bytes:1
Int1BContext                     EQU	0x00000020 ; bytes:3
	ORG 0x00000000
	GOTO	_startup
	ORG 0x00000004
	MOVWF Int1Context
	SWAPF STATUS, W
	BCF STATUS, RP0
	MOVWF Int1BContext
	SWAPF PCLATH, W
	MOVWF Int1BContext+D'1'
	SWAPF FSR, W
	MOVWF Int1BContext+D'2'
	BCF PCLATH,3
	BCF PCLATH,4
	GOTO	interrupt
	ORG 0x00000010
delay_us_00000
; { delay_us ; function begin
	MOVLW 0x03
	ADDWF delay_us_00000_arg_del, F
	RRF delay_us_00000_arg_del, F
	RRF delay_us_00000_arg_del, F
	MOVLW 0x7F
	ANDWF delay_us_00000_arg_del, F
label1
	NOP
	DECFSZ delay_us_00000_arg_del, F
	GOTO	label1
	RETURN
; } delay_us function end

	ORG 0x0000001A
sound_00000
; { sound ; function begin
	CLRF sound_00000_1_j
	CLRF sound_00000_1_j+D'1'
label2
	MOVF sound_00000_arg_duration, W
	SUBWF sound_00000_1_j, W
	MOVF sound_00000_1_j+D'1', W
	BTFSC STATUS,C
	GOTO	label3
	BTFSC STATUS,Z
	GOTO	label4
label3
	BTFSS sound_00000_1_j+D'1',7
	GOTO	label9
label4
	CLRF sound_00000_2_i
	CLRF sound_00000_2_i+D'1'
label5
	MOVF sound_00000_arg_cycles, W
	SUBWF sound_00000_2_i, W
	MOVF sound_00000_2_i+D'1', W
	BTFSC STATUS,C
	GOTO	label6
	BTFSC STATUS,Z
	GOTO	label7
label6
	BTFSS sound_00000_2_i+D'1',7
	GOTO	label8
label7
	MOVF sound_00000_arg_period, W
	MOVWF delay_us_00000_arg_del
	CALL delay_us_00000
	MOVLW 0x04
	XORWF gbl_gpio, F
	INCF sound_00000_2_i, F
	BTFSC STATUS,Z
	INCF sound_00000_2_i+D'1', F
	GOTO	label5
label8
	INCF sound_00000_1_j, F
	BTFSC STATUS,Z
	INCF sound_00000_1_j+D'1', F
	GOTO	label2
label9
	BCF gbl_gpio,2
	RETURN
; } sound function end

	ORG 0x0000003F
startTimer_00011
; { startTimerLight ; function begin
	INCF gbl_milliseconds, F
	MOVF gbl_milliseconds, W
	XORLW 0x3C
	BTFSS STATUS,Z
	GOTO	label10
	CLRF gbl_milliseconds
	INCF gbl_seconds, F
	MOVF gbl_seconds, W
	XORLW 0x3C
	BTFSS STATUS,Z
	GOTO	label10
	CLRF gbl_seconds
	INCF gbl_minutes, F
	MOVF startTimer_00011_arg_maxMinutes, W
	XORWF gbl_minutes, W
	BTFSS STATUS,Z
	GOTO	label10
	CLRF gbl_minutes
	MOVLW 0x01
	MOVWF gbl_TMRFlag
	CLRF gbl_timer
label10
	CLRF gbl_tmr0
	MOVF gbl_tmrOffset, W
	MOVWF gbl_tmr0
	RETURN
; } startTimerLight function end

	ORG 0x00000058
notifyFini_00013
; { notifyFinish ; function begin
	INCF gbl_milliseconds, F
	MOVF gbl_milliseconds, W
	XORLW 0x3C
	BTFSS STATUS,Z
	GOTO	label12
	CLRF gbl_milliseconds
	INCF gbl_seconds, F
	INCF gbl_oldseconds, F
	MOVF notifyFini_00013_arg_secsI_00014, W
	XORWF gbl_oldseconds, W
	BTFSS STATUS,Z
	GOTO	label11
	MOVLW 0xC8
	MOVWF sound_00000_arg_period
	MOVWF sound_00000_arg_cycles
	MOVLW 0x05
	MOVWF sound_00000_arg_duration
	CALL sound_00000
	CLRF gbl_oldseconds
label11
	MOVF notifyFini_00013_arg_lastSecs, W
	XORWF gbl_seconds, W
	BTFSS STATUS,Z
	GOTO	label12
	CLRF gbl_seconds
	CLRF gbl_timer
	CLRF gbl_TMRFlag
	BCF gbl_gpio,1
	CLRF gbl_gpio
	BCF gbl_intcon,5
	BCF gbl_intcon,7
	BCF gbl_intcon,2
label12
	CLRF gbl_tmr0
	MOVF gbl_tmrOffset, W
	MOVWF gbl_tmr0
	RETURN
; } notifyFinish function end

	ORG 0x0000007B
startTimer_00000
; { startTimer ; function begin
	CLRF gbl_tmr0
	MOVLW 0x07
	BSF STATUS, RP0
	MOVWF gbl_option_reg
	BCF STATUS, RP0
	BCF gbl_intcon,2
	BSF gbl_intcon,7
	MOVF startTimer_00000_arg_maxvalue, W
	MOVWF gbl_tmr0
	BSF gbl_intcon,5
	MOVLW 0x01
	MOVWF CompTempVarRet19
	RETURN
; } startTimer function end

	ORG 0x00000088
init_00000
; { init ; function begin
	BSF STATUS, RP0
	CLRF gbl_vrcon
	MOVLW 0x07
	BCF STATUS, RP0
	MOVWF gbl_cmcon
	BSF STATUS, RP0
	CLRF gbl_ansel
	BCF STATUS, RP0
	CLRF gbl_gpio
	MOVLW 0x11
	BSF STATUS, RP0
	MOVWF gbl_trisio
	CLRF gbl_wpu
	BCF STATUS, RP0
	CLRF gbl_seconds
	CLRF gbl_minutes
	CLRF gbl_milliseconds
	CLRF gbl_TMRFlag
	CLRF gbl_max_seconds
	CLRF gbl_tmrOffset
	CLRF gbl_oldseconds
	CLRF gbl_timer
	BCF gbl_intcon,5
	BCF gbl_intcon,7
	BCF gbl_intcon,2
	MOVLW 0x64
	MOVWF delay_us_00000_arg_del
	CALL delay_us_00000
	RETURN
; } init function end

	ORG 0x000000A5
getKeyPres_00012
; { getKeyPress ; function begin
	BCF STATUS, RP0
	CLRF getKeyPres_00012_1_value
label13
	MOVF getKeyPres_00012_1_value, F
	BTFSS STATUS,Z
	GOTO	label15
	CLRF getKeyPres_00012_1_value
	BTFSS gbl_gpio,0
	GOTO	label14
	INCF getKeyPres_00012_1_value, F
label14
	MOVLW 0xFF
	MOVWF delay_us_00000_arg_del
	CALL delay_us_00000
	GOTO	label13
label15
	MOVF getKeyPres_00012_1_value, W
	ANDLW 0x11
	MOVWF getKeyPres_00012_1_value
	MOVF getKeyPres_00012_1_value, W
	MOVWF CompTempVarRet20
	RETURN
; } getKeyPress function end

	ORG 0x000000B8
main
; { main ; function begin
	BCF STATUS, RP0
	BSF gbl_status,5
	CALL 0x000003FF
	BSF STATUS, RP0
	MOVWF gbl_osccal
	BCF STATUS, RP0
	BCF gbl_status,5
	BCF PCLATH,3
	BCF PCLATH,4
	CALL init_00000
	BSF gbl_gpio,1
	MOVLW 0xC8
	MOVWF sound_00000_arg_period
	MOVLW 0xFF
	MOVWF sound_00000_arg_cycles
	MOVLW 0x0A
	MOVWF sound_00000_arg_duration
	CALL sound_00000
	BCF gbl_gpio,1
label16
	MOVF gbl_timer, F
	BTFSS STATUS,Z
	GOTO	label16
	CALL getKeyPres_00012
	MOVF CompTempVarRet20, W
	MOVWF gbl_swVal
	CLRF gbl_swVal+D'1'
	MOVLW 0x01
	XORWF gbl_swVal, W
	BTFSC STATUS,Z
	MOVF gbl_swVal+D'1', W
	BTFSS STATUS,Z
	GOTO	label16
	CLRF gbl_TMRFlag
	MOVLW 0xBC
	MOVWF gbl_tmrOffset
	MOVF gbl_tmrOffset, W
	MOVWF startTimer_00000_arg_maxvalue
	CALL startTimer_00000
	MOVF CompTempVarRet19, W
	MOVWF gbl_timer
	BSF gbl_gpio,1
	GOTO	label16
; } main function end

	ORG 0x000000E2
_startup
	BCF STATUS, RP0
	CLRF gbl_swVal
	CLRF gbl_swVal+D'1'
	CLRF gbl_oldseconds
	BCF PCLATH,3
	BCF PCLATH,4
	GOTO	main
	ORG 0x000000E9
interrupt
; { interrupt ; function begin
	BCF STATUS, RP0
	BCF gbl_intcon,5
	BCF gbl_intcon,7
	MOVF gbl_TMRFlag, F
	BTFSS STATUS,Z
	GOTO	label18
	MOVLW 0x09
	MOVWF startTimer_00011_arg_maxMinutes
	CALL startTimer_00011
label18
	BCF gbl_intcon,2
	DECF gbl_timer, W
	BTFSS STATUS,Z
	GOTO	label19
	MOVF gbl_TMRFlag, F
	BTFSS STATUS,Z
	GOTO	label19
	BSF gbl_intcon,7
	BSF gbl_intcon,5
label19
	DECF gbl_TMRFlag, W
	BTFSS STATUS,Z
	GOTO	label20
	MOVF gbl_timer, F
	BTFSS STATUS,Z
	GOTO	label20
	BSF gbl_intcon,7
	BSF gbl_intcon,5
	MOVLW 0x3C
	MOVWF notifyFini_00013_arg_lastSecs
	MOVLW 0x01
	MOVWF notifyFini_00013_arg_secsI_00014
	CALL notifyFini_00013
label20
	SWAPF Int1BContext+D'2', W
	MOVWF FSR
	SWAPF Int1BContext+D'1', W
	MOVWF PCLATH
	SWAPF Int1BContext, W
	MOVWF STATUS
	SWAPF Int1Context, F
	SWAPF Int1Context, W
	RETFIE
; } interrupt function end

	END
