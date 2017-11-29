% This script sets the controller parameters for the SLS 3-D Printer

% System.m analysis
% ==========================================
% Open loop transfer function of everything
% ==========================================
% The open loop transfer function maps voltage to radians/s
% Motor 0
g_q0 = tf_elec0 * TConst0 * tf_mech0;
h_q0 = BackEMF0;
oltf_q0 = tf_amp0 * (g_q0 / (1 + g_q0 * h_q0)) / tf('s'); 

% Simplified (these are verified to be correct)
ol_q0 = zpk(minreal(oltf_q0));

% Motor 1
g_q1 = tf_elec1 * TConst1 * tf_mech1;
h_q1 = BackEMF1;
oltf_q1 = tf_amp1 * (g_q1 / (1 + g_q1 * h_q1)) / tf('s');

% Simplified (also verified to be correct)
ol_q1 = zpk(minreal(oltf_q1));

% =====================[Finding KU and zero locations]========================
% Q0
zeroes_q0 = [1, 0.2838, 14.11];
ol_pid_q0 = ol_q0 * tf(zeroes_q0, [1, 0]);
KU_q0     = margin(ol_pid_q0);
Kd_q0     = KU_q0 / 2;
Kp_q0     = Kd_q0 * zeroes_q0(2);
Ki_q0     = Kd_q0 * zeroes_q0(3);
PID_q0    = [Kd_q0, Kp_q0, Ki_q0];

% Q1
zeroes_q1 = [1, 49.17, 0];
ol_pid_q1 = ol_q1 * tf(zeroes_q1, [1, 0]);
KU_q1     = margin(ol_pid_q1);
Kd_q1     = KU_q1 / 2;
Kp_q1     = Kd_q1 * zeroes_q1(2);
Ki_q1     = Kp_q1 * zeroes_q1(3);
PID_q1    = [Kd_q1, Kp_q1, Ki_q1];

% ==========================================
% Close loop transfer function of everything (might be useful in finding overall step/impulse response)
% ==========================================
% Motor 0
Kp0     = PID0(1);
Ki0     = PID0(2);
Kd0     = PID0(3);
% PID0_tf = tf([Kd0 Kp0 Ki0],[1, 0]);
% g_cl_q0 = PID0_tf * tf_amp0 * (g_q0 / (1 + g_q0 * h_q0)) / tf('s');
% h_cl_q0 = Sens0;
% cltf_q0 = g_cl_q0 / (1 + g_cl_q0 * h_cl_q0);

% Test PID impl
fb_q0 = 1;
cl_q0 = ol_pid_q0 / (1 + ol_pid_q0);

% Motor 1
Kp1     = PID1(1);
Ki1     = PID1(2);
Kd1     = PID1(3);
PID1_tf = tf([Kd1 Kp1 Ki1],[1, 0]);
g_cl_q1 = PID1_tf * tf_amp1 * (g_q1 / (1 + g_q1 * h_q1)) / tf('s');
h_cl_q1 = Sens1;
cltf_q1 = g_cl_q1 / (1 + g_cl_q1 * h_cl_q1);

%some useful commands 
%[k,poles] = rlocfind(sys)


% ================
% CONTROLLER GAINS
% ================

% Enter optimized PID values here.
% No more than 3 significant figures per gain value.
PID0 = [1 0 0];
PID1 = [1 0 0];
% PID0 = PID_q0;
% PID1 = PID_q1;

% Enter feedback sensor values here.
% The feedback gain maps voltage (V) from [-5, 5] to angles (rad) [-pi, pi]
% The gain has the units (rad/V)
FB0 = (SensAng * RadPerDeg) / SensV;    % rad
FB1 = FB0;

% =====================
% Set-Point Time Vector
% =====================

% The Time Vector is stored in a variable called "Time".
% It's initial value is equally spaced for all samples and is
% set in TRAJECTORY.M
%
% Redefine this vector here to optimize the build time of the part.
% You can define it analytically or type in the elements manually but
% you must not change the length because it must contain one value for
% each Xd/Yd position pair.
% In the Matlab window, enter "length(Time)" to see how big it is.

% The Time vector must range from 0 to TotalTime
% Time       = 0:SampleTime:TotalTime;       % DO NOT CHANGE TotalTime
