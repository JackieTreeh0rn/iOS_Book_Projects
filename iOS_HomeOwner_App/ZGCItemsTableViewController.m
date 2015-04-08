//
//  ZGCItemsTableViewController.m
//  iOS_HomeOwner_App
//
//  Created by EvilKernel on 4/4/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCItemsTableViewController.h"
#import "ZGCItemStore.h"
#import "ZGCItem.h"

@interface ZGCItemsTableViewController ()

@end

@implementation ZGCItemsTableViewController

/* Changing designated initializer to "init" (default is initWithStyle:)
 then will override superclass' designated initializer to call this one */
- (instancetype)init {
    // Call superclass designated initializer (rule)
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[ZGCItemStore sharedStore] createItem]; // initiates store, create 5 items
        }
    }
    return self;
}

/* Overriding superclass designated initializer to call mine */
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init]; // all instances will now use plainviewstyle
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* This is required to tell the tableview which kind of cell
     it should instantiate if there are no cells in the reuse pool
     when cellForView protocol method is called */
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.

    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section. equals n. of items in array
    return [[[ZGCItemStore sharedStore] allItems] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     // Create an instance of UITableViewCell, with default apperance
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
     */
    
    // Using conventional method to create UITableViewCell object via resuable indent.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Set the text on the cell with the descripton of the item
    // that is at the nth index of items (n = row this cell will appear on)
    NSArray *items = [[ZGCItemStore sharedStore] allItems];
    ZGCItem *item = items[indexPath.row];
    cell.textLabel.text = [item description];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
