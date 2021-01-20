%computes modulation index
clear; close all; clc;

%load testing data
load('phase_amp.mat');
amp = double(amp);
phase = double(phase);

edges = linspace(-pi,pi,21);
%shifts = eegFS:10:7*eegFS;  %circular shifts for surrogates
shifts = 0;

%MI = raw modulation index
%MInorm = normalized modulation index
[MI, MInorm] = getmisur(amp,phase,edges,shifts);









