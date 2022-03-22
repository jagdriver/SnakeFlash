// x="Test"
// console.log(x);
// console.log(1+1);

const dialog = require('node-dialog');
 
dialog.showSync({
    msg: 'Execution pauses here until user dismisses dialog.',
    
    // Same options as below
});
 
dialog.show({
    msg: 'Wow, native GUI feedback...',
    
    // Everything below is optional
    timeout: 3, // Seconds - floating point numbers are rounded
    title: 'node-dialog',
    icon: dialog.INFO,
    buttons: dialog.YES_NO_CANCEL,
    defaultButton: dialog.RIGHT,
})
.then((result) => {
    if(result === dialog.RESULT_TIMEOUT) {
        console.log('User did not respond in time.');
    }
    else if(result === dialog.RESULT_CANCEL) {
        console.log('User chose default button.');
    }
    else {
        console.log('Some other choice.');
    }
});